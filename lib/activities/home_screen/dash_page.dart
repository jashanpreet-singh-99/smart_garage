import 'dart:convert';

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
  String progressCoLevel = "Colors.green";
  Color progressColor = Color.fromARGB(255, 42, 164, 37);

  //edit
  void getStatusAll() async {
    final url = Config().getGarageData;
    final headers = {'Content-Type': 'application/json'};
    http.Response res = await http.get(
      url,
      headers: headers,
    );

    final resBody = jsonDecode(res.body);
    String door = resBody['door'];
    final light = resBody['Lights'];

    String Light_Ext = light['Light_Ext'];
    String Light_R = light['Light_R'];
    String Light_L = light['Light_L'];
    String Light_M = light['Light_M'];

    setState(() {
      garageDoorStatus = Config().getDoorValue(door);
      drivewayLights = Config().getSwitchValue(Light_Ext);
      if (Light_L == "1" || Light_M == "1" || Light_R == "1") {
        garageIndoorLights = "ON";
      }
    });
  }

//get door value
  void getDoorStatus() async {
    final uri = Config().getUrlDoor;
    final headers = {'Content-Type': 'application/json'};

    http.Response response = await http.get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    final responseBody = jsonDecode(response.body);
    print(statusCode);
    print('RES: .$responseBody.');
    setState(() {
      garageDoorStatus = Config().getDoorValue(responseBody['door']);
    });
  }

  void getLightStatus() async {
    final uri = Config().getUrlLight;
    final headers = {'Content-Type': 'application/json'};

    http.Response response = await http.get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    final responseBody = jsonDecode(response.body);
    print(statusCode);
    print('RES: .$responseBody.');

    String light_Ext = responseBody['Light_Ext'];
    String light_L = responseBody['Light_L'];
    String light_M = responseBody['Light_M'];
    String light_R = responseBody['Light_R'];

    setState(() {
      drivewayLights = Config().getSwitchValue(light_Ext);
      if (light_L == "1" || light_M == "1" || light_R == "1") {
        garageIndoorLights = "ON";
      }
    });
  }

  void getCoStatus() async {
    final uri = Config().getUrlCo;
    final headers = {'Content-Type': 'application/json'};

    http.Response response = await http.get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    final responseBody = jsonDecode(response.body);
    print(statusCode);
    print('RES: .$responseBody.');

    setState(() {
      coLevel = double.parse(responseBody['CO']);
      changeColor();
    });
  }

  void changeColor() {
    if (coLevel <= 0.5) {
      progressColor = Colors.green;
    } else if (coLevel < 0.75) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }
  }

/**
//remove this function
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
**/
  @override
  void initState() {
    super.initState();
    getDoorStatus();
    //getDrivewayLights();
    getLightStatus();
    getCoStatus();
    changeColor();
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Occupancy'),
                                Text(occupancy),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Garage Door Status'),
                                Text(garageDoorStatus),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Driveway Lights'),
                                Text(drivewayLights),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Garage Indoor Lights'),
                                Text(garageIndoorLights),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              backgroundColor:
                                  Color.fromARGB(255, 130, 116, 116),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(progressColor),
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
