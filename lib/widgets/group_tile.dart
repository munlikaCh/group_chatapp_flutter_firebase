import 'package:chatapp_firebase/pages/chat_page.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
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
                  ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(196, 196, 196, 1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          // side: const BorderSide(
                          //     width: 1,
                          //     color: AppColors.color_black,
                          //     style: BorderStyle.solid),
                        ))),
                    onPressed: () {
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
                    child: const Text("Edit",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400)),
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
                                    'Do you want to delete the ${widget.planboardName} ? '),
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
                                              widget.planboardName
                                              )
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
                                      //               HomePage(),
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
