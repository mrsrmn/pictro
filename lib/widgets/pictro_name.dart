import 'package:flutter/material.dart';

import 'package:pictro/utils/constants.dart';

class PictroName extends StatelessWidget {
  final LinearGradient gradient = LinearGradient(colors: [
    Colors.purple.shade400,
    Colors.purple.shade700,
  ]);

  final double? fontSize;

  PictroName({super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        "Pictro",
        style: TextStyle(
          fontFamily: geologicaMedium,
          fontSize: fontSize ?? 40,
        )
      ),
    );
  }
}
