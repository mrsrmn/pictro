import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Database {
  final Reference ref = FirebaseStorage.instance.ref();

  Future<void> putData(Uint8List data, String sentTo) async {
    final photoRef = ref.child(
      "images/$sentTo/${FirebaseAuth.instance.currentUser!.uid}/${const Uuid().v1()}.png"
    );

    try {
      await photoRef.putData(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}