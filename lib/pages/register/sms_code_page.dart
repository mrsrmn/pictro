import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scribble/pages/register/username_page.dart';

import 'package:scribble/utils/auth.dart';
import 'package:scribble/widgets/custom_button.dart';
import 'package:scribble/widgets/custom_text_field.dart';
import 'package:scribble/pages/home.dart';

import 'package:timer_count_down/timer_count_down.dart';
import 'package:get/get.dart';

class SmsCodePage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  SmsCodePage({super.key});

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
                    build: (_, double time) {
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
                      Get.to(() => const Home());
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: () async {
                    HapticFeedback.lightImpact();

                    bool verified = await Authentication.instance.verifyOTP(controller.text);
                    if (verified) {
                      Get.snackbar(
                        "Success!",
                        "You have been signed in.",
                        colorText: Colors.white,
                        icon: const Icon(Icons.verified_outlined, color: Colors.green),
                        shouldIconPulse: false
                      );
                      Get.to(() => UsernamePage());
                    } else {
                      Get.snackbar(
                        "We couldn't sign you in!",
                        "Please contact the developers.",
                        colorText: Colors.white,
                        icon: const Icon(Icons.warning_amber, color: Colors.red),
                      );
                    }
                  },
                  backgroundColor: Colors.purple.shade500,
                  text: "Continue",
                )
              ]
            ),
          ),
        )
      )
    );
  }
}