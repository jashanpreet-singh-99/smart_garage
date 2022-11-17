import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
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

class _DoorPageState extends State<DoorPage> with TickerProviderStateMixin {
  Color garageOpenBtn = Colors.grey;
  Color garageStopBtn = Colors.grey;
  Color garageCloseBtn = Colors.grey;
  String resultDebug = "";
  String stat = "CLOSE";

  Color connectionStat = Colors.blue;

  bool firstRun = true;

  late AnimationController animationController;

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
    String nStat = Config().getDoorValue(responseBody);
    setState(() {
      setBtnColors(nStat);
      setDoorConnectionStatus("{\"status\":1}");
    });
    firstRun = false;
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
        animationController.stop();
        garageStopBtn = Colors.cyan;
        break;
      case "CLOSE":
        if (firstRun) {
        } else {
          animationController.reverse();
        }
        garageCloseBtn = Colors.cyan;
        break;
      default:
        if (firstRun) {
          animationController.animateTo(animationController.upperBound,
              duration: const Duration(milliseconds: 500));
        } else {
          animationController.forward();
        }
        garageOpenBtn = Colors.cyan;
        break;
    }
    stat = nStat;
  }

  void openCloseDoor(String command) async {
    final uri = Config().setUrlDoor;
    final headers = {'Content-Type': 'application/json'};

    Map bData = {'command': command};
    final body = json.encode(bData);

    http.Response response = await http.post(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print(statusCode);
    print('RES: .$responseBody.');
    setState(() {
      setDoorConnectionStatus(responseBody);
      setBtnColors(command);
    });
  }

  @override
  void initState() {
    super.initState();
    getDoorStatus();
    animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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
                    child: Lottie.asset(
                      'assets/garage_door.json',
                      repeat: false,
                      animate: false,
                      controller: animationController,
                      onLoaded: (composition) {
                        animationController.duration = composition.duration;
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(1.0)),
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
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: connectionStat),
                        )),
                      ),
                      child: Text(resultDebug,
                          style: TextStyle(color: connectionStat)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setDoorConnectionStatus(String responseBody) {
    resultDebug = Config.getConnectionStat(responseBody);
    if (resultDebug == "SUCCESS") {
      connectionStat = Colors.green;
    } else if (resultDebug == "FAILURE") {
      connectionStat = Colors.red;
    }
  }
}
