import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';

class PaintContentSelector extends StatefulWidget {
  final DrawingController drawingController;
  
  const PaintContentSelector({super.key, required this.drawingController});

  @override
  State<PaintContentSelector> createState() => _PaintContentSelectorState();
}

class _PaintContentSelectorState extends State<PaintContentSelector> {
  PaintContent paintContent = SimpleLine();
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              paintContent = SimpleLine();
              widget.drawingController.setPaintContent = SimpleLine();
            });
          },
          icon: buildIcon(paintContent)
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              paintContent = SmoothLine();
              widget.drawingController.setPaintContent = SmoothLine();
            });
          },
          icon: Icon(Icons.brush_rounded, color: paintContent == SmoothLine() ? Colors.purple : Colors.white.withOpacity(.9))
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              paintContent = StraightLine();
              widget.drawingController.setPaintContent = StraightLine();
            });
          },
          icon: Icon(Icons.show_chart, color: paintContent == StraightLine() ? Colors.purple : Colors.white.withOpacity(.9))
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              paintContent = Rectangle();
              widget.drawingController.setPaintContent = Rectangle();
            });
          },
          icon: Icon(Icons.rectangle_outlined, color: paintContent == Rectangle() ? Colors.purple : Colors.white.withOpacity(.9))
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              paintContent = Eraser();
              widget.drawingController.setPaintContent = Eraser();
            });
          },
          icon: Icon(CupertinoIcons.bandage, color: paintContent == Eraser() ? Colors.purple : Colors.white.withOpacity(.9))
        ),
      ],
    );
  }

  Icon buildIcon(PaintContent paintContent) {
    return Icon(CupertinoIcons.pencil, color: paintContent == paintContent ? Colors.purple : Colors.white.withOpacity(.9));
  }
}
