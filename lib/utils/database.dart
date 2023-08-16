import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class Database {
  final Reference ref = FirebaseStorage.instance.ref();

  Future<void> putData(Uint8List data, List<String> sentToList) async {
    User user = FirebaseAuth.instance.currentUser!;
    String number = user.phoneNumber!;
    DocumentReference senderDocumentReference = FirebaseFirestore.instance.collection("users").doc(
        number
    ).collection("private").doc("data");
    Timestamp now = Timestamp.now();

    try {
      final photoRef = ref.child(
        "images/$number/${const Uuid().v1()}.png"
      );

      await photoRef.putData(data);
      String downloadUrl = await photoRef.getDownloadURL();

      for (var sentTo in sentToList) {
        DocumentReference sentToDocumentReference = FirebaseFirestore.instance.collection(
          "users"
        ).doc(sentTo);

        await sentToDocumentReference.collection("private").doc("data").update({
          "receivedScribbs": FieldValue.arrayUnion([{
            "sentBy": number,
            "url": downloadUrl,
            "sentAt": now
          }])
        });
        await senderDocumentReference.update({
          "sentScribbsTo": FieldValue.arrayUnion([sentTo])
        });

        await http.post(
          Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": "key=${dotenv.env["AUTH_TOKEN"]}"
          },
          body: jsonEncode({
            "to": "/topics/${sentTo.replaceAll("+", "")}",
            "notification": {
              "title": "${user.displayName!} has just shared a new Scribb!",
              "body": "See what they sent you",
            },
          })
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteUserData() async {
    User user = FirebaseAuth.instance.currentUser!;
    String userPhone = user.phoneNumber!;
    DocumentReference userDocumentReference = FirebaseFirestore.instance.collection("users").doc(
      userPhone
    ).collection("private").doc("data");

    final storageRef = FirebaseStorage.instance.ref("images/$userPhone");
    final listResult = await storageRef.listAll();
    for (var item in listResult.items) {
      await item.delete();
    }

    List sentScribbsTo = ((await userDocumentReference.get()).data()! as Map<String, dynamic>)["sentScribbsTo"];

    if (sentScribbsTo.isNotEmpty) {
      for (var selectedUser in sentScribbsTo) {
        DocumentReference selectedUserDoc = FirebaseFirestore.instance.collection("users").doc(
            selectedUser
        ).collection("private").doc("data");

        List selectedUserReceivedScribbs = ((await selectedUserDoc.get()).data()! as Map)["receivedScribbs"] as List;
        for (Map scribb in selectedUserReceivedScribbs) {
          if (scribb["sentBy"] == userPhone) {
            selectedUserReceivedScribbs.remove(scribb);
          }
        }

        selectedUserDoc.update({
          "receivedScribbs": selectedUserReceivedScribbs
        });
      }
    }

    if (user.photoURL != null) {
      await FirebaseStorage.instance.refFromURL(user.photoURL!).delete();
    }

    await user.delete();
  }
}