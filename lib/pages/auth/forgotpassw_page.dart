import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../service/auth_service.dart';
import '../../widgets/widgets.dart';
import '../planboard_page.dart';
import 'login_page.dart';

class ForgetpassPage extends StatefulWidget {
  const ForgetpassPage({Key? key}) : super(key: key);

  @override
  State<ForgetpassPage> createState() => _ForgetpassPageState();
}

class _ForgetpassPageState extends State<ForgetpassPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  AuthService authService = AuthService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
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
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            "Reset Password",
                            style: TextStyle(
                                fontSize: 40,
                                fontFamily: 'UbuntuMedium',
                                color: Color(0xFFE7A599),
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        // const SizedBox(height: 5),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(10),
                          child: const Text("Please enter your email:",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'UbuntuRegular',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFE7A599))),
                        ),
                        // Image.asset("assets/register.png"),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              labelStyle: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'UbuntuRegular',
                                color: Color(0xFF7F8A8E),
                              ),
                              errorStyle: TextStyle(
                                  color: Color(0xfffE7A599),
                                  fontSize: 11,
                                  fontFamily: 'UbuntuRegular'),
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
                            //     : "Please enter a valid email";
                          },
                        ),

                        Container(
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 0.0, right: 0.0),
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            'We will send you an email with instructions on how to reset your password.',
                            style: TextStyle(
                                fontFamily: 'UbuntuRegular',
                                fontSize: 15.0,
                                // fontWeight: FontWeight.bold,
                                color: Color(0xFFE7A599)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFFE8B2B2),
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 70, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60))),
                            child: const Text(
                              "Reset Password",
                              style:
                                  TextStyle(color: Colors.white,fontFamily: 'UbuntuMedium', fontSize: 16),
                            ),
                            onPressed: () {
                          // Validate returns true if the form is valid, otherwise false.
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              email;
                            });
                            resetPassword();
                          }
                        },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                          text: "Already have an account? ",
                          style: const TextStyle(
                              color: Color(0xffE7A599), fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Login now",
                                style: const TextStyle(
                                   color: Color(0xFFE7A599), 
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const LoginPage());
                                  }),
                          ],
                        )),
                      ],
                    )),
              ),
            ),
    );
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xffF9ECEA),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          )),
          content: Text(
            textAlign: TextAlign.center,
            'Sent Reset Password Successful!!',
            style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'UbuntuRegular',
                color: Color(0xffE7A599)),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('There was no user found for this email address');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xffF9ECEA),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            )),
            content: Text(
              textAlign: TextAlign.center,
              'There was no user found for this email address',
              style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'UbuntuRegular',
                  color: Color(0xffE7A599)),
            ),
          ),
        );
      }
    }
  }
}
