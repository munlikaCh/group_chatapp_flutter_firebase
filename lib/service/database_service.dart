import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("plandboards");

  // saving the userdata
  Future savingUserData(String fullName, String gpa, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "gpa": gpa,
      "email": email,
      "plandboards": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user plandboards
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // // getting the chats
  // updateUserGPA(String gpa) async {
  //   return userCollection
  //       .doc(gpa)
  //       .snapshots();
  // }

  // creating a group
  Future createPlanBoard(
      String userName, String id, String planboardName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "planboardName": planboardName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "plandboardId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "plandboardId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "plandboards":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$planboardName"])
    });
  }

  // getting the chats
  getChats(String plandboardId) async {
    return groupCollection
        .doc(plandboardId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String plandboardId) async {
    DocumentReference d = groupCollection.doc(plandboardId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(plandboardId) async {
    return groupCollection.doc(plandboardId).snapshots();
  }

  // search
  searchByName(String planboardName) {
    return groupCollection
        .where("planboardName", isEqualTo: planboardName)
        .get();
  }

  // function -> bool
  Future<bool> isUserJoined(
      String planboardName, String plandboardId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> plandboards = await documentSnapshot['plandboards'];
    if (plandboards.contains("${plandboardId}_$planboardName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String plandboardId, String userName, String planboardName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference =
        groupCollection.doc(plandboardId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> plandboards = await documentSnapshot['plandboards'];

    // if user has our plandboards -> then remove then or also in other part re join
    if (plandboards.contains("${plandboardId}_$planboardName")) {
      await userDocumentReference.update({
        "plandboards":
            FieldValue.arrayRemove(["${plandboardId}_$planboardName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "plandboards": FieldValue.arrayUnion(["${plandboardId}_$planboardName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  // send message
  sendMessage(String plandboardId, Map<String, dynamic> chatMessageData) async {
    groupCollection
        .doc(plandboardId)
        .collection("messages")
        .add(chatMessageData);
    groupCollection.doc(plandboardId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
