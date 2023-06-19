import 'package:flutter/material.dart';

import 'package:scribble/widgets/custom_text_field.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.black87,
          child: const SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("E-mail", style: TextStyle(color: Colors.white, fontSize: 25)),
                CustomTextField(
                  hintText: "steve@apple.com",
                  keyboardType: TextInputType.emailAddress,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
