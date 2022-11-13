class Config {
  Uri testUrlLights = Uri.parse("http://4.229.225.201/Lights");
  Uri testUrlDoor = Uri.parse("http://4.229.225.201/Door");
  Uri testUrlDoorStop = Uri.parse("http://4.229.225.201/DoorStop");

  Uri getGarageData = Uri.parse("http://4.229.225.201/get_garage_data");
  Uri getUrlDoor = Uri.parse("http://4.229.225.201/get_door");
  Uri getUrlLight = Uri.parse("http://4.229.225.201/get_lights");
  Uri getUrlCo = Uri.parse("http://4.229.225.201/get_co");
  Uri setUrlLight = Uri.parse("http://4.229.225.201/set_light");
  Uri setUrlDoor = Uri.parse("http://4.229.225.201/set_door");


  String getOccupancyValue(String value) {
    if (value == "0") {
      return "EMPTY";
    }
    return "FULL";
  }

  String getDoorValue(String value) {
    if (value == "0") {
      return "CLOSE";
    }
    if (value == "1") {
      return "OPEN";
    }
    return "LOCK";
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
}
