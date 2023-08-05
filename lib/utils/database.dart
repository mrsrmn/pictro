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
        sentTo
    ).collection("private").doc("data");

    final photoRef = ref.child(
      "images/$sentTo/${user.phoneNumber}/${const Uuid().v1()}.png"
    );

    try {
      await photoRef.putData(data);
      await documentReference.update({
        "receivedScribbs": FieldValue.arrayUnion([{
          "sentBy": user.phoneNumber!,
          "url": await photoRef.getDownloadURL(),
          "sentAt": Timestamp.now()
        }])
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}