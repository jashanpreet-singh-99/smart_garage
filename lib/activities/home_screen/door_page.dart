import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_garage/utils/config.dart';

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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Open or Close door
                        openCloseDoor();
                      },
                      child: Text(garageDoorStatus),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Open or Close door
                        stopDoor();
                      },
                      child: Text(garageLock),
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
