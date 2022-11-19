import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';
import 'package:smart_garage/utils/config.dart';
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
  int lightExt = 0;

  late List<int> lights = [];

  void getLight() async {
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
        lights = Config().getSwitchValueList(responseBody);
        lightL = lights[0];
        lightM = lights[1];
        lightR = lights[2];
        lightExt = lights[3];
      });
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        getLight();
      }
    }
  }

  void changeLight(String light, int varLight, int index) async {
    final uri = Config().urlLight;

    final headers = {
      'Content-Type': 'application/json',
    };

    Map bData = {'Light': light, 'Value': index};
    final body = json.encode(bData);

    http.Response response = await http.post(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    Log.log(Log.TAG_REQUEST, "$statusCode", Log.I);
    Log.log(Log.TAG_REQUEST, responseBody, Log.I);
    if (statusCode == 200) {
      setState(() {
        switch (varLight) {
          case 0:
            lightL = index;
            break;
          case 1:
            lightM = index;
            break;
          case 2:
            lightR = index;
            break;
          case 3:
            lightExt = index;
            break;
          default:
            break;
        }
      });
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        changeLight(light, varLight, index);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    lights.add(lightL);
    lights.add(lightM);
    lights.add(lightR);
    lights.add(lightExt);
    getLight();
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
                          icons: const [
                            FontAwesomeIcons.lightbulb,
                            FontAwesomeIcons.solidLightbulb,
                          ],
                          iconSize: 30.0,
                          activeBgColors: const [
                            [Colors.black45, Colors.black26],
                            [Colors.yellow, Colors.orange]
                          ],
                          animate:
                              true, // with just animate set to true, default curve = Curves.easeIn
                          curve: Curves
                              .bounceInOut, // animate must be set to true when using custom curve
                          onToggle: (index) {
                            if (index == 1) {
                              changeLight('Light_Ext', 3, 1);
                            } else if (index == 0) {
                              changeLight('Light_Ext', 3, 0);
                            }
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
                          icons: const [
                            FontAwesomeIcons.lightbulb,
                            FontAwesomeIcons.solidLightbulb,
                          ],
                          iconSize: 30.0,
                          activeBgColors: const [
                            [Colors.black45, Colors.black26],
                            [Colors.yellow, Colors.orange]
                          ],
                          animate:
                              true, // with just animate set to true, default curve = Curves.easeIn
                          curve: Curves
                              .bounceInOut, // animate must be set to true when using custom curve
                          onToggle: (index) {
                            if (index == 1) {
                              changeLight('Light_L', 0, 1);
                            } else if (index == 0) {
                              changeLight('Light_L', 0, 0);
                            }
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
                          icons: const [
                            FontAwesomeIcons.lightbulb,
                            FontAwesomeIcons.solidLightbulb,
                          ],
                          iconSize: 30.0,
                          activeBgColors: const [
                            [Colors.black45, Colors.black26],
                            [Colors.yellow, Colors.orange]
                          ],
                          animate:
                              true, // with just animate set to true, default curve = Curves.easeIn
                          curve: Curves
                              .bounceInOut, // animate must be set to true when using custom curve
                          onToggle: (index) {
                            if (index == 1) {
                              changeLight('Light_M', 1, 1);
                            } else if (index == 0) {
                              changeLight('Light_M', 1, 0);
                            }
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
                          icons: const [
                            FontAwesomeIcons.lightbulb,
                            FontAwesomeIcons.solidLightbulb,
                          ],
                          iconSize: 30.0,
                          activeBgColors: const [
                            [Colors.black45, Colors.black26],
                            [Colors.yellow, Colors.orange]
                          ],
                          animate:
                              true, // with just animate set to true, default curve = Curves.easeIn
                          curve: Curves
                              .bounceInOut, // animate must be set to true when using custom curve
                          onToggle: (index) {
                            if (index == 1) {
                              changeLight('Light_R', 2, 1);
                            } else if (index == 0) {
                              changeLight('Light_R', 2, 0);
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
