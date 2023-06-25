import 'package:flutter/material.dart';

import 'package:scribble/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final Color backgroundColor;
  final String? text;
  final Widget? child;

  const CustomButton({
    super.key,
    this.text,
    this.child,
    required this.onPressed,
    required this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )
        )
      ),
      child: buildChild()
    );
  }

  Widget buildChild() {
    if (child != null) {
      return child!;
    } else {
      return Text(
        text!,
        style: const TextStyle(
          fontFamily: geologicaMedium,
          fontSize: 19,
          color: Colors.white,
        )
      );
    }
  }
}
