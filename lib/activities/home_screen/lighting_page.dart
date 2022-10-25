import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LightingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      alignment: Alignment.center,
      child: Text(
        "Lights Page",
        style: TextStyle(color: Colors.black, fontSize: 30),
      ),
    )));
  }
}
