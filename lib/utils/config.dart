import 'dart:convert';
import 'package:flutter/material.dart';

class Config {
  Uri testUrlLights = Uri.parse("http://4.229.225.201/Lights");
  Uri testUrlDoor = Uri.parse("http://4.229.225.201/Door");
  Uri testUrlCo = Uri.parse("http://4.229.225.201/Co");

  String getOccupanyValue(String value) {
    if (value == "0") {
      return "EMPTY";
    }
    return "FULL";
  }

  String getDoorValue(String v) {
    int value = int.parse(v);
    if (value == 0) {
      return "STOP";
    } else if (value == -1) {
      return "CLOSE";
    }
    return "OPEN";
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

  String getSwitchValueInt(int value) {
    if (value == 1) {
      return "ON";
    }
    return "OFF";
  }

  String getSwitchValueJson(String data, String light) {
    final body = json.decode(data);
    int value = body[light];
    if (value == 1) {
      return "ON";
    }
    return "OFF";
  }

  List<String> getSwitchValueList(String data, List<String> list) {
    final body = json.decode(data);
    list[0] = getSwitchValueInt(body["LightL"]);
    list[1] = getSwitchValueInt(body["LightM"]);
    list[2] = getSwitchValueInt(body["LightR"]);
    list[3] = getSwitchValueInt(body["LightExt"]);
    return list;
  }

  String getSwitchValueIndoorJson(String data) {
    final body = json.decode(data);
    int valueL = body["LightL"];
    int valueM = body["LightM"];
    int valueR = body["LightR"];
    int value = valueL + valueM + valueR;
    if (value > 0) {
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
}
