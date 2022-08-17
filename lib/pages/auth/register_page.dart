import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
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
                            "Create Account",
                            style: TextStyle(
                              fontFamily: 'UbuntuBold',
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE7A599),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // const Text(
                        //     "Create your account now to chat and explore",
                        //     style: TextStyle(
                        //         fontSize: 15, fontWeight: FontWeight.w400)),
                        // Image.asset("assets/register.png"),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: "Name",
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
                                Icons.person,
                                color: Color(0xfffE7A599),
                              )),
                          onChanged: (val) {
                            setState(() {
                              fullName = val;
                            });
                          },
                          validator: (val) {
                            if (val!.isNotEmpty) {
                              return null;
                            } else {
                              return "! Please enter your name";
                            }
                          },
                        ),
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
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Password",
                              labelStyle: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'UbuntuRegular',
                                  color: Color(0xFF7F8A8E)),
                              errorStyle: TextStyle(
                                  color: Color(0xfffE7A599),
                                  fontSize: 11,
                                  fontFamily: 'UbuntuRegular'),
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
                                elevation: 0,
                                padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60))),
                            child: const Text(
                              "SIGN UP",
                              style:
                                  TextStyle(color: Colors.white,  fontFamily: 'UbuntuMedium',fontSize: 16),
                            ),
                            onPressed: () {
                              register();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                          text: "Already have an account? ",
                          style: const TextStyle(
                              color:Color(0xFFE7A599), fontSize: 14),
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

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context,Color(0xffE7A599), value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
