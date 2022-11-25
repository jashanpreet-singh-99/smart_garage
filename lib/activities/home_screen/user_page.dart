import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_garage/activities/splash_screen.dart';
import 'package:smart_garage/dialogs/profile_edit_dialog.dart';

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

  @override
  void initState() {
    super.initState();
    getUserData();
    getGuestAccess();
    getVehicles();
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
      setState(() {
        final body = json.decode(responseBody);
        firstName = body['first_name'];
        lastName = body['last_name'];
        emailAddress = body['email'];
        Log.log(Log.TAG_REQUEST, "USER: ${getName()}", Log.I);
      });
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
            content: ProfileEditDialog(updateProfileData),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          );
        });
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
          // Show error dialog
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

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Padding(
            padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
            child: Text('Guest Limit Error'),
          ),
          content: const Padding(
            padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
            child: Text(
                'Maximum Guests limit reached. Please delete previous Guests in order to generate new ones.'),
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
      setState(() {
        guestList = Config().getList(responseBody);
        for (var element in guestList) {
          Log.log(Log.TAG_REQUEST, "GUEST: ${element['email']}", Log.I);
        }
      });
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
      setState(() {
        vehicleList = Config().getList(responseBody);
        for (var element in guestList) {
          Log.log(Log.TAG_REQUEST, "Vehicles: ${element['CarID']}", Log.I);
        }
      });
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
                    borderRadius: BorderRadius.circular(10.0),
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
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: const [
                                Text(
                                  'Vehicles',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blueGrey,
                                  ),
                                  textAlign: TextAlign.start,
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
                                    child: ListTile(
                                      title: Text(vehicleList[index]['CarID']),
                                      subtitle: Text(vehicleList[index]
                                              ["Milage"]
                                          .toString()),
                                      trailing: SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            removeVehicle(
                                                vehicleList[index]['CarID'],
                                                index);
                                          },
                                          style: ButtonStyle(
                                            shadowColor: MaterialStateProperty
                                                .all<Color>(Colors.transparent),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                            ),
                                          ),
                                          child: const Text("X",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (guestList.length < 3) {
                                // addGuest();
                              } else {
                                // openDialog();
                                // Show a dialog that u cannot add more guest
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
                    borderRadius: BorderRadius.circular(10.0),
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
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: const [
                                Text(
                                  'Guest Access',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blueGrey,
                                  ),
                                  textAlign: TextAlign.start,
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
                                    child: ListTile(
                                      title: Text(guestList[index]['email']),
                                      subtitle:
                                          Text(guestList[index]['password']),
                                      trailing: SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            revokeGuest(
                                                guestList[index]['email'],
                                                guestList[index]['password'],
                                                index);
                                          },
                                          style: ButtonStyle(
                                            shadowColor: MaterialStateProperty
                                                .all<Color>(Colors.transparent),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                            ),
                                          ),
                                          child: const Text("X",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16)),
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
                                openDialog();
                                // Show a dialog that u cannot add more guest
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
