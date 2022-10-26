import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_garage/utils/config.dart';

class DashPage extends StatefulWidget {
  const DashPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DashPage> createState() {
    return _DashPageState();
  }
}

class _DashPageState extends State<DashPage> {
  String occupancy = "FULL";
  String garageDoorStatus = "CLOSED";
  String drivewayLights = "OFF";
  String garageIndoorLights = "OFF";
  double coLevel = 0.1;

  void getDoorStatus() async {
    final uri = Config().testUrlDoor;
    final headers = {'Content-Type': 'application/json'};

    http.Response response = await http.get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print(statusCode);
    print('RES: .$responseBody.');
    setState(() {
      garageDoorStatus = Config().getDoorValue(responseBody[0]);
    });
  }

  void getDrivewayLights() async {
    final uri = Config().testUrlLights;
    final headers = {'Content-Type': 'application/json', 'Light': 'Light_Ext'};

    http.Response response = await http.get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print(statusCode);
    print('RES: .$responseBody.');
    setState(() {
      drivewayLights = Config().getSwitchValue(responseBody[0]);
    });
  }

  @override
  void initState() {
    super.initState();
    getDoorStatus();
    getDrivewayLights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
            elevation: 50,
            shadowColor: Colors.black,
            child: SizedBox(
              width: 300,
              height: 500,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: const SizedBox(
                        width: 300,
                        height: 200,
                        child: Card(
                          elevation: 5,
                          shadowColor: Colors.black,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text('Occupancy'),
                                Text(occupancy),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text('Garage Door Status'),
                                Text(garageDoorStatus),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text('Driveway Lights'),
                                Text(drivewayLights),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text('Garage Indoor Lights'),
                                Text(garageIndoorLights),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Text('CO Level Inside Garage'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: LinearProgressIndicator(
                              minHeight: 10,
                              value: coLevel,
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
