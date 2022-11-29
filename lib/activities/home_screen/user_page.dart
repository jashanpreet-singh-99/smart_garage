import 'dart:convert';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smart_garage/activities/splash_screen.dart';
import 'package:smart_garage/dialogs/profile_edit_dialog.dart';

import '../../dialogs/vehicle_details_dialog.dart';
import '../../model/vehicle.dart';
import '../../utils/config.dart';

class UserPage extends StatefulWidget {
  const UserPage({
    Key? key,
  }) : super(key: key);

  @override
  State<UserPage> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  List<dynamic> guestList = List.empty();
  List<dynamic> vehicleList = List.empty();

  String firstName = "jashan";
  String lastName = "Singh";
  String emailAddress = "Email Address";

  bool disposed = false;

  @override
  void initState() {
    super.initState();
    getUserData();
    getGuestAccess();
    getVehicles();
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  String getName() {
    return "$firstName $lastName";
  }

  Future<void> getUserData() async {
    final uri = Config().urlUser;
    final headers = {'Content-Type': 'application/json'};

    String email = await Config.readFromStorage(Config.KEY_USER, "");
    Map bData = {'email': email};
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
      if (!disposed) {
        setState(() {
          final body = json.decode(responseBody);
          firstName = body['first_name'];
          lastName = body['last_name'];
          emailAddress = body['email'];
          Log.log(Log.TAG_REQUEST, "USER: ${getName()}", Log.I);
        });
      }
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        getUserData();
      }
    }
  }

  void showEditProfileDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            content: ProfileEditDialog(updateProfileData),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          );
        });
  }

  void showAddVehicleDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(1),
            contentPadding: const EdgeInsets.all(1),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            content: VehicleInfoDialog(updateVehicleData),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          );
        });
  }

  Future<void> updateVehicleData(Vehicle v) async {
    Log.log(Log.TAG_DIALOG, "Vehicle data : ${v.carID} ${v.lSDate}", Log.I);
    final uri = Config().urlAddVehicles;
    final headers = {'Content-Type': 'application/json'};

    String email = await Config.readFromStorage(Config.KEY_USER, "");
    Map bData = {
      'email': email,
      'CarID': v.carID,
      'Milage': v.milage,
      'LSDate': v.lSDate,
      'LSMilage': v.lSMilage,
      'OilType': v.oilType,
      'Tiers': v.tires,
      'AirFilter': v.airFilter,
      'BrakeOil': v.brakeOil
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
      Log.log(Log.TAG_REQUEST, "USER: ${getName()} $stat", Log.I);
      setState(() {
        if (stat == 1) {
          vehicleList.add(bData);
        } else {
          openDialog("Vehicle Data Error",
              "Error occurred while saving your data. Either the server is offline or the data entered is invalid.");
        }
      });
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        updateProfileData(firstName, lastName);
      }
    }
  }

  Future<void> updateProfileData(String firstN, String lastN) async {
    Log.log(Log.TAG_DIALOG, "Update profile $firstN $lastN", Log.I);
    final uri = Config().urlUserUpdate;
    final headers = {'Content-Type': 'application/json'};

    String email = await Config.readFromStorage(Config.KEY_USER, "");
    Map bData = {'email': email, 'first_name': firstN, 'last_name': lastN};
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
      Log.log(Log.TAG_REQUEST, "USER: ${getName()} $stat", Log.I);
      setState(() {
        if (stat == 1) {
          firstName = firstN;
          lastName = lastN;
        } else {
          openDialog("Profile Data Error",
              "Error occurred while saving your data. Either the server is offline or the data entered is invalid.");
        }
      });
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        updateProfileData(firstName, lastName);
      }
    }
  }

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

  Future<void> getGuestAccess() async {
    final uri = Config().urlGuest;
    final headers = {'Content-Type': 'application/json'};

    String email = await Config.readFromStorage(Config.KEY_USER, "");
    Map bData = {'email': email};
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
      if (!disposed) {
        setState(() {
          guestList = Config().getList(responseBody);
          for (var element in guestList) {
            Log.log(Log.TAG_REQUEST, "GUEST: ${element['email']}", Log.I);
          }
        });
      }
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        getGuestAccess();
      }
    }
  }

  Future<void> getVehicles() async {
    final uri = Config().urlVehicles;
    final headers = {'Content-Type': 'application/json'};

    String email = await Config.readFromStorage(Config.KEY_USER, "");
    Map bData = {'email': email};
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
      if (!disposed) {
        setState(() {
          vehicleList = Config().getList(responseBody);
          for (var element in guestList) {
            Log.log(Log.TAG_REQUEST, "Vehicles: ${element['CarID']}", Log.I);
          }
        });
      }
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        getVehicles();
      }
    }
  }

  Future<void> addGuest() async {
    final uri = Config().urlAddGuest;
    final headers = {'Content-Type': 'application/json'};

    String email = await Config.readFromStorage(Config.KEY_USER, "");
    Map bData = {'email': email};
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
      setState(() {
        final body = json.decode(responseBody);
        guestList.add(body);
      });
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        addGuest();
      }
    }
  }

  Future<void> revokeGuest(String email, String password, int index) async {
    final uri = Config().urlRevokeGuest;
    final headers = {'Content-Type': 'application/json'};

    Map bData = {'email': email, 'password': password};
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
      var stat = jsonDecode(responseBody);
      if (stat['status'] == 1) {
        Log.log(Log.TAG_REQUEST, "Guest Revoked $email", Log.I);
        setState(() {
          guestList.removeAt(index);
        });
      } else {
        Log.log(Log.TAG_REQUEST, "Guest Revoke Error : $stat", Log.I);
      }
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        revokeGuest(email, password, index);
      }
    }
  }

  Future<void> removeVehicle(String carID, int index) async {
    final uri = Config().urlRemoveVehicle;
    final headers = {'Content-Type': 'application/json'};

    String user = await Config.readFromStorage(Config.KEY_USER, Config.NONE);
    Map bData = {'email': user, 'CarID': carID};
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
      var stat = jsonDecode(responseBody);
      if (stat['status'] == 1) {
        Log.log(Log.TAG_REQUEST, "Vehicle removed $carID", Log.I);
        setState(() {
          vehicleList.removeAt(index);
        });
      } else {
        Log.log(Log.TAG_REQUEST, "Vehicle removal Error : $stat", Log.I);
      }
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        removeVehicle(carID, index);
      }
    }
  }

  IconData getTierIcon(String type) {
    switch (type) {
      case "Winter":
        return Icons.snowing;
      case "Summer":
        return Icons.sunny;
      default:
        return Icons.sunny_snowing;
    }
  }

  Color getPercentColor(double percent) {
    return Color.lerp(Colors.red, Colors.green, percent) ?? Colors.greenAccent;
  }

  double getAirFilterHealth(dynamic val) {
    int mils = val['Milage'] - val['AirFilter'];
    Log.log(Log.TAG_VEHICLE, "AirFilter : $mils", Log.I);
    if (mils > 0 && mils < 15000) {
      return 1 - (mils / 15000);
    }
    return 0;
  }

  double getBrakeOilHealth(dynamic val) {
    int mils = val['Milage'] - val['BrakeOil'];
    Log.log(Log.TAG_VEHICLE, "Brake oil: $mils", Log.I);
    if (mils > 0 && mils < 40000) {
      return 1 - (mils / 40000);
    }
    return 0;
  }

  int getEngineOilLimit(String type) {
    switch (type) {
      case "TYPE A":
        return 65000;
      case "TYPE B":
        return 11000;
      default:
        return 16000;
    }
  }

  double getEngineOilHealth(dynamic val) {
    int limit = getEngineOilLimit(val['OilType']);
    int mils = val['Milage'] - val['LSMilage'];
    Log.log(Log.TAG_VEHICLE, "Engine oil: $mils", Log.I);
    if (mils > 0 && mils < limit) {
      return 1 - (mils / limit);
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getName(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      emailAddress,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showEditProfileDialog();
                        },
                        style: ButtonStyle(
                          shadowColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: const BorderSide(color: Colors.cyan),
                          )),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text("Edit",
                              style: TextStyle(color: Colors.cyan)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Config.saveToStorage(Config.KEY_USER, Config.NONE);
                          Config.saveToStorage(Config.KEY_PASS, Config.NONE);
                          Config.saveToStorage(Config.KEY_AUTH_ID, Config.NONE);
                          Config.token = "";
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SplashScreen()),
                          );
                        },
                        style: ButtonStyle(
                          shadowColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: const BorderSide(color: Colors.cyan),
                          )),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text("Logout",
                              style: TextStyle(color: Colors.cyan)),
                        ),
                      ),
                    ),
                  ],
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Text(
                                    'Vehicles',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blueGrey,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: vehicleList.length,
                                itemBuilder: (context, index) {
                                  if (vehicleList.isEmpty) {
                                    return const Center(
                                      child: Text("No Vehicle Added Yet."),
                                    );
                                  }
                                  return Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ExpandablePanel(
                                      header: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.car_repair,
                                              color: Colors.black87,
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 0, 0, 10)),
                                            Text(
                                              "Vehicle: ${vehicleList[index]['CarID']}",
                                              style: const TextStyle(
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
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 5, 10, 10),
                                                child: Text(
                                                  "Last recorded Milage",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 5, 10, 5),
                                                child: Text(
                                                  "${vehicleList[index]['Milage']} km",
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 8,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 5, 10, 5),
                                                      child: Text(
                                                        "Engine Oil",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0, 5, 0, 10),
                                                      child:
                                                          LinearPercentIndicator(
                                                        animation: true,
                                                        lineHeight: 20,
                                                        animationDuration: 2000,
                                                        percent:
                                                            getEngineOilHealth(
                                                                vehicleList[
                                                                    index]),
                                                        center: Text(
                                                          "${(getEngineOilHealth(vehicleList[index]) * 100).toInt()}%",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        barRadius: const Radius
                                                            .circular(16),
                                                        progressColor:
                                                            getPercentColor(
                                                                getEngineOilHealth(
                                                                    vehicleList[
                                                                        index])),
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 5, 10, 5),
                                                      child: Text(
                                                        "Brake Oil",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0, 5, 0, 10),
                                                      child:
                                                          LinearPercentIndicator(
                                                        animation: true,
                                                        lineHeight: 20,
                                                        animationDuration: 2000,
                                                        percent:
                                                            getBrakeOilHealth(
                                                                vehicleList[
                                                                    index]),
                                                        center: Text(
                                                          "${(getBrakeOilHealth(vehicleList[index]) * 100).toInt()}%",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        barRadius: const Radius
                                                            .circular(16),
                                                        progressColor:
                                                            getPercentColor(
                                                          getBrakeOilHealth(
                                                              vehicleList[
                                                                  index]),
                                                        ),
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 5, 10, 5),
                                                      child: Text(
                                                        "Air Filter",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0, 5, 0, 10),
                                                      child:
                                                          LinearPercentIndicator(
                                                        animation: true,
                                                        lineHeight: 20,
                                                        animationDuration: 2000,
                                                        percent:
                                                            getAirFilterHealth(
                                                                vehicleList[
                                                                    index]),
                                                        center: Text(
                                                          "${(getAirFilterHealth(vehicleList[index]) * 100).toInt()}%",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        barRadius: const Radius
                                                            .circular(16),
                                                        progressColor:
                                                            getPercentColor(
                                                                getAirFilterHealth(
                                                                    vehicleList[
                                                                        index])),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          removeVehicle(
                                                              vehicleList[index]
                                                                  ['CarID'],
                                                              index);
                                                        },
                                                        style: ButtonStyle(
                                                          shadowColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Colors
                                                                      .transparent),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                                      Colors
                                                                          .red),
                                                          shape: MaterialStateProperty
                                                              .all<
                                                                  RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.0),
                                                            ),
                                                          ),
                                                        ),
                                                        child: const FittedBox(
                                                          fit: BoxFit.fill,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          child: Icon(
                                                            Icons.delete,
                                                            size: 40,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.all(10)),
                                                    SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          //
                                                        },
                                                        style: ButtonStyle(
                                                          shadowColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Colors
                                                                      .transparent),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Colors
                                                                      .greenAccent),
                                                          shape: MaterialStateProperty
                                                              .all<
                                                                  RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.0),
                                                            ),
                                                          ),
                                                        ),
                                                        child: const FittedBox(
                                                          fit: BoxFit.fill,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          child: Icon(
                                                            Icons.update,
                                                            size: 40,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 5, 10, 12),
                                                child: Text(
                                                  "Current Tiers : ",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 5, 10, 12),
                                                child: Text(
                                                  vehicleList[index]['Tiers'],
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 5, 30, 12),
                                                  child: Icon(
                                                    getTierIcon(
                                                        vehicleList[index]
                                                            ['Tiers']),
                                                    color: Colors.black54,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (vehicleList.length < 3) {
                                showAddVehicleDialog();
                              } else {
                                openDialog("Vehicle Limit",
                                    "You have reached maximum car limit per user. Please contact the application service provider to increase the limit.");
                              }
                            },
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return Colors.black12;
                                  }
                                  return null;
                                },
                              ),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent),
                              backgroundColor: MaterialStateProperty.all<Color>(
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
                              child: Text(
                                "Add Vehicle",
                                style: TextStyle(color: Colors.cyan),
                                selectionColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Text(
                                    'Guest Access',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blueGrey,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: guestList.length,
                                itemBuilder: (context, index) {
                                  if (guestList.isEmpty) {
                                    return const Center(
                                      child: Text("No Guest Added"),
                                    );
                                  }
                                  return Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ExpandablePanel(
                                      header: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.people,
                                              color: Colors.black87,
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 0, 0, 10)),
                                            Text(
                                              "Guest $index",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      collapsed: Container(),
                                      expanded: ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Email address',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 0, 10),
                                              child: Text(
                                                guestList[index]['email'],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Password',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 0, 10),
                                              child: Text(
                                                guestList[index]['password'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              revokeGuest(
                                                  guestList[index]['email'],
                                                  guestList[index]['password'],
                                                  index);
                                            },
                                            style: ButtonStyle(
                                              shadowColor: MaterialStateProperty
                                                  .all<Color>(
                                                      Colors.transparent),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.red),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                              ),
                                            ),
                                            child: const FittedBox(
                                              fit: BoxFit.fill,
                                              clipBehavior: Clip.antiAlias,
                                              child: Icon(
                                                Icons.delete,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (guestList.length < 3) {
                                addGuest();
                              } else {
                                openDialog('Guest Limit Error',
                                    'Maximum Guests limit reached. Please delete previous Guests in order to generate new ones.');
                              }
                            },
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return Colors.black12;
                                  }
                                  return null;
                                },
                              ),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent),
                              backgroundColor: MaterialStateProperty.all<Color>(
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
                              child: Text(
                                "Add Guest",
                                style: TextStyle(color: Colors.cyan),
                                selectionColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
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
