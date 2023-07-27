import 'package:flutter/material.dart';

import 'package:scribble/utils/constants.dart';

class ScribbleName extends StatelessWidget {
  final LinearGradient gradient = LinearGradient(colors: [
    Colors.purple.shade400,
    Colors.purple.shade700,
  ]);

  final double? fontSize;

  ScribbleName({super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        "Scribble",
        style: TextStyle(
          fontFamily: geologicaMedium,
          fontSize: fontSize ?? 40,
        )
      ),
    );
  }
}
