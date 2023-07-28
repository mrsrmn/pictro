import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scribble/pages/main_pages/start_page.dart';
import 'package:scribble/utils/constants.dart';
import 'package:scribble/widgets/custom_button.dart';

class SignOut extends StatelessWidget {
  const SignOut({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        HapticFeedback.lightImpact();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red,
              contentTextStyle: const TextStyle(color: Colors.white),
              title: const Text("Are you sure?", style: TextStyle(
                color: Colors.white,
                fontFamily: geologicaBold,
                fontSize: 18
              )),
              content: const Text("Your data won't be deleted and you can sign back in anytime you want.", style: TextStyle(
                color: Colors.white,
                fontFamily: geologicaMedium,
                fontSize: 15
              )),
              actions: [
                CustomButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  text: "No",
                ),
                CustomButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    FirebaseAuth.instance.signOut().then((_) {
                      Navigator.pop(context);

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const StartPage()),
                        (route) => false
                      );
                    });
                  },
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  text: "Yes",
                ),
              ],
            );
          }
        );
      },
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      text: "Sign Out",
    );
  }
}
