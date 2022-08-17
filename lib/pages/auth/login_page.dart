import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/register_page.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'forgotpassw_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Color(0xfffE7A599)),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(
                              top: 120.0, left: 0.0, right: 0.0),
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            "Welcome to Bearlance",
                            style: TextStyle(
                                fontSize: 40,
                                fontFamily: 'UbuntuBold',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE7A599),
                                decoration: TextDecoration.none),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // const Text("Login now to see what they are talking!",
                        //     style: TextStyle(
                        //         fontSize: 15, fontWeight: FontWeight.w400)),
                        // Image.asset("assets/login.png"),
                        Container(
                          child: TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Email",
                                labelStyle: TextStyle(
                                  fontFamily: 'UbuntuRegular',
                                  fontSize: 15.0,
                                  color: Color(0xFF7F8A8E),
                                ),
                                // border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(16.0)),
                                errorStyle: TextStyle(
                                  color: Color(0xfffE7A599),
                                  fontSize: 11,
                                  fontFamily: 'UbuntuRegular',
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Color(0xfffE7A599),
                                )),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },

                            // check tha validation
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return '! Please enter your e-mail';
                              } else if (!val.contains('@gmail.com')) {
                                return '! Sorry, only letters(a-z), numbers(0-9), and periods(.) are allowed.';
                              }
                              return null;
                              // return RegExp(
                              //             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              //         .hasMatch(val!)
                              //     ? null
                              //     : "! Please enter your e-mail";
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Password",
                              labelStyle: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'UbuntuRegular',
                                  color: Color(0xFF7F8A8E)),
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(16.0)),
                              errorStyle: TextStyle(
                                color: Color(0xfffE7A599),
                                fontSize: 11,
                                fontFamily: 'UbuntuRegular',
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Color(0xfffE7A599),
                              )),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return '! Please enter your password';
                            }
                            if (val!.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFFE8B2B2),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 70, vertical: 12),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60))),
                            child: const Text(
                              "LOG IN",
                              style:
                                  TextStyle(
                                    color: Colors.white, 
                                    fontSize: 16, 
                                    fontFamily: 'UbuntuMedium'),
                            ),
                            onPressed: () {
                              login();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                            text: "Forgot Your Password ?'",
                            style: const TextStyle(
                              fontFamily: 'UbuntuRegular',
                                fontSize: 15.0, color: Color(0xFFE7A599)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                nextScreen(context, const ForgetpassPage());
                              })),
                        
                        Container(
                          // margin: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "_________________________________________________",
                                style: TextStyle(color: Color(0xFFE7A599)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                            fontFamily: 'UbuntuRegular',
                              color: Color(0xFFE7A599), 
                              fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Register here",
                                style: const TextStyle(
                                    color: Color(0xFFE7A599), 
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const RegisterPage());
                                  }),
                          ],
                        )),
                      ],
                    )),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          await HelperFunctions.saveUserGpaSF(snapshot.docs[0]['gpa']);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Color(0xffE7A599), value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
