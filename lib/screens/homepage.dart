import 'package:flutter/material.dart';


import 'package:greenhouse_app/widgets/rendered_selection.dart';
import '../mqtt/mqtt_client.dart';
import 'package:greenhouse_app/widgets/streambuilder.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MQTTClientWrapper newClient = MQTTClientWrapper();
  late bool connected = false;
  late bool subscribedTemp = false;
  late bool humidSubscribed = false;
  late ValueNotifier<int> currentSelection = ValueNotifier(0);

  void _updateState() {
    setState(() {
      connected = true;
    });
  }

  void _resetState() {
    setState(() {
      connected = false;
    });
  }

  final List<String> entries = ["Temperature", "Humidity", "Both"];

  @override
  void initState() {
    newClient.prepareMqttClient(_updateState, _resetState);
    super.initState();
  }

  @override
  void dispose() {
    newClient.disconnectClient();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(
        title: Text(
          "Temperature and Humidity control",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor.withRed(50),
            fixedSize: Size(150, 70)
          ),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => Container(
                  height: 700,
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      DropdownMenu(
                        dropdownMenuEntries: entries
                            .map((element) =>
                            DropdownMenuEntry(
                                value: entries
                                    .indexOf(element),
                                label: element))
                            .toList(),
                        width: MediaQuery.of(context)
                            .size
                            .width *
                            0.9,
                        onSelected: (value) {
                          setState(() {
                            currentSelection.value = value!;
                          });
                          print(currentSelection);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RenderedSelection(
                          index: currentSelection,
                          client: newClient)
                    ],
                  ),
                ));
          },
          child:  Text("Publish",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold
          ),),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Center(
                    child: Icon(
                      newClient.connectionState ==
                              MqttCurrentConnectionState.CONNECTED
                          ? Icons.check
                          : Icons
                              .signal_cellular_connected_no_internet_0_bar_sharp,
                      color: newClient.connectionState ==
                              MqttCurrentConnectionState.CONNECTED
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 3,
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).scaffoldBackgroundColor),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: Text("Humidity",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          child: Center(
                            child: STBuilder(
                              client: newClient,
                              topic: "ESP/humid",
                              subscribed: humidSubscribed,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(
                              () {
                                humidSubscribed = !humidSubscribed;
                              },
                            );
                          },
                          child: Text(
                              humidSubscribed ? "Unsubscribe" : "Subscribe"),
                        ),
                      ]),
                ),
                const SizedBox(height: 40),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 3,
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).scaffoldBackgroundColor),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: Text("Temperature",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          child: Center(
                            child: STBuilder(
                              client: newClient,
                              topic: "ESP/temp",
                              subscribed: subscribedTemp,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(
                              () {
                                subscribedTemp = !subscribedTemp;
                              },
                            );
                          },
                          child: Text(
                              subscribedTemp ? "Unsubscribe" : "Subscribe"),
                        ),
                      ]),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


