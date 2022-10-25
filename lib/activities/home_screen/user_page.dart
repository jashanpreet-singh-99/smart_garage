import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        alignment: Alignment.center,
        child: Text(
          "User Page",
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      )),
    );
  }
}
