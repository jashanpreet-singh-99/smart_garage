import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:smart_garage/utils/preference_manager.dart';

class Config {
  static Uri urlLogin = Uri.parse("http://4.229.225.201:5000/login");
  static Uri urlLoginGuest = Uri.parse("http://4.229.225.201:5000/login_guest");
  Uri urlDoor = Uri.parse("http://4.229.225.201:5000/door?token=$token");
  Uri urlDoorA = Uri.parse("http://4.229.225.201:5000/door_anim?token=$token");
  Uri urlLight = Uri.parse("http://4.229.225.201:5000/light?token=$token");
  Uri urlCo = Uri.parse("http://4.229.225.201:5000/co?token=$token");
  Uri urlValid = Uri.parse("http://4.229.225.201:5000/?token=$token");
  Uri urlUser = Uri.parse("http://4.229.225.201:5000/user?token=$token");
  Uri urlUserUpdate =
      Uri.parse("http://4.229.225.201:5000/update_profile?token=$token");
  Uri urlGuest = Uri.parse("http://4.229.225.201:5000/guest?token=$token");
  Uri urlAddGuest =
      Uri.parse("http://4.229.225.201:5000/add_guest?token=$token");
  Uri urlRevokeGuest =
      Uri.parse("http://4.229.225.201:5000/revoke_guest?token=$token");
  Uri urlVehicles = Uri.parse("http://4.229.225.201:5000/vehicle?token=$token");
  Uri urlAddVehicles =
      Uri.parse("http://4.229.225.201:5000/add_vehicle?token=$token");
  Uri urlRemoveVehicle =
      Uri.parse("http://4.229.225.201:5000/remove_vehicle?token=$token");
  Uri urlSignUp = Uri.parse("http://4.229.225.201:5000/sign_up");

  Uri urlUpdateTiers =
      Uri.parse("http://4.229.225.201:5000/update_tiers?token=$token");

  Uri urlUpdateEngine =
      Uri.parse("http://4.229.225.201:5000/update_engine?token=$token");
  Uri urlUpdateBrake =
      Uri.parse("http://4.229.225.201:5000/update_brake?token=$token");
  Uri urlUpdateAir =
      Uri.parse("http://4.229.225.201:5000/update_air?token=$token");
  Uri urlUpdateMilage =
      Uri.parse("http://4.229.225.201:5000/update_milage?token=$token");

  static const String API_KEY = "b22e4e51-0fdf-4c75-9d95-f023e9c32c74";

  static const String ROLE_ADMIN = "Admin";
  static const String ROLE_GUEST = "Guest";

  static String token = "";

  static String NONE = "_none";

  String getOccupancyValue(String value) {
    if (value == "0") {
      return "EMPTY";
    }
    return "FULL";
  }

  int getDoorValue(String v) {
    Map<String, dynamic> jsonObj = jsonDecode(v);
    return jsonObj["Door"];
  }

  int getDoorInt(String value) {
    switch (value) {
      case "OPEN":
        return 1;
      case "CLOSE":
        return -1;
      default:
        return 0;
    }
  }

  String getDoorString(int value) {
    switch (value) {
      case 1:
        return "OPEN";
      case -1:
        return "CLOSE";
      default:
        return "STOP";
    }
  }

  String getSwitchValue(String value) {
    if (value == "1") {
      return "ON";
    }
    return "OFF";
  }

  int getSwitchInt(String value) {
    if (value == "ON") {
      return 1;
    }
    return 0;
  }

  String getSwitchValueJson(String data, String light) {
    final body = json.decode(data);
    int value = body[light];
    if (value == 1) {
      return "ON";
    }
    return "OFF";
  }

  Color getCoColor(double level) {
    if (level > 0.50) {
      return Colors.red;
    } else if (level > 0.25) {
      return Colors.orange;
    } else if (level > 0.10) {
      return Colors.yellow;
    }
    return Colors.green;
  }

  Color getLightSwitchColor(String stat) {
    if (stat == "ON") {
      return Colors.yellow;
    }
    return Colors.black26;
  }

  String getSwitchValueInt(int value) {
    if (value == 1) {
      return "ON";
    }
    return "OFF";
  }

  List<int> getSwitchValueList(String data) {
    final body = json.decode(data);
    late List<int> list = [];
    list.add(body["Light_L"]);
    list.add(body["Light_M"]);
    list.add(body["Light_R"]);
    list.add(body["Light_Ext"]);
    return list;
  }

  String getSwitchValueIndoorJson(String data) {
    final body = json.decode(data);
    int valueL = body["Light_L"];
    int valueM = body["Light_M"];
    int valueR = body["Light_R"];
    int value = valueL + valueM + valueR;
    if (value > 0) {
      return "ON";
    }
    return "OFF";
  }

  double getCoLevelJson(String data) {
    final body = json.decode(data);
    return body["Co"] / 100;
  }

  List<dynamic> getList(String data) {
    final body = json.decode(data);
    List<dynamic> lList = List.from(body);
    return lList;
  }

  static String getConnectionStat(String resp) {
    final body = json.decode(resp);
    if (body["status"] == 1) {
      return "SUCCESS";
    } else {
      return "FAILURE";
    }
  }

  static String getToken(String resp) {
    final body = json.decode(resp);
    token = body["token"];
    return token;
  }

  static void saveToStorage(String key, String value) {
    Log.log(Log.TAG_STORAGE, "Saving to local", Log.I);
    PreferenceManager.setString(key, value);
  }

  static Future<dynamic> readFromStorage(String key, String def) {
    return PreferenceManager.getString(key, def);
  }

  static const String KEY_AUTH_ID = "auth_id";
  static const String KEY_USER = "user_name";
  static const String KEY_PASS = "user_pass";
  static const String KEY_DEVICE_ID = "user_id";
  static const String KEY_ROLE = "user_role";

  static Future<bool> refreshToken() async {
    String email = "";
    String password = "";
    String device = "";
    var uri = urlLogin;
    final headers = {'Content-Type': 'application/json'};
    email = await readFromStorage(KEY_USER, NONE);
    password = await readFromStorage(KEY_PASS, NONE);
    device = await readFromStorage(KEY_DEVICE_ID, "");
    String role = await readFromStorage(KEY_ROLE, ROLE_ADMIN);
    if (email == NONE || password == NONE) {
      return false;
    }
    if (role == ROLE_GUEST) {
      uri = urlLoginGuest;
    }
    Map bData = {'email': email, 'password': password, 'Device': device};
    final body = json.encode(bData);

    http.Response response = await http.post(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    Log.log(Log.TAG_REQUEST, "$statusCode", Log.I);
    Log.log(Log.TAG_REQUEST, responseBody, Log.I);
    if (statusCode == 200) {
      saveToStorage(Config.KEY_AUTH_ID, Config.getToken(responseBody));
      return true;
    }
    return false;
  }
}

class Log {
  static const bool DEBUG = true;

  static const String E = "Error";
  static const String I = "Info ";

  static const String TAG_SPLASH = "Activity_Splash_Screen";
  static const String TAG_REQUEST = "Network_Requests      ";
  static const String TAG_STORAGE = "Storage_logs          ";
  static const String TAG_OPEN_SIGNAL = "One_Signal_logs       ";
  static const String TAG_DIALOG = "Dialog_messages       ";
  static const String TAG_DATE = "Date_messages         ";
  static const String TAG_DROPDOWN = "DropDown_messages     ";
  static const String TAG_VEHICLE = "vehicle_messages      ";

  static void log(String tag, String message, String type) {
    if (DEBUG) {
      // ignore: avoid_print
      print("$tag : $type : $message");
    }
  }
}
