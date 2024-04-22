import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// connection states for easy identification
enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}

enum MqttSubscriptionState {
  IDLE,
  BUSY,
  SUBSCRIBED
}

class MQTTClientWrapper {

  //Declaring a MQTTSeverClient
  late final MqttServerClient client;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  Enum get _subscriptionState => subscriptionState;
  Enum get stateOfConnection => connectionState;
  Stream<List<MqttReceivedMessage<MqttMessage>>>? get updates => client.updates;

  late String myMessage = '';
  late String myHumid = '';
  late String myTemp = '';

  // using async tasks, so the connection won't hinder the code flow
  void prepareMqttClient(void Function() updateState, void Function() resetState) async {
    _setupMqttClient();
    await _connectClient();
    if(connectionState == MqttCurrentConnectionState.CONNECTED){
      updateState();
    }else{
      resetState();
    }
  }

  // waiting for the connection, if an error occurs, print it and disconnect
  Future<void> _connectClient() async {
    try {
      print('client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client.connect('Nicholas', 'Nicholas0746011197');
    } on Exception catch (e) {
      print('client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }

    // when connected, print a confirmation, else print an error
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('client connected');
    } else {
      print(
          'ERROR client connection failed - disconnecting, status is ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
  }

  void disconnectClient(){
    print(
        'ERROR client connection disconnected - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
  }

  void _setupMqttClient() {
    client = MqttServerClient.withPort('169a990d3f304db2a114ff5cd53e6b58.s1.eu.hivemq.cloud', 'Nicholas', 8883);
    // the next 2 lines are necessary to connect with tls, which is used by HiveMQ Cloud
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 200;
    client.onDisconnected = _onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = _onSubscribed;
    client.onUnsubscribed = _onUnsubscribed;
    }
  void subscribeToTopic(String topicName) {
    print('Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.atLeastOnce);
  }


  void unsubscribe( String topic){
    print("Unsubscribed successfully!");
    client.unsubscribe(topic);
  }

  void publishMessage(String message, String publisher) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('Publishing message "$message" to topic $publisher');
    client.publishMessage(publisher, MqttQos.exactlyOnce, builder.payload!);
  }

  // callbacks for different events
  void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onUnsubscribed(String? topic){
    print('OnUnsubscribe client callback - Client unsubscribed from $topic');
    subscriptionState = MqttSubscriptionState.IDLE;
  }

  bool onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    print('OnConnected client callback - Client connection was successful');
    return true;
  }

  void _onPublished(){

  }

}