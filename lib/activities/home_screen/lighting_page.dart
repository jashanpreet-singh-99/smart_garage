import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_garage/utils/config.dart';

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
  String lightL = "OFF";
  String lightM = "OFF";
  String lightR = "OFF";
  String lightExt = "OFF";

  late List<String> lights = [];

  void getLight() async {
    final uri = Config().getUrlLight;
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
      lights = Config().getSwitchValueList(responseBody, lights);
    });
  }

  void changeLight(String light, int varLight) async {
    String value = Config().getSwitchValue(
        ((Config().getSwitchInt(lights[varLight]) + 1) % 2).toString());
    print(value);
    int val = Config().getSwitchInt(value);
    final uri = Config().setUrlLight;

    final headers = {
      'Content-Type': 'application/json',
    };

    Map bData = {'Light': light, 'Value': val};
    final body = json.encode(bData);

    http.Response response = await http.post(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print(statusCode);
    print('RES: .$responseBody.');
    setState(() {
      lights[varLight] = value;
    });
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
        elevation: 50,
        shadowColor: Colors.black,
        child: SizedBox(
          width: 300,
          height: 640,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("Light Left"),
                      ElevatedButton(
                          onPressed: () {
                            changeLight("Light_L", 0);
                          },
                          child: Text(lights[0])),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("Light Middle"),
                      ElevatedButton(
                          onPressed: () {
                            changeLight("Light_M", 1);
                          },
                          child: Text(lights[1])),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("Light Right "),
                      ElevatedButton(
                          onPressed: () {
                            changeLight("Light_R", 2);
                          },
                          child: Text(lights[2])),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("Light Driveway"),
                      ElevatedButton(
                          onPressed: () {
                            changeLight("Light_Ext", 3);
                          },
                          child: Text(lights[3])),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
