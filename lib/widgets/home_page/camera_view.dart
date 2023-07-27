import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

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

  double getHeight(BuildContext context) {
    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height / 1.7;

    if (deviceHeight < 300) {
      return 300;
    } else {
      return deviceHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: getHeight(context),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: child
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
      if (!mounted) {
        return;
      }
      setState(() {
        if (!controller.value.isInitialized) {
          child = const Center(
            child: CupertinoActivityIndicator(color: Colors.white),
          );
        }
        child = Stack(
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
              child: Stack(
                alignment: Alignment.center,
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
                        // TODO take picture
                      },
                      icon: const Icon(CupertinoIcons.camera_circle_fill, color: Colors.white, size: 60)
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
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

    controller.lockCaptureOrientation();
  }

  void _toggleCameraLens() {
    final lensDirection = controller.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = _availableCameras.firstWhere((description) =>
      description
          .lensDirection == CameraLensDirection.back);
    }
    else {
      newDescription = _availableCameras.firstWhere((description) =>
      description
          .lensDirection == CameraLensDirection.front);
    }

    _initCamera(newDescription);
  }
}