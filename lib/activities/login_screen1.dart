import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_login/flutter_login.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../utils/config.dart';
import 'guest_screen.dart';
import 'home_screen.dart';

import 'package:http/http.dart' as http;

class LoginScreenA extends StatefulWidget {
  const LoginScreenA({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreenA> createState() {
    return _LoginScreenAState();
  }
}

class _LoginScreenAState extends State<LoginScreenA> {
  static const Duration loginTime = Duration(seconds: 1);

  Uri loginUri = Config.urlLogin;
  int mode = 0;

  Future<bool> getToken(String email, String password) async {
    final uri = loginUri;
    final headers = {'Content-Type': 'application/json'};

    String userId = await Config.readFromStorage(Config.KEY_DEVICE_ID, "");
    Map bData = {'email': email, 'password': password, "Device": userId};
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
      Config.saveToStorage(
          Config.KEY_ROLE, (mode == 0) ? Config.ROLE_ADMIN : Config.ROLE_GUEST);

      return Future.delayed(const Duration(microseconds: 1)).then((_) {
        return null;
      });
    } else {
      return 'Email address and password combination are in correct.';
    }
  }

  Future<String?> _signUpUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
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
          builder: (context) {
            if (mode == 0) {
              return const HomeScreen();
            } else {
              return const GuestScreen();
            }
          },
        ));
      },
      userType: LoginUserType.email,
      onRecoverPassword: (_) => Future(() => null),
      hideForgotPasswordButton: true,
      messages: LoginMessages(
        userHint: 'Email address',
        passwordHint: 'Password',
        confirmPasswordHint: 'Confirm Password',
        loginButton: 'LOG IN',
        signupButton: 'SIGN UP',
        forgotPasswordButton: '',
        recoverPasswordButton: 'UNAVAILABLE',
        goBackButton: 'GO BACK',
        confirmPasswordError: 'Not match!',
        recoverPasswordDescription:
            'This feature is not available for you. Please contact the Application service provider.',
      ),
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
            child: Card(
              elevation: 4,
              child: SizedBox(
                height: 40,
                child: ToggleSwitch(
                  initialLabelIndex: 0,
                  totalSwitches: 2,
                  cornerRadius: 15.0,
                  radiusStyle: true,
                  activeBgColor: const [Colors.white],
                  activeFgColor: Colors.lightBlue,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.black38,
                  labels: const ['Family', 'Guest'],
                  onToggle: (index) {
                    if (index == 1) {
                      mode = 1;
                      loginUri = Config.urlLoginGuest;
                      Log.log(
                          Log.TAG_REQUEST, "Switching to $index Guest", Log.I);
                    } else {
                      mode = 0;
                      loginUri = Config.urlLogin;
                      Log.log(
                          Log.TAG_REQUEST, "Switching to $index Family", Log.I);
                    }
                  },
                ),
              ),
            )),
      ],
    );
  }
}
