import 'package:flutter/material.dart';
import 'package:greenhouse_app/mqtt/mqtt_client.dart';

class RenderedSelection extends StatefulWidget {
  const RenderedSelection({
    Key? key,
    required this.index,
    required this.client,
  }) : super(key: key);
  final ValueNotifier<int> index;
  final MQTTClientWrapper client;

  @override
  State<RenderedSelection> createState() => _RenderedSelectionState();
}

class _RenderedSelectionState extends State<RenderedSelection> {
  final key = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  late String temperature = "";
  late String humidity = "";

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.index,
      builder: (context, child) {
        Widget selection = const Text("Maintain");
        switch (widget.index.value) {
          case 0:
            selection = Form(
              key: key,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        label: Row(
                          children: [
                            Text("Temperature"),
                            Icon(Icons.device_thermostat_sharp)
                          ],
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      temperature = value;
                    },
                    validator: (value) {
                      final double? data = double.tryParse(value!.trim());
                      if (value.trim().isEmpty || data == null) {
                        return "Miss me with the bs";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (key.currentState!.validate()) {
                        final message = "$temperature:$humidity";
                        widget.client.publishMessage(message, "ESP/Dart");
                      }
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                          dismissDirection: DismissDirection.startToEnd,
                          content: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                            child: Text("Published :)",
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          )));
                    },
                    child: const Text("Publish"),
                  ),
                ],
              ),
            );
            break;
          case 1:
            selection = Form(
              key: formKey1,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Row(
                        children: [
                          Text("Humidity"),
                          Icon(Icons.water_drop_outlined)
                        ],
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      humidity = value;
                    },
                    validator: (value) {
                      final double? data = double.tryParse(value!.trim());
                      if (value.trim().isEmpty || data == null) {
                        return "Miss me with the bs";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey1.currentState!.validate()) {
                        final message = "$temperature:$humidity";
                        widget.client.publishMessage(message, "ESP/Dart");
                      }
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                          dismissDirection: DismissDirection.startToEnd,
                          content: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                            child: Text("Published :)",
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          )));
                    },
                    child: const Text("Publish"),
                  ),
                ],
              ),
            );
            break;
          case 2:
            selection = Form(
              key: formKey2,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Row(
                        children: [
                          Text("Temperature"),
                          Icon(Icons.device_thermostat_sharp)
                        ],
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      temperature = value;
                    },
                    validator: (value) {
                      final double? data = double.tryParse(value!.trim());
                      if (value.trim().isEmpty || data == null || data >= 32) {
                        return "Miss me with the bs";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Row(
                        children: [
                          Text("Humidity"),
                          Icon(Icons.water_drop_outlined)
                        ],
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      humidity = value;
                    },
                    validator: (value) {
                      final double? data = double.tryParse(value!.trim());
                      if (value.trim().isEmpty || data == null) {
                        return "Miss me with the bs";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey2.currentState!.validate()) {
                        final message = "$temperature:$humidity";
                        widget.client.publishMessage(message, "ESP/Dart");
                      }
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                          dismissDirection: DismissDirection.startToEnd,
                          content: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                            child: Text("Published :)",
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),),);
                    },
                    child: const Text("Publish"),
                  ),
                ],
              ),
            );
            break;
        }
        return selection;
      },
    );
  }
}
