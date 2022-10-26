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
  String lightFL = "OFF";
  String lightFR = "OFF";
  String lightML = "OFF";
  String lightMM = "OFF";
  String lightMR = "OFF";
  String lightRL = "OFF";
  String lightRM = "OFF";
  String lightRR = "OFF";
  String lightExt = "OFF";

  late List<String> lights = [];

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
  }

  @override
  void initState() {
    super.initState();
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
                      const Text("Light Front Left"),
                      ElevatedButton(
                          onPressed: () {
                            changeLight("Light_F_L", 0);
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
                      const Text("Light Front Right"),
                      ElevatedButton(
                          onPressed: () {
                            changeLight("Light_F_R", 1);
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
                      const Text("Light Middle Left"),
                      ElevatedButton(
                          onPressed: () {
                            changeLight("Light_M_L", 2);
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
                      const Text("Light Middle Middle"),
                      ElevatedButton(
                          onPressed: () {
                            changeLight("Light_M_M", 3);
                          },
                          child: Text(lights[3])),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("Light Middle Right"),
                      ElevatedButton(
                          onPressed: () {
                            changeLight("Light_M_R", 4);
                          },
                          child: Text(lights[4])),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("Light Rear Left"),
                      ElevatedButton(
                          onPressed: () {
                            changeLight("Light_R_L", 5);
                          },
                          child: Text(lights[5])),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("Light Rear Middle"),
                      ElevatedButton(
                          onPressed: () {
                            changeLight("Light_R_M", 6);
                          },
                          child: Text(lights[6])),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("Light Rear Right"),
                      ElevatedButton(
                          onPressed: () {
                            changeLight("Light_R_R", 7);
                          },
                          child: Text(lights[7])),
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
                            changeLight("Light_Ext", 8);
                          },
                          child: Text(lights[8])),
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
