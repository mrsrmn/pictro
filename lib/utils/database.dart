import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Database {
  final Reference ref = FirebaseStorage.instance.ref();

  Future<void> putData(Uint8List data, String sentTo) async {
    User user = FirebaseAuth.instance.currentUser!;
    DocumentReference documentReference = FirebaseFirestore.instance.collection("users").doc(
        FirebaseAuth.instance.currentUser!.phoneNumber!
    ).collection("private").doc("data");
    List receivedScribbs = ((await documentReference.get()).data()! as Map<String, dynamic>)["receivedScribbs"]!;

    final photoRef = ref.child(
      "images/$sentTo/${user.phoneNumber}/${const Uuid().v1()}.png"
    );

    try {
      await photoRef.putData(data);
      receivedScribbs.add({
        "sentBy": user.phoneNumber!,
        "url": await photoRef.getDownloadURL()
      });
      await documentReference.set({
        "receivedScribbs": receivedScribbs
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}