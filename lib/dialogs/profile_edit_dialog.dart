import 'package:flutter/material.dart';

class ProfileEditDialog extends StatefulWidget {
  final Function(String, String) updateProfileData;

  const ProfileEditDialog(this.updateProfileData, {super.key});

  @override
  State<ProfileEditDialog> createState() {
    return _ProfileEditDialogState();
  }
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  Widget buildTextField(String hint, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.all(10),
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
  Widget build(BuildContext context) {
    var firstNameController = TextEditingController();
    var lastNameController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(2),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              "Edit Profile",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          buildTextField('First Name', firstNameController),
          buildTextField('Last Name', lastNameController),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ElevatedButton(
              onPressed: () {
                final firstN = firstNameController.text;
                final lastN = lastNameController.text;
                widget.updateProfileData(firstN, lastN);
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
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.cyan),
                  selectionColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
