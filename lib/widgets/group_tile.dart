import 'package:chatapp_firebase/pages/column_page.dart';
import 'package:chatapp_firebase/pages/planboard_page.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String plandboardId;
  final String planboardName;
  const GroupTile(
      {Key? key,
      required this.plandboardId,
      required this.planboardName,
      required this.userName})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

// deleteplanboard(plandboardId) async {
//   DocumentReference groupDocumentReference =
//       FirebaseFirestore.instance.collection("plandboards").doc(plandboardId);

//   groupDocumentReference
//       .delete()
//       .whenComplete(() => print("Deleted successfully"));
// }

class _GroupTileState extends State<GroupTile> {
  bool _isLoading = false;
  String planboardName = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
              plandboardId: widget.plandboardId,
              planboardName: widget.planboardName,
              userName: widget.userName,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                widget.planboardName.substring(0, 2).toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
            title: Text(
              widget.planboardName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // subtitle: Text(
            //   "Join the conversation as ${widget.userName}",
            //   style: const TextStyle(fontSize: 13),
            // ),
            trailing: Wrap(spacing: 12, // space between two icons
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: Color(0xff000000),
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: ((context, setState) {
                              return AlertDialog(
                                title: Container(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "Update Planboard : ${widget.planboardName} ",
                                    // textAlign: TextAlign.center,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _isLoading == true
                                        ? Center(
                                            child: CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          )
                                        : TextField(
                                            onChanged: (val) {
                                              setState(() {
                                                planboardName = val;
                                              });
                                            },
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    borderRadius: BorderRadius.circular(
                                                        16)),
                                                errorBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color: Colors.red),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    borderRadius: BorderRadius.circular(16))),
                                          ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Theme.of(context).primaryColor),
                                    child: const Text("Cancel"),
                                  ),
                                  Spacer(flex: 2),
                                  ElevatedButton(
                                    onPressed: () async {
                                      DatabaseService(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .editPlanBoard(
                                              // widget.plandboardId,
                                              // userName,
                                              planboardName,
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              planboardName)
                                          .whenComplete(() {
                                        Navigator.of(context).pop();
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Color(0xffF9ECEA),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0),
                                          )),
                                          content: Text(
                                            textAlign: TextAlign.center,
                                            'Planboard update successfully.',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontFamily: 'UbuntuRegular',
                                                color: Color(0xffE7A599)),
                                          ),
                                        ),
                                      );
                                      // }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Theme.of(context).primaryColor),
                                    child: const Text("Save"),
                                  )
                                ],
                              );
                            }));
                          });
                      // showDialog(
                      //     context: context,
                      //     builder: (context) => AlertDialog(
                      //           title: Text('Update Planboard : ${widget.planboardName} ',
                      //               style: TextStyle(
                      //                   color: Color(0xFFE8B2B2),
                      //                   fontFamily: 'UbuntuMedium',
                      //                   fontSize: 20)),
                      //           content: SingleChildScrollView(
                      //                   child: Container(
                      //                 height: 150,
                      //                 child: Column(
                      //                   children: [
                      //                     TextFormField(
                      //                       controller: txtGpaEdit,
                      //                       decoration:
                      //                           textInputDecoration.copyWith(
                      //                             hintText: "enter your new GPA",
                      //                               labelText: "GPA",
                      //                               labelStyle: TextStyle(
                      //                                 fontSize: 15.0,
                      //                                 fontFamily:
                      //                                     'UbuntuRegular',
                      //                                 color: Color(0xFF7F8A8E),
                      //                               ),
                      //                               errorStyle: TextStyle(
                      //                                   color:
                      //                                       Color(0xfffE7A599),
                      //                                   fontSize: 11,
                      //                                   fontFamily:
                      //                                       'UbuntuRegular'),
                      //                               prefixIcon: Icon(
                      //                                 Icons.onetwothree_rounded,
                      //                                 color: Color(0xfffE7A599),
                      //                               )),
                      //                       // maxLength: 1,
                      //                       keyboardType: TextInputType.number,
                      //                       inputFormatters: [
                      //                         FilteringTextInputFormatter.allow(
                      //                             RegExp('[0-4]'))
                      //                       ],
                      //                       onChanged: (val) {
                      //                         setState(() {
                      //                           gpa = val;
                      //                         });
                      //                       },
                      //                       validator: (val) {
                      //                         if (val == null || val.isEmpty) {
                      //                           return '! Please enter your GPA';
                      //                         }
                      //                         return null;
                      //                       },
                      //                     ),
                      //                     SizedBox(
                      //                       height: 20,
                      //                     ),
                      //                     SizedBox(
                      //                       width: double.infinity,
                      //                       child: ElevatedButton(
                      //                         style: ElevatedButton.styleFrom(
                      //                             primary: Color(0xFFE8B2B2),
                      //                             elevation: 0,
                      //                             padding: EdgeInsets.symmetric(
                      //                                 horizontal: 70,
                      //                                 vertical: 12),
                      //                             shape: RoundedRectangleBorder(
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(
                      //                                         60))),
                      //                         child: const Text(
                      //                           "OK",
                      //                           style: TextStyle(
                      //                               color: Colors.white,
                      //                               fontFamily: 'UbuntuMedium',
                      //                               fontSize: 16),
                      //                         ),
                      //                         onPressed: () {
                      //                           update();
                      //                         },
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ))
                      //           ,
                      //           actions: [
                      //             TextButton(
                      //               child: Text(
                      //                 "Cancel",
                      //                 style: TextStyle(
                      //                     color: Colors.white,
                      //                     fontSize: 16,
                      //                     fontFamily: "UbuntuMedium",
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //               onPressed: () {
                      //                 Navigator.pop(context);
                      //               },
                      //               style: TextButton.styleFrom(
                      //                   // foregroundColor: Colors.white,
                      //                   padding: const EdgeInsets.all(16.0),
                      //                   textStyle:
                      //                       const TextStyle(fontSize: 20),
                      //                   backgroundColor: Colors.red),
                      //               // border: Border.all(
                      //               //   color: AppColors.colorMain, //Add color of your choice
                      //               // ),
                      //             ),
                      //             TextButton(
                      //               child: Text(
                      //                 "Confirm",
                      //                 style: TextStyle(
                      //                     color: Colors.white,
                      //                     fontSize: 16,
                      //                     fontFamily: "UbuntuMedium",
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //               onPressed: () async {
                      //                 DatabaseService(
                      //                         uid: FirebaseAuth
                      //                             .instance.currentUser!.uid)
                      //                     .editPlanBoard(
                      //                         widget.plandboardId,
                      //                         widget.userName,
                      //                         widget.planboardName
                      //                         )
                      //                     .whenComplete(() {
                      //                   // _isLoading = false;
                      //                   Navigator.of(context).pop();
                      //                 });

                      //                 ScaffoldMessenger.of(context)
                      //                     .showSnackBar(
                      //                   SnackBar(
                      //                     backgroundColor: Color(0xffF9ECEA),
                      //                     shape: RoundedRectangleBorder(
                      //                         borderRadius: BorderRadius.only(
                      //                       topLeft: Radius.circular(20.0),
                      //                       topRight: Radius.circular(20.0),
                      //                     )),
                      //                     content: Text(
                      //                       textAlign: TextAlign.center,
                      //                       'Delete successfully.',
                      //                       style: TextStyle(
                      //                           fontSize: 15.0,
                      //                           fontFamily: 'UbuntuRegular',
                      //                           color: Color(0xffE7A599)),
                      //                     ),
                      //                   ),
                      //                 );
                      //                 // });
                      //               },
                      //               style: TextButton.styleFrom(
                      //                   padding: const EdgeInsets.all(16.0),
                      //                   textStyle:
                      //                       const TextStyle(fontSize: 20),
                      //                   backgroundColor: Colors.green),
                      //             )
                      //           ],
                      //           // ).show();
                      //         ));
                      // txtEtcEdit.text = itemEtc[index].title;
                      // Alert(
                      //   context: context,
                      //   content: Container(
                      //       child: Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: <Widget>[
                      //         Column(children: [
                      //           Container(
                      //             child: Row(
                      //               children: [
                      //                 Checkbox(
                      //                   value: checkBoxIdCard,
                      //                   onChanged: (value) {
                      //                     setState(() {
                      //                       checkBoxIdCard = value!;
                      //                     });
                      //                   },
                      //                 ), //Checkbox
                      //                 Flexible(
                      //                   child: Text(
                      //                     'Edit etc.',
                      //                     textAlign: TextAlign.left,
                      //                     style: TextStyle(
                      //                         fontSize: 17.0,
                      //                         fontWeight: FontWeight.bold),
                      //                   ),
                      //                 ),
                      //                 Icon(
                      //                   Icons.add_circle_outline_outlined,
                      //                   color: Colors.black,
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           TextField(
                      //             controller: txtEtcEdit,
                      //             decoration: InputDecoration(
                      //               hintText: "Enter Edit Etc",
                      //             ),
                      //           ),
                      //         ]),
                      //       ])),
                      //   buttons: [
                      //     DialogButton(
                      //       child: Text(
                      //         "Cancel",
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 16,
                      //             fontFamily: "Itim",
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //       onPressed: () {
                      //         Alert(context: context).dismiss();
                      //       },
                      //       color: Colors.redAccent,
                      //       radius: BorderRadius.circular(25.0),
                      //       // border: Border.all(
                      //       //   color: AppColors.colorMain, //Add color of your choice
                      //       // ),
                      //     ),
                      //     DialogButton(
                      //       child: Text(
                      //         "Update",
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //       onPressed: () async {
                      //         DatabaseReference newRef = _db.child('Etc');
                      //         var EtcIdEdit = itemEtc[index].etc_id;
                      //         await newRef
                      //             .child(AppUrl.UserID)
                      //             .child('${widget._travelId}')
                      //             .child(EtcIdEdit)
                      //             .update({
                      //           'etc_id': EtcIdEdit,
                      //           'title': txtEtcEdit.text,
                      //           'checked': listCheckBoxEct[index],
                      //         }).then((onValue) {
                      //           setState(() {
                      //             Alert(context: context).dismiss();
                      //             txtEtcEdit.text = "";
                      //             EasyLoading.showSuccess(
                      //               "Edit Success",
                      //             );
                      //             loadData();
                      //           });
                      //           return true;
                      //         }).catchError((onError) {
                      //           return false;
                      //         });
                      //       },
                      //       radius: BorderRadius.circular(25.0),
                      //       color: Colors.green,
                      //     )
                      //   ],
                      // ).show();
                    },
                    // child: const Text("Edit",
                    //     style: TextStyle(
                    //         fontSize: 14, fontWeight: FontWeight.w400)
                    //         ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Color(0xff000000),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Confirm Delete',
                                    style: TextStyle(
                                        color: Color(0xFFE8B2B2),
                                        fontFamily: 'UbuntuMedium',
                                        fontSize: 20)),
                                content: Text(
                                    'Do you really want to delete this ${widget.planboardName} ? '),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: "UbuntuMedium",
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                        // foregroundColor: Colors.white,
                                        padding: const EdgeInsets.all(16.0),
                                        textStyle:
                                            const TextStyle(fontSize: 20),
                                        backgroundColor: Colors.red),
                                    // border: Border.all(
                                    //   color: AppColors.colorMain, //Add color of your choice
                                    // ),
                                  ),
                                  TextButton(
                                    child: Text(
                                      "Confirm",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: "UbuntuMedium",
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {
                                      DatabaseService(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .deletePlanBoard(
                                              widget.plandboardId,
                                              widget.userName,
                                              widget.planboardName)
                                          .whenComplete(() {
                                        // _isLoading = false;
                                        Navigator.of(context).pop();
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Color(0xffF9ECEA),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0),
                                          )),
                                          content: Text(
                                            textAlign: TextAlign.center,
                                            'Delete successfully.',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontFamily: 'UbuntuRegular',
                                                color: Color(0xffE7A599)),
                                          ),
                                        ),
                                      );

                                      // setState(() {
                                      //   Navigator.pop(context);
                                      //   final CollectionReference
                                      //       groupCollection = FirebaseFirestore
                                      //           .instance
                                      //           .collection("plandboards");
                                      //   deleteplandboard(
                                      //       String plandboardId) async {
                                      //     return groupCollection
                                      //         .doc(plandboardId)
                                      //         // .collection("messages")
                                      //         // .orderBy("time")
                                      //         .delete()
                                      //         .then((val) {
                                      //       ScaffoldMessenger.of(context)
                                      //           .showSnackBar(
                                      //         SnackBar(
                                      //           backgroundColor:
                                      //               Color(0xffF9ECEA),
                                      //           shape: RoundedRectangleBorder(
                                      //               borderRadius:
                                      //                   BorderRadius.only(
                                      //             topLeft:
                                      //                 Radius.circular(20.0),
                                      //             topRight:
                                      //                 Radius.circular(20.0),
                                      //           )),
                                      //           content: Text(
                                      //             textAlign: TextAlign.center,
                                      //             "Delete Successful !!",
                                      //             style: TextStyle(
                                      //                 fontSize: 15.0,
                                      //                 fontFamily:
                                      //                     'UbuntuRegular',
                                      //                 color: Color(0xffE7A599)),
                                      //           ),
                                      //         ),
                                      //       );
                                      //       Navigator.pushReplacement(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //           builder: (context) =>
                                      //               PlanboardPage(),
                                      //         ),
                                      //       );
                                      //       // showSuccess(
                                      //       //   "Delete Success",
                                      //       // ).
                                      //       // snapshots();
                                      //     });
                                      //   }
                                      // });
                                    },
                                    style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(16.0),
                                        textStyle:
                                            const TextStyle(fontSize: 20),
                                        backgroundColor: Colors.green),
                                  )
                                ],
                                // ).show();
                              ));
                    },
                  ),
                  // ElevatedButton(
                  //   style: ButtonStyle(
                  //       foregroundColor:
                  //           MaterialStateProperty.all<Color>(Colors.black),
                  //       backgroundColor: MaterialStateProperty.all<Color>(
                  //           const Color.fromRGBO(196, 196, 196, 1)),
                  //       shape:
                  //           MaterialStateProperty.all<RoundedRectangleBorder>(
                  //               RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(18.0),
                  //         // side: const BorderSide(
                  //         //     width: 1,
                  //         //     color: AppColors.color_black,
                  //         //     style: BorderStyle.solid),
                  //       ))),
                  //   onPressed: () {
                  //     // Alert(
                  //     //   context: context,
                  //     //   // type: obj_status["statusCode"] == 200 ? AlertType.success : AlertType.error,
                  //     //   type: AlertType.warning,
                  //     //   title: "Confirm Delete",
                  //     //   desc:
                  //     //       "Do you want to delete the ${itemEtc[index].title} ? ",
                  //     //   buttons: [
                  //     //     DialogButton(
                  //     //       child: Text(
                  //     //         "Cancel",
                  //     //         style: TextStyle(
                  //     //             color: Colors.white,
                  //     //             fontSize: 16,
                  //     //             fontFamily: "Itim",
                  //     //             fontWeight: FontWeight.bold),
                  //     //       ),
                  //     //       onPressed: () {
                  //     //         Alert(context: context).dismiss();
                  //     //       },
                  //     //       color: Colors.redAccent,
                  //     //       radius: BorderRadius.circular(25.0),
                  //     //       // border: Border.all(
                  //     //       //   color: AppColors.colorMain, //Add color of your choice
                  //     //       // ),
                  //     //     ),
                  //     //     DialogButton(
                  //     //       child: Text(
                  //     //         "Confirm",
                  //     //         style: TextStyle(
                  //     //             color: Colors.white,
                  //     //             fontSize: 16,
                  //     //             fontWeight: FontWeight.bold),
                  //     //       ),
                  //     //       onPressed: () async {
                  //     //         setState(() {
                  //     //           Alert(context: context).dismiss();
                  //     //           _db = FirebaseDatabase.instance.ref();
                  //     //           _db
                  //     //               .child('Etc')
                  //     //               .child(AppUrl.UserID)
                  //     //               .child('${widget._travelId}')
                  //     //               .child('${itemEtc[index].etc_id}')
                  //     //               .remove()
                  //     //               .then((value) {
                  //     //             EasyLoading.showSuccess(
                  //     //               "Delete Success",
                  //     //             );
                  //     //             loadData();
                  //     //           });
                  //     //         });
                  //     //       },
                  //     //       radius: BorderRadius.circular(25.0),
                  //     //       color: Colors.green,
                  //     //     )
                  //     //   ],
                  //     // ).show();
                  //   },
                  //   child: const Text("Delete",
                  //       style: TextStyle(
                  //           fontSize: 14, fontWeight: FontWeight.w400)),
                  // ),
                ])),
      ),
    );
  }
}
