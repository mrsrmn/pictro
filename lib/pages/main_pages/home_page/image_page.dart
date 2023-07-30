import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:scribble/utils/database.dart';
import 'package:scribble/widgets/custom_button.dart';
import 'package:scribble/widgets/image_page/paint_content_selector.dart';
import 'package:scribble/widgets/image_page/color_selector.dart';

class ImagePage extends StatelessWidget {
  final Uint8List image;
  final bool mirrored;

  ImagePage({super.key, required this.image, required this.mirrored});

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
                  background: Transform.flip(
                    flipX: mirrored,
                    child: Image.memory(
                      image,
                      fit: BoxFit.fill,
                      width: boxSize,
                      height: boxSize,
                    ),
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
                    PaintContentSelector(drawingController: drawingController),
                    ColorSelector(drawingController: drawingController)
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
