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
  Color coColor = Colors.green;

  void getDoorStatus() async {
    final uri = Config().getUrlDoor;
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
      garageDoorStatus = Config().getDoorValue(responseBody);
    });
  }

  void getLights() async {
    final uri = Config().testUrlLights;
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
      drivewayLights = Config().getSwitchValueJson(responseBody, "LightExt");
      garageIndoorLights = Config().getSwitchValueIndoorJson(responseBody);
    });
  }

  void getCoValue() async {
    final uri = Config().getUrlCo;
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
      coLevel = double.parse(responseBody) / 100;
      coColor = Config().getCoColor(coLevel);
    });
  }

  @override
  void initState() {
    super.initState();
    getDoorStatus();
    // getLights();
    // getCoValue();
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
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(coColor),
                              backgroundColor: Colors.grey,
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
