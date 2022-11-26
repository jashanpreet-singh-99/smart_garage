import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_garage/activities/guest_screen.dart';
import 'package:smart_garage/activities/home_screen.dart';
import 'package:smart_garage/activities/login_screen1.dart';

import '../utils/config.dart';

import 'package:http/http.dart' as http;

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
  @override
  void initState() {
    super.initState();
    isLoggedIn();
  }

  Future<void> isLoggedIn() async {
    String token =
        await Config.readFromStorage(Config.KEY_AUTH_ID, Config.NONE);
    String user = await Config.readFromStorage(Config.KEY_USER, Config.NONE);
    String pass = await Config.readFromStorage(Config.KEY_PASS, Config.NONE);
    String role =
        await Config.readFromStorage(Config.KEY_ROLE, Config.ROLE_ADMIN);

    Log.log(Log.TAG_SPLASH, "$token $user $pass", Log.I);

    if (token != Config.NONE) {
      Config.token = token;
      Log.log(Log.TAG_SPLASH, "Token present", Log.I);

      bool isValidToken = await checkToken(user);
      Log.log(Log.TAG_SPLASH, "Token Check :  $isValidToken", Log.I);

      if (isValidToken == true) {
        Timer(const Duration(milliseconds: 1000), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              if (role == Config.ROLE_ADMIN) {
                return const HomeScreen();
              } else {
                return const GuestScreen();
              }
            }),
          );
        });
      } else {
        Timer(const Duration(milliseconds: 1000), () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const LoginScreenA()), /*LoginScreenA())*/
          );
        });
      }
    } else {
      Timer(const Duration(milliseconds: 1000), () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginScreenA()), /*LoginScreenA()),*/
        );
      });
    }
  }

  Future<bool> checkToken(String user) async {
    final uri = Config().urlValid;
    final headers = {'Content-Type': 'application/json'};
    String userId = await Config.readFromStorage(Config.KEY_DEVICE_ID, "");

    Map bData = {'Device': userId, 'email': user};
    final body = json.encode(bData);
    http.Response response = await http.post(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    Log.log(Log.TAG_REQUEST, "$statusCode", Log.I);
    Log.log(Log.TAG_REQUEST, responseBody, Log.I);

    if (statusCode == 200) {
      return true;
    } else if (statusCode == 403) {
      Log.log(Log.TAG_REQUEST, "Token Expired", Log.I);
      if (await Config.refreshToken()) {
        Log.log(Log.TAG_REQUEST, "Token Refreshed", Log.I);
        return true;
      }
    }
    return false;
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
