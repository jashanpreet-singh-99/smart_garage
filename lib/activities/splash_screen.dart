import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_garage/activities/home_screen.dart';
import 'package:smart_garage/activities/register_screen.dart';
import 'package:smart_garage/activities/login_screen.dart';
import 'package:smart_garage/activities/login_screen1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  _SplashScreenState() {
    Timer(const Duration(milliseconds: 1000), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Image.asset('assets/garage.png')],
        ),
      ),
    );
  }
}
