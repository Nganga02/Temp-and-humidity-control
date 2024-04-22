import 'package:flutter/material.dart';
import 'package:greenhouse_app/mqtt/mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

class STBuilder extends StatelessWidget {
  STBuilder({
    Key? key,
    required this.client,
    required this.topic,
    required this.subscribed,
  }) : super(key: key);

  final MQTTClientWrapper client;
  final String topic;
  final bool subscribed;

  late List<String> receivedData = [];

  @override
  Widget build(BuildContext context) {
    Widget content = const SizedBox(
      height: 400,
      width:  double.infinity,
      child:  Center(
        child: Text("Not yet subscribed"),
      ),
    );
    if (subscribed) {
      client.subscribeToTopic(topic);
      content = SizedBox(
        height: 400,
        width: double.infinity,
        child: StreamBuilder(
          stream: client.updates,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text("No data",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              );
            }
            final updates = snapshot.data![0];
            final latestUpdate = updates.payload as MqttPublishMessage;
            final String receivedText;
            if (latestUpdate.variableHeader!.topicName == topic) {
              receivedText = MqttPublishPayload.bytesToStringAsString(
                  latestUpdate.payload.message);

              //Implementing a stack data structure
              receivedData.add(receivedText);
              if(receivedData.length > 7)
                {
                  receivedData.remove(receivedData[0]);
                }
            }
            return Center(
              child: ListView.builder(
                itemCount: receivedData.length,
                itemBuilder: (context, index) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        receivedData[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else if (!subscribed) {
      client.unsubscribe(topic);
      content = const SizedBox(
        height: 400,
        width: double.infinity,
        child:  Center(
          child: Text("Not yet subscribed"),
        ),
      );
    }

    return content;
  }
}
