import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Database {
  final Reference ref = FirebaseStorage.instance.ref();

  Future<void> putData(Uint8List data, String sentTo) async {
    User user = FirebaseAuth.instance.currentUser!;
    DocumentReference sentToDocumentReference = FirebaseFirestore.instance.collection("users").doc(
        sentTo
    ).collection("private").doc("data");
    DocumentReference senderDocumentReference = FirebaseFirestore.instance.collection("users").doc(
        user.phoneNumber!
    ).collection("private").doc("data");

    final photoRef = ref.child(
      "images/$sentTo/${user.phoneNumber}/${const Uuid().v1()}.png"
    );

    try {
      await photoRef.putData(data);
      await sentToDocumentReference.update({
        "receivedScribbs": FieldValue.arrayUnion([{
          "sentBy": user.phoneNumber!,
          "url": await photoRef.getDownloadURL(),
          "sentAt": Timestamp.now()
        }])
      });
      await senderDocumentReference.update({
        "sentScribbsTo": FieldValue.arrayUnion([sentTo])
      });
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

    List sentScribbsTo = ((await userDocumentReference.get()).data()! as Map<String, dynamic>)["sentScribbsTo"];

    if (sentScribbsTo.isNotEmpty) {
      for (var selectedUser in sentScribbsTo) {
        DocumentReference selectedUserDoc = FirebaseFirestore.instance.collection("users").doc(
            selectedUser
        ).collection("private").doc("data");

        final storageRef = FirebaseStorage.instance.ref("images/$selectedUser/$userPhone");
        final listResult = await storageRef.listAll();
        for (var item in listResult.items) {
          await item.delete();
        }

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