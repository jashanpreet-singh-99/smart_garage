import 'dart:convert';

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
  String garageDoorStatus = "CLOSE";
  String garageLock = "LOCK";
  String resultDebug = "";
  Color openButtonColor = Colors.blue;
  Color closeButtonColor = Colors.blue;
  Color lockButtonColor = Colors.blue;
  String lockButtonText = "Lock";

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
      if (garageDoorStatus == "LOCK") {
        lockButtonText = "Unlock";
      }
      buttonSet();
    });
  }

  //set door value new
  void setDoorStatus(String command) async {
    final uri = Config().setUrlDoor;
    final headers = {'Content-Type': 'application/json'};

    final body = {'door': command};

    http.Response response = await http.put(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    final responseBody = jsonDecode(response.body);
    print(statusCode);
    print('RES: .$responseBody.');

    setState(() {
      getDoorStatus();
      buttonSet();
      resultDebug = '$command ing Door';
    });
  }

//buuton enable disable
  void buttonSet() {
    if (garageDoorStatus == "OPEN") {
      openButtonColor = Colors.grey;
      closeButtonColor = Colors.blue;
      lockButtonColor = Colors.blue;
      lockButtonText = "Lock";
    } else if (garageDoorStatus == "CLOSE") {
      openButtonColor = Colors.blue;
      closeButtonColor = Colors.grey;
      lockButtonColor = Colors.blue;
      lockButtonText = "Lock";
    } else if (garageDoorStatus == "LOCK") {
      openButtonColor = Colors.blue;
      closeButtonColor = Colors.blue;
      lockButtonColor = Colors.blue;
      lockButtonText = "Unlock";
    }
  }
/**
//old function
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
//old function
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

**/

  @override
  void initState() {
    super.initState();
    getDoorStatus();
    buttonSet();
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
                  Image.asset('assets/garage.png'),
                  Padding(padding: const EdgeInsets.all(30.0)),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Open or Close door
                        //openCloseDoor();
                        print('pressed opening door');
                        setDoorStatus("OPEN");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: openButtonColor,
                      ),
                      child: Text("Open"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        //close
                        //openCloseDoor();
                        print('pressed closing door');
                        setDoorStatus("CLOSE");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: closeButtonColor,
                      ),
                      child: Text("Close"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Open or Close door
                        //stopDoor();
                        print('pressed locking door');
                        setDoorStatus("LOCK");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lockButtonColor,
                      ),
                      child: Text(lockButtonText),
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
    );
  }
}
