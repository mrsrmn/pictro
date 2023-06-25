import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;

  void register(String phoneNumber) async {
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
        print("hkk");
        String smsCode = 'xxxx';
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: smsCode
        );

        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
