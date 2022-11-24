import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    getGuestAccess();
  }

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
        guestList = Config().getGuests(responseBody);
        guestList.forEach((element) {
          Log.log(Log.TAG_REQUEST, "GUEST: ${element['email']}", Log.I);
        });
      });
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        getGuestAccess();
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
        // guestList = Config().getGuests(responseBody);
        // guestList.forEach((element) {
        //   Log.log(Log.TAG_REQUEST, "GUEST: ${element['email']}", Log.I);
        // });
      });
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Refresh Token", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Calling Again using new Token", Log.I);
        getGuestAccess();
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
        getGuestAccess();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
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
                  children: const [
                    Text(
                      'Jashan singh',
                      style: TextStyle(
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
                children: const [
                  Text(
                    'admin@a.com',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {},
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
                    child: Text("Edit", style: TextStyle(color: Colors.cyan)),
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
                                          shadowColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.transparent),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.red),
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
                              // Show a dialog that u cannot add more guest
                            }
                          },
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.black12;
                                } //<-- SEE HERE}
                                return null; // Defer to the widget's default.
                              },
                            ),
                            shadowColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
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
    );
  }
}
