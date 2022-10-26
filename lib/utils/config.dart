class Config {
  Uri testUrlLights = Uri.parse("http://4.229.225.201/Lights");
  Uri testUrlDoor = Uri.parse("http://4.229.225.201/Door");

  String getOccupanyValue(String value) {
    if (value == "0") {
      return "EMPTY";
    }
    return "FULL";
  }

  String getDoorValue(String value) {
    if (value == "0") {
      return "CLOSED";
    }
    return "OPEN";
  }

  String getSwitchValue(String value) {
    if (value == "1") {
      return "ON";
    }
    return "OFF";
  }
}
