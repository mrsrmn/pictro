import 'package:flutter/material.dart';
import 'package:scribble/utils/auth.dart';
import 'package:scribble/widgets/custom_button.dart';

import 'package:scribble/widgets/custom_text_field.dart';

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
                maxLength: 6,
              ),
              const SizedBox(height: 10),
              CustomButton(
                onPressed: () {
                  Authentication.instance.verifyOTP(controller.text);
                },
                backgroundColor: Colors.purple.shade500,
                text: "Continue",
              )
            ]
          ),
        )
      )
    );
  }
}