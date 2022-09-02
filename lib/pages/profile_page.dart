import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helper/helper_function.dart';
import '../service/database_service.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String userGpa;
  String email;
  ProfilePage(
      {Key? key,
      required this.email,
      required this.userName,
      required this.userGpa})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String gpa = "";
  String userGpa = "";
  var txtGpaEdit = TextEditingController();
  AuthService authService = AuthService();

  User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  // final _ctrupdategpa = TextEditingController();

  update() async {
    final String? uid;
    final userCollection =
      FirebaseFirestore.instance
      .collection("users");
      
      userCollection.doc().update({
        "gpa":gpa,
      });
    // HelperFunctions.updatesaveUserGpaSF(gpa);

    // await HelperFunctions.updategetUserGpaFromSF().then((val) {
    //   setState(() {
    //     userGpa = val!;
    //   });
    // });
    
     Navigator.pop(context);
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
          'Update GPA Successful!!',
          style: TextStyle(
              fontSize: 15.0,
              fontFamily: 'UbuntuRegular',
              color: Color(0xffE7A599)),
        ),
      ),
    );
    // --------------------------------------------------------------
    // if (formKey.currentState!.validate()) {
    //   // setState(() {
    //   //   _isLoading = true;
    //   // });
    //   // await authService
    //   //     .registerUserWithEmailandPassword(gpa)
    //   //     .then((value) async {
    //   //   if (value == true) {
    //   //     // saving the shared preference state
    //   //     await HelperFunctions.saveUserLoggedInStatus(true);
    //   //     await HelperFunctions.saveUserGpaSF(gpa);
    //   //     // nextScreenReplace(context, const ProfilePage());
    //   //   } else {
    //   //     showSnackbar(context, Color(0xffE7A599), value);
    //   //     setState(() {
    //   //       _isLoading = false;
    //   //     });
    //   //   }
    //   // }
    //   // );
    // }
  }

  verifyEmail() async {
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      print('Verification Email has benn sent');
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
            'Verification Email has benn sent',
            style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'UbuntuRegular',
                color: Color(0xffE7A599)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
          child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          // Icon(
          //   Icons.account_circle,
          //   size: 150,
          //   color: Colors.grey[700],
          // ),
          const SizedBox(
            height: 15,
          ),
          Text(
            widget.userName, // เรียกมาshow name
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          const Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {
              nextScreen(context, const HomePage());
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.border_color),
            title: const Text(
              "Plan Board",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {},
            selected: true,
            selectedColor: Theme.of(context).primaryColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              "Profile",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await authService.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  });
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      )),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Icon(
              //   Icons.account_circle,
              //   size: 200,
              //   color: Colors.grey[700],
              // ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 160,
                  left: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Name :", style: TextStyle(fontSize: 17)),
                    Container(
                      padding: const EdgeInsets.only(
                        right: 45,
                      ),
                      child: Row(
                        children: [
                          Text(widget.userName,
                              style: const TextStyle(fontSize: 17)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("GPA goal :", style: TextStyle(fontSize: 17)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.userGpa,
                            style: const TextStyle(fontSize: 17)),
                        IconButton(
                          onPressed: () async {
                            // txtGpaEdit.text = itemEtc[index].title;
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                    title: Text(
                                        'Update Your GPA: '
                                        // + widget.userName
                                        ,
                                        style: TextStyle(
                                            color: Color(0xFFE8B2B2),
                                            fontFamily: 'UbuntuMedium',
                                            fontSize: 20)
                                            ),
                                    content: SingleChildScrollView(
                                        child: Container(
                                      height: 150,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: txtGpaEdit ,
                                            decoration:
                                                textInputDecoration.copyWith(
                                                  hintText: "enter your new GPA",
                                                    labelText: "GPA",
                                                    labelStyle: TextStyle(
                                                      fontSize: 15.0,
                                                      fontFamily:
                                                          'UbuntuRegular',
                                                      color: Color(0xFF7F8A8E),
                                                    ),
                                                    errorStyle: TextStyle(
                                                        color:
                                                            Color(0xfffE7A599),
                                                        fontSize: 11,
                                                        fontFamily:
                                                            'UbuntuRegular'),
                                                    prefixIcon: Icon(
                                                      Icons.onetwothree_rounded,
                                                      color: Color(0xfffE7A599),
                                                    )),
                                            // maxLength: 1,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[0-4]'))
                                            ],
                                            onChanged: (val) {
                                              setState(() {
                                                gpa = val;
                                              });
                                            },
                                            validator: (val) {
                                              if (val == null || val.isEmpty) {
                                                return '! Please enter your GPA';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFFE8B2B2),
                                                  elevation: 0,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 70,
                                                      vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60))),
                                              child: const Text(
                                                "OK",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'UbuntuMedium',
                                                    fontSize: 16),
                                              ),
                                              onPressed: () {
                                                update();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))));
                          },
                          icon: const Icon(
                            Icons.create_outlined,
                            color: Color.fromARGB(255, 158, 158, 158),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Email : ", style: TextStyle(fontSize: 17)),
                    Container(
                      padding: const EdgeInsets.only(
                        right: 45,
                      ),
                      child: Row(
                        children: [
                          Text(widget.email,
                              style: const TextStyle(fontSize: 17)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    user!.emailVerified
                        ? Text(
                            'Verified :)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'UbuntuRegular',
                                color: Color(0xFF8BD06B)),
                          )
                        : TextButton(
                            onPressed: () => {verifyEmail()},
                            child: Text(
                              'Verify Email',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'UbuntuRegular',
                                  color: Color(0xFFE7A599)),
                            ))
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 50.0, left: 0.0, right: 0.0),
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Logout"),
                            content:
                                const Text("Are you sure you want to logout?"),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await authService.signOut();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: Text('Log out',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'UbuntuMedium',
                          fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFFE8B2B2),
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
