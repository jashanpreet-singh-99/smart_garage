import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:smart_garage/activities/login_screen.dart';
import 'package:smart_garage/utils/config.dart';
import 'package:smart_garage/controller/simple_ui_controller.dart';
import 'package:email_validator/email_validator.dart';

import '../utils/constants.dart';

class SignUpView1 extends StatefulWidget {
  const SignUpView1({Key? key}) : super(key: key);

  @override
  State<SignUpView1> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView1> {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    fNameController.dispose();
    lNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  void signUp(TextEditingController first, TextEditingController last,
      TextEditingController email, TextEditingController password) async {
    final uri = Config().urlSignUp;

    final headers = {
      'Content-Type': 'application/json',
    };

    Map bData = {
      'email': email.text,
      'password': password.text,
      'first_name': first.text,
      'last_name': last.text
    };
    final body = json.encode(bData);

    http.Response response = await http.post(uri, headers: headers, body: body);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    Log.log(Log.TAG_REQUEST, "$statusCode", Log.I);
    Log.log(Log.TAG_REQUEST, responseBody, Log.I);

    if (statusCode == 200) {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreenA()),
        );
      });
    }
  }

// stateless widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const ColoredBox(color: Colors.cyan),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  'assets/garage.png',
                  height: 75,
                  width: 100,
                ),
              ),
              Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Card(
                      margin: const EdgeInsets.all(40),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: TextFormField(
                                      autocorrect: false,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        hintText: 'First Name',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                      ),
                                      controller: fNameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter username';
                                        } else if (value.length < 4) {
                                          return 'at least enter 4 characters';
                                        } else if (value.length > 13) {
                                          return 'maximum character is 13';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: TextFormField(
                                      autocorrect: false,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'Last Name',
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                      ),
                                      controller: lNameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter username';
                                        } else if (value.length < 4) {
                                          return 'at least enter 4 characters';
                                        } else if (value.length > 13) {
                                          return 'maximum character is 13';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: TextFormField(
                                      autocorrect: false,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'Email',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                      ),
                                      controller: emailController,
                                      validator: (value) {
                                        final bool isValid =
                                            EmailValidator.validate(value!);
                                        if (isValid == true) {
                                          return null;
                                        } else {
                                          return 'please enter valid email';
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                //password

                                Obx(
                                  () => SizedBox(
                                    height: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: TextFormField(
                                        style: kTextFormFieldStyle(),
                                        controller: passwordController,
                                        obscureText:
                                            simpleUIController.isObscure.value,
                                        decoration: InputDecoration(
                                          prefixIcon:
                                              const Icon(Icons.lock_open),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              simpleUIController.isObscure.value
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              simpleUIController
                                                  .isObscureActive();
                                            },
                                          ),
                                          hintText: 'Password',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          contentPadding:
                                              const EdgeInsets.all(10.0),
                                        ),
                                        // The validator receives the text that the user has entered.

                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          } else if (value.length < 7) {
                                            return 'at least enter 6 characters';
                                          } else if (value.length > 13) {
                                            return 'maximum character is 13';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                Obx(
                                  () => SizedBox(
                                    height: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: TextFormField(
                                          style: kTextFormFieldStyle(),
                                          controller: confirmPasswordController,
                                          obscureText: simpleUIController
                                              .isObscure.value,
                                          decoration: InputDecoration(
                                            prefixIcon:
                                                const Icon(Icons.lock_open),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                            contentPadding:
                                                const EdgeInsets.all(10.0),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                simpleUIController
                                                        .isObscure.value
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
                                              onPressed: () {
                                                simpleUIController
                                                    .isObscureActive();
                                              },
                                            ),
                                            hintText: 'Confirm Password',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Empty';
                                            }
                                            if (value !=
                                                passwordController.text) {
                                              return "Password Don't Match";
                                            }
                                            return null;
                                          }),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        signUp(
                                            fNameController,
                                            lNameController,
                                            emailController,
                                            passwordController);
                                        // ... Navigate To your Home Page
                                      }
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    minWidth: 150,
                                    splashColor: Colors.green,
                                    color: Colors.cyan,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    child: const Text(
                                      'SIGN UP',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreenA()),
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'LOGIN',
                                            style: TextStyle(
                                              color: Colors.cyan,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
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
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
