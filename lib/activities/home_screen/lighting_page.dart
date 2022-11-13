import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_garage/utils/config.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LightingPage extends StatefulWidget {
  const LightingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LightingPage> createState() {
    return _LightingPageState();
  }
}

class _LightingPageState extends State<LightingPage> {
  int lightL = 0;
  int lightR = 0;
  int lightM = 0;
  int lightExt = 1;

  late List<String> lights = [];

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
      lightExt = int.parse(light_Ext);
      lightL = int.parse(light_L);
      lightM = int.parse(light_M);
      lightR = int.parse(light_R);
    });
  }

/**
//get light old
  void getLight(String light, int varLight) async {
    final uri = Config().testUrlLights;
    final headers = {'Content-Type': 'application/json', 'Light': light};

    http.Response response = await http.get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print(statusCode);
    print('RES: .$responseBody.');
    setState(() {
      lights[varLight] = Config().getSwitchValue(responseBody[0]);
    });
  }
  **/
  // new change light
  void changeLightStatus(String light, int varLight) async {
    final uri = Config().getUrlLight;
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = {'Light': light, 'Value': varLight};

    http.Response response = await http.put(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print(statusCode);
    print('RES: .$responseBody.');
    setState(() {});
  }

/**
//change light old
  void changeLight(String light, int varLight) async {
    String value = Config().getSwitchValue(
        ((Config().getSwitchInt(lights[varLight]) + 1) % 2).toString());
    print(value);
    int val = Config().getSwitchInt(value);
    final uri = Config().testUrlLights;
    final headers = {
      'Content-Type': 'application/json',
      'Light': light,
      'Value': val.toString()

    };

    http.Response response = await http.put(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print(statusCode);
    print('RES: .$responseBody.');
    setState(() {
      lights[varLight] = value;
    });
  }**/

  @override
  void initState() {
    super.initState();
    getLightStatus();
    /**
    lights.add(lightFL);
    lights.add(lightFR);
    lights.add(lightML);
    lights.add(lightMM);
    lights.add(lightMR);
    lights.add(lightRL);
    lights.add(lightRM);
    lights.add(lightRR);
    lights.add(lightExt);
    getLight("Light_F_L", 0);
    getLight("Light_F_R", 1);
    getLight("Light_M_L", 2);
    getLight("Light_M_M", 3);
    getLight("Light_M_R", 4);
    getLight("Light_R_L", 5);
    getLight("Light_R_M", 6);
    getLight("Light_R_R", 7);
    getLight("Light_Ext", 8);
        **/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Card(
        elevation: 100,
        shadowColor: Colors.black,
        child: SizedBox(
          width: 300,
          height: 640,
          child: Padding(
            //padding: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.only(top: 60.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/light_icon.png',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("External Lights"),
                        ToggleSwitch(
                          minWidth: 50.0,
                          minHeight: 50.0,
                          initialLabelIndex: lightExt,
                          cornerRadius: 20.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 2,
                          icons: [
                            FontAwesomeIcons.lightbulb,
                            FontAwesomeIcons.solidLightbulb,
                          ],
                          iconSize: 30.0,
                          activeBgColors: [
                            [Colors.black45, Colors.black26],
                            [Colors.yellow, Colors.orange]
                          ],
                          animate:
                              true, // with just animate set to true, default curve = Curves.easeIn
                          curve: Curves
                              .bounceInOut, // animate must be set to true when using custom curve
                          onToggle: (index) {
                            if (index == 1) {
                              print('switched to: $index');
                              changeLightStatus("Light_Ext", 1);
                            } else if (index == 0) {
                              print('switched to: $index');
                              changeLightStatus("Light_Ext", 0);
                            }
                            //print('switched to: $index');
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Left Lights"),
                        ToggleSwitch(
                          minWidth: 50.0,
                          minHeight: 50.0,
                          initialLabelIndex: lightL,
                          cornerRadius: 20.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 2,
                          icons: [
                            FontAwesomeIcons.lightbulb,
                            FontAwesomeIcons.solidLightbulb,
                          ],
                          iconSize: 30.0,
                          activeBgColors: [
                            [Colors.black45, Colors.black26],
                            [Colors.yellow, Colors.orange]
                          ],
                          animate:
                              true, // with just animate set to true, default curve = Curves.easeIn
                          curve: Curves
                              .bounceInOut, // animate must be set to true when using custom curve
                          onToggle: (index) {
                            if (index == 1) {
                              print('switched to: $index');
                              changeLightStatus("Light_L", 1);
                            } else if (index == 0) {
                              print('switched to: $index');
                              changeLightStatus("Light_L", 0);
                            }
                            //print('switched to: $index');
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Middle Lights"),
                        ToggleSwitch(
                          minWidth: 50.0,
                          minHeight: 50.0,
                          initialLabelIndex: lightM,
                          cornerRadius: 20.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 2,
                          icons: [
                            FontAwesomeIcons.lightbulb,
                            FontAwesomeIcons.solidLightbulb,
                          ],
                          iconSize: 30.0,
                          activeBgColors: [
                            [Colors.black45, Colors.black26],
                            [Colors.yellow, Colors.orange]
                          ],
                          animate:
                              true, // with just animate set to true, default curve = Curves.easeIn
                          curve: Curves
                              .bounceInOut, // animate must be set to true when using custom curve
                          onToggle: (index) {
                            if (index == 1) {
                              print('switched to: $index');
                              changeLightStatus("Light_M", 1);
                            } else if (index == 0) {
                              print('switched to: $index');
                              changeLightStatus("Light_M", 0);
                            }
                            //print('switched to: $index');
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Rights Lights"),
                        ToggleSwitch(
                          minWidth: 50.0,
                          minHeight: 50.0,
                          initialLabelIndex: lightR,
                          cornerRadius: 20.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 2,
                          icons: [
                            FontAwesomeIcons.lightbulb,
                            FontAwesomeIcons.solidLightbulb,
                          ],
                          iconSize: 30.0,
                          activeBgColors: [
                            [Colors.black45, Colors.black26],
                            [Colors.yellow, Colors.orange]
                          ],
                          animate:
                              true, // with just animate set to true, default curve = Curves.easeIn
                          curve: Curves
                              .bounceInOut, // animate must be set to true when using custom curve
                          onToggle: (index) {
                            if (index == 1) {
                              print('switched to: $index');
                              changeLightStatus("Light_R", 1);
                            } else if (index == 0) {
                              print('switched to: $index');
                              changeLightStatus("Light_R", 0);
                            }
                            //print('switched to: $index');
                          },
                        ),
                      ],
                    ),
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
