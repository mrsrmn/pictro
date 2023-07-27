import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController controller;
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

      controller = CameraController(
        value[0],
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
          child = CameraPreview(controller);
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
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double getHeight(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height / 1.7;

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
      child: child
    );
  }
}