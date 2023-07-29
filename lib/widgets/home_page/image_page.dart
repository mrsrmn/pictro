import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image/image.dart' as img;
import 'package:scribble/widgets/custom_button.dart';

class ImagePage extends StatelessWidget {
  final img.Image image;

  const ImagePage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
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
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.memory(img.encodePng(image), fit: BoxFit.fill)
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
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
