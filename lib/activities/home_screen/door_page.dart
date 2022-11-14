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
  Color garageOpenBtn = Colors.grey;
  Color garageStopBtn = Colors.grey;
  Color garageCloseBtn = Colors.grey;
  String resultDebug = "";
  String stat = "CLOSE";

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
    String nStat = Config().getDoorValue(responseBody);
    setState(() {
      setBtnColors(nStat);
    });
  }

  void setBtnColors(String nStat) {
    switch (stat) {
      case "STOP":
        garageStopBtn = Colors.grey;
        break;
      case "CLOSE":
        garageCloseBtn = Colors.grey;
        break;
      default:
        garageOpenBtn = Colors.grey;
        break;
    }
    switch (nStat) {
      case "STOP":
        garageStopBtn = Colors.cyan;
        break;
      case "CLOSE":
        garageCloseBtn = Colors.cyan;
        break;
      default:
        garageOpenBtn = Colors.cyan;
        break;
    }
    stat = nStat;
  }

  void openCloseDoor(String command) async {
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
      resultDebug = responseBody;
      setBtnColors(command);
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
                        // Open door
                        openCloseDoor("OPEN");
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(garageOpenBtn),
                      ),
                      child: const Text("OPEN"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Stop door
                        openCloseDoor("STOP");
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(garageStopBtn),
                      ),
                      child: const Text("STOP"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Close door
                        openCloseDoor("CLOSE");
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(garageCloseBtn),
                      ),
                      child: const Text("CLOSE"),
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
