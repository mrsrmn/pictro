import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/helpers.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:image/image.dart' as img;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:scribble/utils/database.dart';
import 'package:scribble/widgets/custom_button.dart';

class ImagePage extends StatelessWidget {
  final img.Image image;

  ImagePage({super.key, required this.image});

  final DrawingController drawingController = DrawingController();

  @override
  Widget build(BuildContext context) {
    double boxSize = MediaQuery.of(context).size.width - 30;

    return Scaffold(
      appBar: AppBar(
        title: Text("Upload", style: TextStyle(color: Colors.white.withOpacity(.9))),
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(.9),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black87,
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              height: boxSize,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: DrawingBoard(
                  controller: drawingController,
                  showDefaultActions: false,
                  showDefaultTools: false,
                  boardScaleEnabled: false,
                  boardPanEnabled: false,
                  maxScale: 1,
                  minScale: 1,
                  background: Image.memory(
                    img.encodePng(image),
                    fit: BoxFit.fill,
                    width: boxSize,
                    height: boxSize,
                  )
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatefulBuilder(
                      builder: (context, StateSetter setState) {
                        PaintContent paintContent = SimpleLine();

                        return Wrap(
                          children: [
                            IconButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  paintContent = SimpleLine();
                                  drawingController.setPaintContent = SimpleLine();
                                });
                              },
                              icon: Icon(CupertinoIcons.pencil, color: paintContent == SimpleLine() ? Colors.purple : Colors.white.withOpacity(.9))
                            ),
                            IconButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  paintContent = SmoothLine();
                                  drawingController.setPaintContent = SmoothLine();
                                });
                              },
                              icon: Icon(Icons.brush_rounded, color: paintContent == SmoothLine() ? Colors.purple : Colors.white.withOpacity(.9))
                            ),
                            IconButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  paintContent = StraightLine();
                                  drawingController.setPaintContent = StraightLine();
                                });
                              },
                              icon: Icon(Icons.show_chart, color: paintContent == StraightLine() ? Colors.purple : Colors.white.withOpacity(.9))
                            ),
                            IconButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  paintContent = Rectangle();
                                  drawingController.setPaintContent = Rectangle();
                                });
                              },
                              icon: Icon(Icons.rectangle_outlined, color: paintContent == Rectangle() ? Colors.purple : Colors.white.withOpacity(.9))
                            ),
                            IconButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  paintContent = Eraser();
                                  drawingController.setPaintContent = Eraser();
                                });
                              },
                              icon: Icon(CupertinoIcons.bandage, color: paintContent == Eraser() ? Colors.purple : Colors.white.withOpacity(.9))
                            ),
                          ],
                        );
                      }
                    ),
                    Wrap(
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
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: () async {
                        HapticFeedback.lightImpact();
                        Database().putData(
                          (await drawingController.getImageData())!.buffer.asUint8List(),
                          FirebaseAuth.instance.currentUser!.uid // implement selecting a user
                        );
                      },
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purple,
                      text: "Continue",
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
