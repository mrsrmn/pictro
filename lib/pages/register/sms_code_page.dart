import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pictro/utils/auth.dart';
import 'package:pictro/utils/auth_values.dart';
import 'package:pictro/widgets/custom_button.dart';
import 'package:pictro/widgets/custom_text_field.dart';
import 'package:pictro/pages/main_pages/start_page.dart';
import 'package:pictro/pages/register/username_page.dart';
import 'package:pictro/pages/main_pages/home_page/home_page.dart';

import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SmsCodePage extends StatefulWidget {
  const SmsCodePage({super.key});

  @override
  State<SmsCodePage> createState() => _SmsCodePageState();
}

class _SmsCodePageState extends State<SmsCodePage> {
  final TextEditingController controller = TextEditingController();
  final CountdownController countdownController = CountdownController();

  Widget buttonChild = const Text(
    "Continue",
    style: TextStyle(
      fontSize: 19,
      color: Colors.white,
    )
  );
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: const EdgeInsets.all(15),
          color: Colors.black87,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("SMS Code", style: TextStyle(color: Colors.white, fontSize: 23), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: "Code",
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                  ],
                  counter: Countdown(
                    seconds: 120,
                    controller: countdownController,
                    build: (_, double time) {
                      countdownController.start();

                      return Text(
                        time.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.white
                        ),
                      );
                    },
                    onFinished: () {
                      Get.snackbar(
                        "Timed out!",
                        "You have been timed out.",
                        colorText: Colors.white,
                        icon: const Icon(Icons.timer_outlined, color: Colors.red),
                        shouldIconPulse: false,
                        duration: const Duration(seconds: 5)
                      );
                      Get.to(() => const StartPage());
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: () async {
                    if (enabled) {
                      HapticFeedback.lightImpact();

                      countdownController.pause();

                      setState(() {
                        buttonChild = const Center(child: CupertinoActivityIndicator());
                        enabled = false;
                      });

                      AuthValues verified = await Authentication.instance.verifyOTP(controller.text);
                      if (verified == AuthValues.success) {
                        if (FirebaseAuth.instance.currentUser!.displayName == null) {
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => UsernamePage()
                                ),
                                (route) => false
                            );
                          }
                        } else {
                          Get.snackbar(
                            "Success!",
                            "You have been signed in.",
                            colorText: Colors.white,
                            icon: const Icon(Icons.verified_outlined, color: Colors.green),
                            shouldIconPulse: false
                          );
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const HomePage()
                              ),
                              (route) => false
                            );
                          }
                        }
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
                          setState(() {
                            buttonChild = const Text(
                              "Continue",
                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                              )
                            );
                            enabled = true;
                          });
                        });
                      }
                    }
                  },
                  backgroundColor: Colors.purple.shade500,
                  child: buttonChild,
                )
              ]
            ),
          ),
        )
      )
    );
  }
}