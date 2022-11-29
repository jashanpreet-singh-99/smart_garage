import 'dart:convert';
import 'dart:ffi';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:smart_garage/activities/splash_screen.dart';
import 'package:http/http.dart' as http;

import '../utils/config.dart';

class UserInputScreen extends StatefulWidget {
  final dynamic postData;

  const UserInputScreen({Key? key, @required this.postData}) : super(key: key);

  @override
  State<UserInputScreen> createState() {
    return _UserInputScreenState();
  }
}

class _UserInputScreenState extends State<UserInputScreen> {
  String notificationData = "";

  var oilTypes = ["TYPE A", "TYPE B", "TYPE C"];
  var tiersTypes = ["Winter", "Summer", "All season"];

  String selectedOilType = "";
  String selectedTires = "";

  Future openDialog(String titleTxt, String msgText) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Padding(
            padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
            child: Text(titleTxt),
          ),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
            child: Text(msgText),
          ),
          actions: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 2, 10),
                  child: ElevatedButton(
                    onPressed: (Navigator.of(context).pop),
                    style: ButtonStyle(
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.cyan),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Okay",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );

  Future<void> updateVehicleTiers(String tiers) async {
    final uri = Config().urlUpdateTiers;
    final headers = {'Content-Type': 'application/json'};

    String email = await Config.readFromStorage(Config.KEY_USER, "");
    Map bData = {
      'email': email,
      'CarID': notificationData,
      'Tiers': tiers,
    };
    final body = json.encode(bData);

    http.Response response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    Log.log(Log.TAG_REQUEST, "$statusCode", Log.I);
    Log.log(Log.TAG_REQUEST, responseBody, Log.I);
    if (statusCode == 200) {
      final stat = json.decode(responseBody)['status'];
      setState(() {
        if (stat == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
          );
        } else {
          openDialog("Vehicle Data Error",
              "Error occurred while saving your data. Either the server is offline or the data entered is invalid.");
        }
      });
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        updateVehicleTiers(tiers);
      }
    }
  }

  Future<void> updateVehicleEngine(int milage, String oilT) async {
    final uri = Config().urlUpdateEngine;
    final headers = {'Content-Type': 'application/json'};

    String email = await Config.readFromStorage(Config.KEY_USER, "");
    Map bData = {
      'email': email,
      'CarID': notificationData,
      'LSMilage': milage,
      'OilType': oilT,
    };
    final body = json.encode(bData);

    http.Response response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    Log.log(Log.TAG_REQUEST, "$statusCode", Log.I);
    Log.log(Log.TAG_REQUEST, responseBody, Log.I);
    if (statusCode == 200) {
      final stat = json.decode(responseBody)['status'];
      setState(() {
        if (stat == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
          );
        } else {
          openDialog("Vehicle Data Error",
              "Error occurred while saving your data. Either the server is offline or the data entered is invalid.");
        }
      });
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        updateVehicleEngine(milage, oilT);
      }
    }
  }

  Future<void> updateVehicleBrake(int brakeO) async {
    final uri = Config().urlUpdateBrake;
    final headers = {'Content-Type': 'application/json'};

    String email = await Config.readFromStorage(Config.KEY_USER, "");
    Map bData = {
      'email': email,
      'CarID': notificationData,
      'BrakeOil': brakeO,
    };
    final body = json.encode(bData);

    http.Response response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    Log.log(Log.TAG_REQUEST, "$statusCode", Log.I);
    Log.log(Log.TAG_REQUEST, responseBody, Log.I);
    if (statusCode == 200) {
      final stat = json.decode(responseBody)['status'];
      setState(() {
        if (stat == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
          );
        } else {
          openDialog("Vehicle Data Error",
              "Error occurred while saving your data. Either the server is offline or the data entered is invalid.");
        }
      });
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        updateVehicleBrake(brakeO);
      }
    }
  }

  Future<void> updateVehicleAir(int airF) async {
    final uri = Config().urlUpdateAir;
    final headers = {'Content-Type': 'application/json'};

    String email = await Config.readFromStorage(Config.KEY_USER, "");
    Map bData = {
      'email': email,
      'CarID': notificationData,
      'AirFilter': airF,
    };
    final body = json.encode(bData);

    http.Response response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    Log.log(Log.TAG_REQUEST, "$statusCode", Log.I);
    Log.log(Log.TAG_REQUEST, responseBody, Log.I);
    if (statusCode == 200) {
      final stat = json.decode(responseBody)['status'];
      setState(() {
        if (stat == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
          );
        } else {
          openDialog("Vehicle Data Error",
              "Error occurred while saving your data. Either the server is offline or the data entered is invalid.");
        }
      });
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        updateVehicleAir(airF);
      }
    }
  }

  Future<void> updateVehicleOdo(int odo) async {
    final uri = Config().urlUpdateMilage;
    final headers = {'Content-Type': 'application/json'};

    String email = await Config.readFromStorage(Config.KEY_USER, "");
    Map bData = {
      'email': email,
      'CarID': notificationData,
      'Milage': odo,
    };
    final body = json.encode(bData);

    http.Response response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    Log.log(Log.TAG_REQUEST, "$statusCode", Log.I);
    Log.log(Log.TAG_REQUEST, responseBody, Log.I);
    if (statusCode == 200) {
      final stat = json.decode(responseBody)['status'];
      setState(() {
        if (stat == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
          );
        } else {
          openDialog("Vehicle Data Error",
              "Error occurred while saving your data. Either the server is offline or the data entered is invalid.");
        }
      });
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        updateVehicleOdo(odo);
      }
    }
  }

  Widget buildTextField(
      String hint, TextEditingController controller, TextInputType type) {
    return Container(
      height: 40,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: TextField(
        keyboardType: type,
        decoration: InputDecoration(
          labelText: hint,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Colors.cyan,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Colors.black38,
            ),
          ),
        ),
        controller: controller,
      ),
    );
  }

  @override
  void initState() {
    selectedOilType = oilTypes[0];
    selectedTires = tiersTypes[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notificationData = widget.postData['CarID'];

    var odoController = TextEditingController();
    var engineOilController = TextEditingController();
    var brakeOilController = TextEditingController();
    var airFilterController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  shadowColor: Colors.black,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          "Service Records \n$notificationData",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        const Text(
                          "This is an regular data collection procedure. Please select the appropriate option and fill in the requested data. You can exit the application, if you wish to fill this data later. You can find this menu in your user page within your vehicle card.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  shadowColor: Colors.black,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: ExpandablePanel(
                      header: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.engineering,
                              color: Colors.black87,
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 10)),
                            Text(
                              "Update Milage Reading?",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      collapsed: Container(),
                      expanded: Column(
                        children: [
                          buildTextField("Enter Current Milage", odoController,
                              TextInputType.number),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: ElevatedButton(
                              onPressed: () {
                                int mil = int.parse(odoController.text);
                                updateVehicleOdo(mil);
                              },
                              style: ButtonStyle(
                                shadowColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: const BorderSide(color: Colors.cyan),
                                )),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text("UPDATE",
                                    style: TextStyle(color: Colors.cyan)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  shadowColor: Colors.black,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: ExpandablePanel(
                      header: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.engineering,
                              color: Colors.black87,
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 10)),
                            Text(
                              "Changed Engine Oil?",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      collapsed: Container(),
                      expanded: Column(
                        children: [
                          buildTextField("Enter Current Milage",
                              engineOilController, TextInputType.number),
                          Container(
                            height: 40,
                            margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Engine Oil",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Container(
                                  height: 40,
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: DropdownButton(
                                    value: selectedOilType,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: oilTypes.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        Log.log(Log.TAG_DROPDOWN, "$newValue",
                                            Log.I);
                                        selectedOilType = newValue ?? "Error";
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: ElevatedButton(
                              onPressed: () {
                                int mil = int.parse(engineOilController.text);
                                updateVehicleEngine(mil, selectedOilType);
                              },
                              style: ButtonStyle(
                                shadowColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: const BorderSide(color: Colors.cyan),
                                )),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text("UPDATE",
                                    style: TextStyle(color: Colors.cyan)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  shadowColor: Colors.black,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: ExpandablePanel(
                      header: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.oil_barrel,
                              color: Colors.black87,
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 10)),
                            Text(
                              "Changed Brake Oil?",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      collapsed: Container(),
                      expanded: Column(
                        children: [
                          buildTextField("Enter Brake Oil Change Milage",
                              brakeOilController, TextInputType.number),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: ElevatedButton(
                              onPressed: () {
                                int mil = int.parse(brakeOilController.text);
                                updateVehicleBrake(mil);
                              },
                              style: ButtonStyle(
                                shadowColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: const BorderSide(color: Colors.cyan),
                                )),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text("UPDATE",
                                    style: TextStyle(color: Colors.cyan)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  shadowColor: Colors.black,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: ExpandablePanel(
                      header: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.air,
                              color: Colors.black87,
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 10)),
                            Text(
                              "Changed AirFilter?",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      collapsed: Container(),
                      expanded: Column(
                        children: [
                          buildTextField("Enter Air-Filter Change Milage",
                              airFilterController, TextInputType.number),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: ElevatedButton(
                              onPressed: () {
                                int mil = int.parse(airFilterController.text);
                                updateVehicleAir(mil);
                              },
                              style: ButtonStyle(
                                shadowColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: const BorderSide(color: Colors.cyan),
                                )),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text("UPDATE",
                                    style: TextStyle(color: Colors.cyan)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  shadowColor: Colors.black,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: ExpandablePanel(
                      header: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.tire_repair,
                              color: Colors.black87,
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 10)),
                            Text(
                              "Changed Car's Tiers?",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      collapsed: Container(),
                      expanded: Column(
                        children: [
                          Container(
                            height: 40,
                            margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "New Tier Set",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Container(
                                  height: 40,
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: DropdownButton(
                                    value: selectedTires,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: tiersTypes.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        Log.log(Log.TAG_DROPDOWN, "$newValue",
                                            Log.I);
                                        selectedTires = newValue ?? "Error";
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: ElevatedButton(
                              onPressed: () {
                                updateVehicleTiers(selectedTires);
                              },
                              style: ButtonStyle(
                                shadowColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: const BorderSide(color: Colors.cyan),
                                )),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text("UPDATE",
                                    style: TextStyle(color: Colors.cyan)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SplashScreen()),
                      );
                    },
                    style: ButtonStyle(
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(color: Colors.cyan),
                      )),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("EXIT", style: TextStyle(color: Colors.cyan)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
