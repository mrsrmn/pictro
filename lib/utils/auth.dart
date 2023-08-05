import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scribble/utils/auth_values.dart';

class Authentication extends GetxController {
  static Authentication get instance => Get.find();
  var verificationId = "".obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendSMS(String phoneNumber) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      timeout: const Duration(seconds: 120),
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == "invalid-phone-number") {
          throw Exception("Invalid phone number.");
        } else if (e.code == "invalid-credential") {
          throw Exception("Invalid SMS code.");
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<AuthValues> verifyOTP(String smsCode) async {
    try {
      UserCredential credential = await auth.signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: smsCode
      ));

      return credential.user != null ? AuthValues.success : AuthValues.error;
    } on FirebaseAuthException catch (e, _) {
      debugPrint(e.code);

      if (e.code == "unknown") {
        return AuthValues.unknown;
      } else if (e.code == "invalid-credential") {
        return AuthValues.invalidSmsCode;
      } else {
        return AuthValues.error;
      }
    }
  }
}
