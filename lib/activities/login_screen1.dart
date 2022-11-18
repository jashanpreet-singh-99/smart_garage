import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_login/flutter_login.dart';
import '../utils/config.dart';
import 'home_screen.dart';

import 'package:http/http.dart' as http;

const users = {
  'smartgarage@gmail.com': '12345',
  '1111': '1111',
};

class LoginScreenA extends StatelessWidget {
  const LoginScreenA({super.key});
  static const Duration loginTime = Duration(seconds: 1);

  Future<bool> getToken(String email, String password) async {
    final uri = Config.urlLogin;
    final headers = {'Content-Type': 'application/json'};

    Map bData = {'username': email, 'password': password};
    final body = json.encode(bData);

    http.Response response = await http.post(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    Log.log(Log.TAG_REQUEST, "$statusCode", Log.I);
    Log.log(Log.TAG_REQUEST, responseBody, Log.I);
    if (statusCode == 200) {
      String t = Config.getToken(responseBody);
      Log.log(Log.TAG_REQUEST, "Saving token Locally.", Log.I);
      Config.saveToStorage(Config.KEY_AUTH_ID, t);
      return true;
    }
    return false;
  }

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    if (await getToken(data.name, data.password)) {
      Config.saveToStorage(Config.KEY_USER, data.name);
      Config.saveToStorage(Config.KEY_PASS, data.password);
      return Future.delayed(const Duration(microseconds: 1)).then((_) {
        return null;
      });
    } else {
      return Future.delayed(loginTime).then((_) {
        if (!users.containsKey(data.name)) {
          return 'Invalid email';
        }
        if (users[data.name] != data.password) {
          return 'Password does not match';
        }
        return null;
      });
    }
  }

  Future<String?> _signUpUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Smart Garage',
      logo: const AssetImage('assets/garage.png'),
      onLogin: _authUser,
      onSignup: _signUpUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
