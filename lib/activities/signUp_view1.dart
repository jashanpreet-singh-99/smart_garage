import 'package:flutter/material.dart';
import 'dart:convert';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_garage/activities/login_screen1.dart';
import 'package:smart_garage/utils/config.dart';
import 'package:smart_garage/activities/login_screen.dart';
import 'package:smart_garage/utils/constants.dart';
import 'package:smart_garage/controller/simple_ui_controller.dart';
import 'package:email_validator/email_validator.dart';

class SignUpView1 extends StatefulWidget {
  const SignUpView1({Key? key}) : super(key: key);

  @override
  State<SignUpView1> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView1> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    fnameController.dispose();
    lnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  void signUp(TextEditingController first, TextEditingController last, TextEditingController email, TextEditingController password) async {
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

    if(statusCode == 200)
    {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreenA()),
      );
    }
  }

// stateless widget



  @override

    Widget build(BuildContext context) {
      var size = MediaQuery.of(context).size;
      var theme = Theme.of(context);

      return Scaffold(

      resizeToAvoidBottomInset: true,


      body: Stack(
        fit: StackFit.expand,

        children: <Widget>[
          const ColoredBox(color: Colors.lightBlue),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset('assets/garage.png',
                  height: 75,
                  width: 100,
                ),
              ),

              Stack(
                children: <Widget>[
                  SingleChildScrollView(

                    child: Container(


                      //height: 575,
                      width: 300,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        shape: BoxShape.rectangle,
                      ),

                      child: Form(
                        key: _formKey,
                        child: Column(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical:10,
                            ),
                          child: TextFormField(
                            autocorrect: false,
                            autofocus: false,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Firstname',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: const EdgeInsets.all(10.0),

                            ),
                            controller: fnameController,
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
                          ),),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical:10,
                            ),
                            child: TextFormField(
                              autocorrect: false,
                              autofocus: false,
                              obscureText: false,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Lastname',
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.all(10.0),

                              ),
                              controller: lnameController,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical:10,
                            ),
                            child: TextFormField(
                              autocorrect: false,
                              autofocus: false,
                              obscureText: false,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.all(10.0),

                              ),
                            controller: emailController,
                            validator: (value) {

                              final bool isValid = EmailValidator.validate(value!);
                              if( isValid == true)
                              {return null; }
                              else
                                return 'please enter valid email';

                            },
                            ),
                          ),
                          //password

                          Obx(
                                () => TextFormField(
                              style: kTextFormFieldStyle(),
                              controller: passwordController,
                              obscureText: simpleUIController.isObscure.value,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_open),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    simpleUIController.isObscure.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    simpleUIController.isObscureActive();
                                  },
                                ),
                                hintText: 'Password',
                                border: InputBorder.none

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

                          Obx(
                                () => TextFormField(
                              style: kTextFormFieldStyle(),
                              controller: confirmPasswordController,
                              obscureText: simpleUIController.isObscure.value,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock_open),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      simpleUIController.isObscure.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      simpleUIController.isObscureActive();
                                    },
                                  ),
                                  hintText: 'Confirm Password',
                                  border: InputBorder.none

                              ),
                              // The validator receives the text that the user has entered.

                                validator: (value) {
                                  if(value == null || value.isEmpty) {
                                    return 'Empty';
                                  }
                                    if(value != passwordController.text) {
                                      return "Password Don't Match";
                                    }
                                    return null;
                                    }

                            ),
                          ),
                          MaterialButton(
                            onPressed: (){
                              print("Signup pressed");
                              if (_formKey.currentState!.validate()) {
                                print("Signup pressed inside validator");
                                signUp(fnameController, lnameController, emailController, passwordController);
                                // ... Navigate To your Home Page
                              }
                            },
                            shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(50)),

                            minWidth: 250,
                            splashColor: Colors.green,
                            color: Colors.lightBlue,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),

                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginScreenA()),
                                );
                                 },
                                child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontSize: 14,
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
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
