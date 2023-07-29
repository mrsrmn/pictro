import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as image;
import 'package:get/get.dart';
import 'package:scribble/widgets/home_page/image_page.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController controller;
  late List<CameraDescription> _availableCameras;

  Widget child = const Center(
    child: CupertinoActivityIndicator(color: Colors.white),
  );
  FlashMode flashMode = FlashMode.off;

  @override
  void initState() {
    availableCameras().then((value) {
      if (value.isEmpty) {
        setState(() {
          child = const Center(
            child: Text("No cameras found!"),
          );
        });
        return;
      }

      _initCamera(value[0]);

      _availableCameras = value;
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: child
        ),
      )
    );
  }

  void _initCamera(CameraDescription camera) {
    controller = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.bgra8888
    );

    controller.initialize().then((_) {
      controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
      controller.setFlashMode(flashMode);

      if (!mounted) {
        return;
      }
      setState(() {
        if (!controller.value.isInitialized) {
          child = const Center(
            child: CupertinoActivityIndicator(color: Colors.white),
          );
        }
        child = cameraViewWidget(camera);
      });
    }).catchError((Object e) {
      debugPrint(e.toString());
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            setState(() {
              child = const Center(
                child: Text("Please allow access to the camera!"),
              );
            });
            break;
          default:
            setState(() {
              child = const Center(
                child: Text("There was an error while loading the camera!"),
              );
            });
            break;
        }
      }
    });
  }

  void _toggleCameraLens() {
    final lensDirection = controller.description.lensDirection;
    CameraDescription newDescription;

    if (lensDirection == CameraLensDirection.front) {
      newDescription = _availableCameras.firstWhere((description) =>
        description.lensDirection == CameraLensDirection.back
      );
    }
    else {
      newDescription = _availableCameras.firstWhere((description) =>
        description.lensDirection == CameraLensDirection.front
      );
    }

    _initCamera(newDescription);
  }

  Widget cameraViewWidget(CameraDescription camera) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          child: GestureDetector(
            onDoubleTap: () {
              HapticFeedback.lightImpact();
              _toggleCameraLens();
            },
            child: CameraPreview(controller)
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _toggleCameraLens();
                  },
                  icon: const Icon(CupertinoIcons.camera_rotate, color: Colors.white, size: 30)
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    controller.takePicture().then((XFile selectedImage) async {
                      image.Image decodedImage = image.decodeImage(await selectedImage.readAsBytes())!;
                      int imageWidth = 300;
                      if (mounted) {
                        imageWidth = (MediaQuery.of(context).size.width - 30).toInt() * 7;
                      }

                      image.Image croppedImage = image.copyCrop(
                        decodedImage,
                        x: -1000,
                        y: -1000,
                        width: imageWidth,
                        height: imageWidth
                      );

                      croppedImage = image.copyResizeCropSquare(croppedImage, size: imageWidth);

                      if (camera.lensDirection == CameraLensDirection.front) {
                        croppedImage = image.copyFlip(
                          croppedImage,
                          direction: image.FlipDirection.horizontal
                        );
                      }

                      Get.to(() => ImagePage(image: croppedImage));

                      await File(selectedImage.path).delete();
                    });
                  },
                  icon: const Icon(CupertinoIcons.camera_circle_fill, color: Colors.white, size: 60)
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      flashMode = flashMode == FlashMode.off ? FlashMode.always : FlashMode.off;
                      controller.setFlashMode(flashMode);
                      child = cameraViewWidget(camera);
                    });
                  },
                  icon: Icon(
                    flashMode == FlashMode.off ? Icons.flash_off : Icons.flash_on,
                    color: flashMode == FlashMode.off ? Colors.white : Colors.yellow,
                    size: 30
                  )
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}