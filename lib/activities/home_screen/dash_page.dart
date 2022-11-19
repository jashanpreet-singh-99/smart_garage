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
      setState(() {
        garageDoorStatus = Config().getDoorValue(responseBody);
      });
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        getDoorStatus();
      }
    }
  }

  void getLights() async {
    final uri = Config().urlLight;
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
      setState(() {
        drivewayLights = Config().getSwitchValueJson(responseBody, "Light_Ext");
        garageIndoorLights = Config().getSwitchValueIndoorJson(responseBody);
      });
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        getLights();
      }
    }
  }

  void getCoValue() async {
    final uri = Config().urlCo;
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
      setState(() {
        coLevel = Config().getCoLevelJson(responseBody);
        coColor = Config().getCoColor(coLevel);
      });
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        getCoValue();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getDoorStatus();
    getLights();
    getCoValue();
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
