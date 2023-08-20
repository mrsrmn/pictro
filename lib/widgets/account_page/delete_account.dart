import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:get/get.dart';

import 'package:pictro/utils/auth.dart';
import 'package:pictro/widgets/custom_button.dart';
import 'package:pictro/pages/main_pages/start_page.dart';
import 'package:pictro/utils/constants.dart';
import 'package:pictro/widgets/custom_text_field.dart';
import 'package:pictro/utils/auth_values.dart';
import 'package:pictro/utils/database.dart';

class DeleteAccount extends StatelessWidget {
  DeleteAccount({super.key});

  final TextEditingController controller = TextEditingController();

  final CountdownController countdownController = CountdownController();

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
              content: const Text(
                "This process is irreversible! All of your data will be deleted.",
                style: TextStyle(fontFamily: geologicaMedium),
              ),
              actions: [
                CustomButton(
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  text: "No",
                ),
                CustomButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    Authentication.instance.sendSMS(FirebaseAuth.instance.currentUser!.phoneNumber!);

                    smsCodeDialog(context);
                  },
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  text: "Yes",
                )
              ],
            );
          }
        );
      },
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      text: "Delete Account",
    );
  }

  Widget countdown(BuildContext context) {
    return Countdown(
      seconds: 120,
      controller: countdownController,
      build: (_, double time) {
        countdownController.start();

        return Text(
          time.toInt().toString(),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: geologicaMedium
          ),
        );
      },
      onFinished: () {
        Get.snackbar(
          "Timed out!",
          "Ypu have been timed out to enter the SMS code. Please try again later.",
          colorText: Colors.white,
          icon: const Icon(Icons.timer_outlined, color: Colors.red),
          shouldIconPulse: false,
          duration: const Duration(seconds: 5)
        );
        Navigator.pop(context);
      },
    );
  }

  void smsCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Widget child =  const Text("Ok", style: TextStyle(
          fontSize: 19,
          color: Colors.red,
        ));
        bool enabled = true;

        return AlertDialog(
          backgroundColor: Colors.red,
          contentTextStyle: const TextStyle(color: Colors.white),
          title: const Text("SMS Code", style: TextStyle(
            color: Colors.white,
            fontFamily: geologicaBold,
            fontSize: 18
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "We sent you a SMS code for validation.",
                style: TextStyle(fontFamily: geologicaMedium),
              ),
              CustomTextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                maxLength: 6,
                counter: countdown(context)
              ),
            ],
          ),
          actions: [
            CustomButton(
              onPressed: () {
                HapticFeedback.lightImpact();

                countdownController.pause();
                Navigator.pop(context);
              },
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              text: "Cancel",
            ),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return CustomButton(
                  onPressed: () async {
                    if (enabled) {
                      setState(() {
                        child = const CupertinoActivityIndicator();
                        enabled = false;
                      });

                      AuthValues verified = await Authentication.instance.reAuthenticate(controller.text);

                      if (verified == AuthValues.success) {
                        if (context.mounted) {
                          Navigator.pop(context);

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Container(
                                color: Colors.black.withOpacity(.5),
                                child: const Center(child: CircularProgressIndicator())
                              );
                            },
                          );

                          Navigator.pop(context);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const StartPage()
                            ),
                            (route) => false
                          );
                        }

                        await Database().deleteUserData();
                      } else {
                        String errorText;

                        if (verified == AuthValues.invalidSmsCode) {
                          errorText = "Please enter a valid SMS code.";
                        } else {
                          errorText = "There was an error while verifying your SMS code. Please try again later.";
                        }

                        Get.snackbar(
                          "Error!",
                          errorText,
                          colorText: Colors.white,
                          icon: const Icon(Icons.warning_amber, color: Colors.red),
                        );

                        setState(() {
                          child = const Text("Ok", style: TextStyle(
                            fontSize: 19,
                            color: Colors.red,
                          ));
                          enabled = true;
                        });
                      }
                    }
                  },
                  backgroundColor: enabled ? Colors.white : Colors.grey,
                  foregroundColor: Colors.red,
                  child: child,
                );
              },
            ),
          ],
        );
      }
    );
  }
}