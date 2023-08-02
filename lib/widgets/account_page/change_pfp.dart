import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import 'package:scribble/widgets/custom_button.dart';
import 'package:scribble/utils/image_picker.dart';

class ChangePfp extends StatelessWidget {
  final ImageSelector imageSelector = ImageSelector();
  final storageRef = FirebaseStorage.instance.ref();

  ChangePfp({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () async {
        HapticFeedback.lightImpact();

        try {
          if (context.mounted) {
            showGeneralDialog(
              context: context,
              barrierDismissible: false,
              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                return Container(
                  color: Colors.black.withOpacity(.5),
                  child: const Center(child: CircularProgressIndicator())
                );
              },
            );
          }

          XFile? image = await imageSelector.pick();
          User user = FirebaseAuth.instance.currentUser!;

          if (image != null) {
            if (user.photoURL != null) {
              await FirebaseStorage.instance.refFromURL(user.photoURL!).delete();
            }

            Reference imageRef = storageRef.child("users/${user.phoneNumber!}/${image.name}");

            await imageRef.putFile(File(image.path));

            user.updatePhotoURL(await imageRef.getDownloadURL());

            if (context.mounted) {
              Navigator.pop(context);
            }

            Get.snackbar(
              "Success!",
              "Your profile picture has been successfully changed.",
              colorText: Colors.white,
              icon: const Icon(Icons.verified_outlined, color: Colors.green),
              shouldIconPulse: false
            );
          } else {
            if (context.mounted) {
              Navigator.pop(context);
            }
            return;
          }
        } catch (exception) {
          Get.snackbar(
            "Error!",
            "We couldn't upload your picture.",
            colorText: Colors.white,
            icon: const Icon(Icons.warning_amber, color: Colors.red),
            shouldIconPulse: false
          );

          debugPrint(exception.toString());

          Navigator.pop(context);
          return;
        }
      },
      backgroundColor: Colors.white.withOpacity(.9),
      foregroundColor: Colors.black87,
      text: "Change Profile Picture",
    );
  }
}