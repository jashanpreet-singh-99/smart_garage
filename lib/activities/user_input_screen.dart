import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:smart_garage/activities/splash_screen.dart';

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

  Widget buildTextField(String hint, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 45,
      child: TextField(
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

    var engineOilController = TextEditingController();
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
                          buildTextField(
                              "Enter Current Milage", engineOilController),
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
                              onPressed: () {},
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
                              engineOilController),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: ElevatedButton(
                              onPressed: () {},
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
                              engineOilController),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: ElevatedButton(
                              onPressed: () {},
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
                              onPressed: () {},
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
