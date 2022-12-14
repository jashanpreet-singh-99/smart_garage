import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_login/flutter_login.dart';
import 'package:smart_garage/activities/signup_screen.dart';
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
  Uri loginUri = Config.urlLogin;
  int mode = 0;

  bool showBtn = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        showBtn = true;
      });
    });
  }

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
      setState(() {
        showBtn = false;
      });
      return Future.delayed(const Duration(microseconds: 1)).then((_) {
        return null;
      });
    } else {
      return 'Email address and password combination are in correct.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Smart Garage',
      logo: const AssetImage('assets/garage.png'),
      onLogin: _authUser,
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
        showBtn
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 275, 0, 0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpView1()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  splashColor: Colors.cyan,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              )
            : const Padding(
                padding: EdgeInsets.all(10),
              ),
        showBtn
            ? Padding(
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
                      activeFgColor: Colors.cyan,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.black38,
                      labels: const ['Admin', 'Guest'],
                      onToggle: (index) {
                        if (index == 1) {
                          mode = 1;
                          loginUri = Config.urlLoginGuest;
                          Log.log(Log.TAG_REQUEST, "Switching to $index Guest",
                              Log.I);
                        } else {
                          mode = 0;
                          loginUri = Config.urlLogin;
                          Log.log(Log.TAG_REQUEST, "Switching to $index Family",
                              Log.I);
                        }
                      },
                    ),
                  ),
                ))
            : const Padding(
                padding: EdgeInsets.all(10),
              ),
      ],
    );
  }
}
