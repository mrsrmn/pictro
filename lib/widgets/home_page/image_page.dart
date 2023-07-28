import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  final XFile image;

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
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.file(File(image.path))
          ],
        ),
      ),
    );
  }
}
