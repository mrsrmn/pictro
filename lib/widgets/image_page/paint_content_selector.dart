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
  late Widget child;

  @override
  void initState() {
    child = buildChild();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }

  Widget buildChild() {
    return Wrap(
      children: [
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              paintContent = SimpleLine();
              widget.drawingController.setPaintContent = SimpleLine();
              child = buildChild();
            });
          },
          icon: Icon(CupertinoIcons.pencil, color: paintContent.runtimeType == SimpleLine ? Colors.purple : Colors.white.withOpacity(.9))
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              paintContent = SmoothLine();
              widget.drawingController.setPaintContent = SmoothLine();
              child = buildChild();
            });
          },
          icon: Icon(Icons.brush_rounded, color: paintContent.runtimeType == SmoothLine ? Colors.purple : Colors.white.withOpacity(.9))
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              paintContent = StraightLine();
              widget.drawingController.setPaintContent = StraightLine();
              child = buildChild();
            });
          },
          icon: Icon(Icons.show_chart, color: paintContent.runtimeType == StraightLine ? Colors.purple : Colors.white.withOpacity(.9))
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              paintContent = Rectangle();
              widget.drawingController.setPaintContent = Rectangle();
              child = buildChild();
            });
          },
          icon: Icon(Icons.rectangle_outlined, color: paintContent.runtimeType == Rectangle ? Colors.purple : Colors.white.withOpacity(.9))
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              paintContent = Eraser();
              widget.drawingController.setPaintContent = Eraser();
              child = buildChild();
            });
          },
          icon: Icon(CupertinoIcons.bandage, color: paintContent.runtimeType == Eraser ? Colors.purple : Colors.white.withOpacity(.9))
        ),
      ],
    );
  }
}
