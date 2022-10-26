class Config {
  Uri testUrlLights = Uri.parse("http://4.229.225.201/Lights");
  Uri testUrlDoor = Uri.parse("http://4.229.225.201/Door");
  Uri testUrlDoorStop = Uri.parse("http://4.229.225.201/DoorStop");

  String getOccupanyValue(String value) {
    if (value == "0") {
      return "EMPTY";
    }
    return "FULL";
  }

  String getDoorValue(String value) {
    if (value == "0") {
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
}
