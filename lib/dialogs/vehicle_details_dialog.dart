import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_garage/model/vehicle.dart';

import '../utils/config.dart';

class VehicleInfoDialog extends StatefulWidget {
  final Function(Vehicle) updateVehicleData;

  const VehicleInfoDialog(this.updateVehicleData, {super.key});

  @override
  State<VehicleInfoDialog> createState() {
    return _VehicleInfoDialogDialogState();
  }
}

class _VehicleInfoDialogDialogState extends State<VehicleInfoDialog> {
  var carIdController = TextEditingController();
  var milageController = TextEditingController();
  var lSDateController = TextEditingController();
  var lSMilageController = TextEditingController();
  var brakeOilController = TextEditingController();
  var airFilterController = TextEditingController();

  var oilTypes = ["TYPE A", "TYPE B", "TYPE C"];
  var tiersTypes = ["Winter", "Summer", "All season"];

  String selectedOilType = "";
  String selectedTires = "";

  @override
  void initState() {
    super.initState();
    selectedOilType = oilTypes[0];
    selectedTires = tiersTypes[0];
  }

  Widget buildTextField(
      String hint, TextEditingController controller, TextInputType type) {
    return Container(
      height: 40,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: TextField(
        keyboardType: type,
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  "Vehicle Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              buildTextField(
                  'Car Plate Number', carIdController, TextInputType.text),
              buildTextField('Milage', milageController, TextInputType.number),
              Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: TextField(
                  controller: lSDateController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.calendar_today),
                    labelText: "Last Service Date",
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
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now());

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      Log.log(Log.TAG_DATE, formattedDate, Log.I);

                      setState(() {
                        lSDateController.text = formattedDate;
                      });
                    }
                  },
                ),
              ),
              buildTextField('Last Service Milage', lSMilageController,
                  TextInputType.number),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Engine Oil",
                  ),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                          Log.log(Log.TAG_DROPDOWN, "$newValue", Log.I);
                          selectedOilType = newValue ?? "Error";
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tiers on vehicle",
                  ),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                          Log.log(Log.TAG_DROPDOWN, "$newValue", Log.I);
                          selectedTires = newValue ?? "Error";
                        });
                      },
                    ),
                  ),
                ],
              ),
              buildTextField('Last Brake oil Change', brakeOilController,
                  TextInputType.number),
              buildTextField('Last Air Filter Change', airFilterController,
                  TextInputType.number),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to help page
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(color: Colors.cyan),
                        )),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Get Help",
                          style: TextStyle(color: Colors.cyan),
                          selectionColor: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String carID = carIdController.text;
                        int milage = 0;
                        if (milageController.text.isNotEmpty) {
                          milage = int.parse(milageController.text);
                        }
                        String lSDate = lSDateController.text;
                        int lSMilage = 0;
                        if (lSMilageController.text.isNotEmpty) {
                          lSMilage = int.parse(lSMilageController.text);
                        }
                        int brakeOil = 0;
                        if (brakeOilController.text.isNotEmpty) {
                          brakeOil = int.parse(brakeOilController.text);
                        }
                        int airFilter = 0;
                        if (brakeOilController.text.isNotEmpty) {
                          airFilter = int.parse(airFilterController.text);
                        }

                        var vehicle = Vehicle(
                            carID,
                            milage,
                            lSDate,
                            lSMilage,
                            selectedOilType,
                            selectedTires,
                            airFilter,
                            brakeOil);
                        widget.updateVehicleData(vehicle);
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(color: Colors.cyan),
                        )),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.cyan),
                          selectionColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
