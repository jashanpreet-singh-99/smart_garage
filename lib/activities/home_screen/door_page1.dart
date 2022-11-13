/**

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_garage/utils/config.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

int initialIndex = 1;

class DoorPage extends StatefulWidget {
  const DoorPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DoorPage> createState() {
    return _DoorPageState();
  }
}

class _DoorPageState extends State<DoorPage> {
  String garageDoorStatus = "CLOSED";
  String garageLock = "LOCK";
  String resultDebug = "";

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

  void openCloseDoor() async {
    String command = Config().getDoorValue(
        ((Config().getDoorInt(garageDoorStatus) + 1) % 2).toString());
    final uri = Config().testUrlDoor;
    final headers = {'Content-Type': 'application/json', 'Command': command};

    http.Response response = await http.put(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print(statusCode);
    print('RES: .$responseBody.');
    setState(() {
      garageDoorStatus = command;
      garageLock = 'LOCK';
      resultDebug = responseBody;
    });
  }

  void stopDoor() async {
    final uri = Config().testUrlDoorStop;
    final headers = {'Content-Type': 'application/json', 'Status': garageLock};

    http.Response response = await http.put(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    initialIndex = statusCode;
    String responseBody = response.body;
    print(statusCode);
    print('RES: .$responseBody.');
    String status = Config().getDoorLockValue(
        ((Config().getDoorLockInt(garageLock) + 1) % 2).toString());
    setState(() {
      garageLock = status;
      resultDebug = responseBody;
    });
  }

  @override
  void initState() {
    super.initState();
    getDoorStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
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
                  Image.asset('assets/garage.png'),
                  //const Text("Door"),
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ToggleSwitch(
                        minWidth: 80.0,
                        cornerRadius: 20.0,
                        activeBgColors: [
                          [Colors.green[800]!],
                          [Colors.red[800]!]
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: 0,
                        totalSwitches: 2,
                        labels: ['Open', 'Close'],
                        radiusStyle: true,
                        onToggle: (index) {
                          openCloseDoor();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ToggleSwitch(
                        minWidth: 90.0,
                        cornerRadius: 20.0,
                        activeBgColors: [
                          [Colors.green[800]!],
                          [Colors.red[800]!]
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: initialIndex,
                        totalSwitches: 2,
                        labels: ['Lock', 'Release'],
                        radiusStyle: true,
                        onToggle: (index) {
                          stopDoor();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(resultDebug),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
**/