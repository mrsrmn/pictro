import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/helpers.dart';

class ColorSelector extends StatelessWidget {
  final DrawingController drawingController;

  const ColorSelector({super.key, required this.drawingController});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SizedBox(
          height: 48,
          width: 150,
          child: ExValueBuilder<DrawConfig>(
            valueListenable: drawingController.drawConfig,
            shouldRebuild: (DrawConfig p, DrawConfig n) =>
            p.strokeWidth != n.strokeWidth,
            builder: (_, DrawConfig dc, ___) {
              return SliderTheme(
                data: SliderThemeData(
                    overlayShape: SliderComponentShape.noOverlay
                ),
                child: Slider(
                  value: dc.strokeWidth,
                  max: 50,
                  min: 1,
                  onChanged: (double v) => drawingController.setStyle(strokeWidth: v),
                ),
              );
            },
          ),
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            drawingController.setStyle(color: Colors.red);
          },
          icon: const Icon(Icons.circle_rounded, color: Colors.red, size: 30)
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            drawingController.setStyle(color: Colors.blue);
          },
          icon: const Icon(Icons.circle_rounded, color: Colors.blue, size: 30)
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            drawingController.setStyle(color: Colors.green);
          },
          icon: const Icon(Icons.circle_rounded, color: Colors.green, size: 30)
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            drawingController.setStyle(color: Colors.yellow);
          },
          icon: const Icon(Icons.circle_rounded, color: Colors.yellow, size: 30)
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            drawingController.setStyle(color: Colors.purple);
          },
          icon: const Icon(Icons.circle_rounded, color: Colors.purple, size: 30)
        ),
        SizedBox(
          width: 48,
          height: 48,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Theme(
              data: ThemeData(textTheme: const TextTheme(
                headlineSmall: TextStyle(color: Colors.black)
              )),
              child: ColorPicBtn(controller: drawingController),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            drawingController.undo();
          },
          icon: Icon(Icons.undo, size: 30, color: Colors.white.withOpacity(.9))
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            drawingController.redo();
          },
          icon: Icon(Icons.redo, size: 30, color: Colors.white.withOpacity(.9))
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            drawingController.clear();
          },
          icon: Icon(CupertinoIcons.trash, color: Colors.white.withOpacity(.9))
        ),
      ],
    );
  }
}
