import 'package:flutter/material.dart';
import 'package:scribble/widgets/custom_button.dart';

import 'package:scribble/widgets/phone_field.dart';
import 'package:scribble/utils/region.dart';

class Register extends StatelessWidget {
  Register({super.key});
  final TextEditingController _controller = TextEditingController();
  final region = Region();

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
                const Text("Phone Number", style: TextStyle(color: Colors.white, fontSize: 23), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                PhoneField(controller: _controller),
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: () {},
                  text: "Register",
                  backgroundColor: Colors.purple.shade500
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
