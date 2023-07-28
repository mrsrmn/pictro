import 'package:flutter/material.dart';

import 'package:scribble/widgets/custom_button.dart';
import 'package:scribble/utils/constants.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {},
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      child: const Text(
        "Delete Account",
        style: TextStyle(
          fontFamily: geologicaMedium,
          fontSize: 19,
          color: Colors.white,
        )
      )
    );
  }
}
