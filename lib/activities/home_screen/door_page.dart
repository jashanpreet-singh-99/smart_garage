import 'dart:convert';
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
  int stat = -1;

  Color connectionStat = Colors.blue;

  bool firstRun = true;
  double animTime = 0.0;
  bool disposed = false;

  late AnimationController animationController;

  void getDoorAnimation() async {
    final uri = Config().urlDoorA;
    final headers = {'Content-Type': 'application/json'};

    http.Response response = await http.get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    Log.log(Log.TAG_REQUEST, "$statusCode", Log.I);
    Log.log(Log.TAG_REQUEST, responseBody, Log.I);
    if (statusCode == 200) {
      Map<String, dynamic> jsonObj = jsonDecode(responseBody);
      try {
        if (!disposed) {
          setState(() {
            animTime = jsonObj['DoorAnim'];
            getDoorStatus();
          });
        }
      } on Exception catch (e) {
        Log.log(Log.TAG_REQUEST, "Error : $e", Log.E);
      }
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        getDoorAnimation();
      }
    }
  }

  void getDoorStatus() async {
    final uri = Config().urlDoor;
    final headers = {'Content-Type': 'application/json'};

    http.Response response = await http.get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    Log.log(Log.TAG_REQUEST, "$statusCode", Log.I);
    Log.log(Log.TAG_REQUEST, responseBody, Log.I);
    if (statusCode == 200) {
      int nStat = Config().getDoorValue(responseBody);
      try {
        if (!disposed) {
          setState(() {
            setBtnColors(nStat);
            setDoorConnectionStatus("{\"status\":1}");
          });
          firstRun = false;
        }
      } on Exception catch (e) {
        Log.log(Log.TAG_REQUEST, "Error : $e", Log.E);
      }
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        getDoorStatus();
      }
    }
  }

  void setBtnColors(int nStat) {
    switch (stat) {
      case 0:
        garageStopBtn = Colors.grey;
        break;
      case -1:
        garageCloseBtn = Colors.grey;
        break;
      default:
        garageOpenBtn = Colors.grey;
        break;
    }
    switch (nStat) {
      case 0:
        if (firstRun) {
          animationController.animateTo(animTime,
              duration: const Duration(milliseconds: 100));
        } else {
          animationController.stop();
        }

        garageStopBtn = Colors.cyan;
        break;
      case -1:
        if (firstRun) {
          animationController.animateTo(animTime,
              duration: const Duration(milliseconds: 100));
        } else {
          animationController.reverse();
        }
        garageCloseBtn = Colors.cyan;
        break;
      default:
        if (firstRun) {
          animationController.animateTo(animTime,
              duration: const Duration(milliseconds: 100));
        } else {
          animationController.forward();
        }
        garageOpenBtn = Colors.cyan;
        break;
    }
    stat = nStat;
  }

  void openCloseDoor(int command) async {
    final uri = Config().urlDoor;
    final headers = {'Content-Type': 'application/json'};

    Map bData = {'Command': command};
    final body = json.encode(bData);

    http.Response response = await http.post(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    Log.log(Log.TAG_REQUEST, "$statusCode", Log.I);
    Log.log(Log.TAG_REQUEST, responseBody, Log.I);
    if (statusCode == 200) {
      setState(() {
        setDoorConnectionStatus(responseBody);
        setBtnColors(command);
      });
      firstRun = false;
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        openCloseDoor(command);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
    getDoorAnimation();
  }

  @override
  void dispose() {
    animationController.dispose();
    disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          shadowColor: Colors.black,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Text(
                      "GARAGE DOOR CONTROLS",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(2))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Open door
                        openCloseDoor(1);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(garageOpenBtn),
                        shadowColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
                        child: Text(
                          "OPEN",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Stop door
                        openCloseDoor(0);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(garageStopBtn),
                        shadowColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
                        child: Text(
                          "STOP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Close door
                        openCloseDoor(-1);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(garageCloseBtn),
                        shadowColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
                        child: Text(
                          "CLOSE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
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
