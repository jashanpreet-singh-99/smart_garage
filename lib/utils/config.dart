import 'dart:convert';
import 'package:flutter/material.dart';

class Config {
  Uri testUrlLights = Uri.parse("http://4.229.225.201/Lights");
  Uri testUrlDoor = Uri.parse("http://4.229.225.201/Door");
  Uri testUrlDoorStop = Uri.parse("http://4.229.225.201/DoorStop");

  Uri getGarageData = Uri.parse("http://4.229.225.201:5000/get_garage_data");
  Uri getUrlDoor = Uri.parse("http://4.229.225.201:5000/get_door");
  Uri getUrlLight = Uri.parse("http://4.229.225.201:5000/get_lights");
  Uri getUrlCo = Uri.parse("http://4.229.225.201:5000/get_co");
  Uri setUrlLight = Uri.parse("http://4.229.225.201:5000/set_light");
  Uri setUrlDoor = Uri.parse("http://4.229.225.201:5000/set_door");

  String getOccupancyValue(String value) {
    if (value == "0") {
      return "EMPTY";
    }
    return "FULL";
  }

  String getDoorValue(String v) {
    Map<String, dynamic> jsonObj = jsonDecode(v);
    int value = jsonObj["door"];
    if (value == -1) {
      return "CLOSE";
    } else if (value == 1) {
      return "OPEN";
    }
    return "STOP";
  }

  int getDoorInt(String value) {
    if (value == "CLOSE") {
      return 0;
    }
    return 1;
  }

  String getDoorLockValue(String value) {
    if (value == "0") {
      return "UNLOCK";
    }
    return "LOCK";
  }

  int getDoorLockInt(String value) {
    if (value == "UNLOCK") {
      return 0;
    }
    return 1;
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

  String getSwitchValueInt(int value) {
    if (value == 1) {
      return "ON";
    }
    return "OFF";
  }

  List<String> getSwitchValueList(String data, List<String> list) {
    final body = json.decode(data);
    list[0] = getSwitchValueInt(body["Light_L"]);
    list[1] = getSwitchValueInt(body["Light_M"]);
    list[2] = getSwitchValueInt(body["Light_R"]);
    list[3] = getSwitchValueInt(body["Light_Ext"]);
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
    return body["CO"] / 100;
  }
}
