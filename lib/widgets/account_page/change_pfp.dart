import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            CroppedFile? croppedImage = await ImageCropper().cropImage(
              sourcePath: image.path,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
              ],
              maxHeight: 100,
              maxWidth: 100,
              compressFormat: ImageCompressFormat.png,
              aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
              uiSettings: [
                AndroidUiSettings(
                  toolbarTitle: "Crop Image",
                  toolbarColor: Colors.purple,
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.square,
                  lockAspectRatio: true
                ),
                IOSUiSettings(
                  title: "Crop Image",
                  aspectRatioLockEnabled: true,
                  resetAspectRatioEnabled: false,
                  aspectRatioLockDimensionSwapEnabled: false,
                  minimumAspectRatio: 1,
                ),
              ],
            );

            if (context.mounted) {
              if (croppedImage != null) {
                updatePfp(
                  user: user,
                  path: croppedImage.path,
                  name: image.name,
                  context: context
                );
              } else {
                Navigator.pop(context);
                return;
              }
            }
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

  Future<void> updatePfp({
    required User user,
    required String path,
    required String name,
    required BuildContext context
  }) async {
    if (user.photoURL != null) {
      await FirebaseStorage.instance.refFromURL(user.photoURL!).delete();
    }

    final userRef =  FirebaseFirestore.instance.collection("users").doc(
      FirebaseAuth.instance.currentUser!.phoneNumber!
    );

    Reference imageRef = storageRef.child("users/${user.phoneNumber!}/$name");

    await imageRef.putFile(File(path));

    String downloadUrl = await imageRef.getDownloadURL();

    user.updatePhotoURL(downloadUrl);
    userRef.update({
      "photoUrl": downloadUrl
    });

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
  }
}