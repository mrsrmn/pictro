import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:camera/camera.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:native_image_cropper/native_image_cropper.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

import 'package:pictro/pages/main_pages/home_page/image_page.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  late CameraController controller;
  late List<CameraDescription> _availableCameras;

  final Permission _permission = Permission.camera;
  bool _checkingPermission = false;

  Widget child = const Center(
    child: CupertinoActivityIndicator(color: Colors.white),
  );
  FlashMode flashMode = FlashMode.off;
  bool showFocusCircle = false;
  double x = 0;
  double y = 0;

  void checkAvailableCameras() {
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
  }

  Future<void> _checkPermission(Permission permission) async {
    final status = await permission.request();

    if (status == PermissionStatus.granted) {
      checkAvailableCameras();
    } else if (status == PermissionStatus.denied) {
      await permission.request();
      setState(() {
        child = const Center(
          child: Text("Please allow access to the camera!"),
        );
      });
    } else if (status == PermissionStatus.permanentlyDenied) {
      setState(() {
        child = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Please allow access to the camera!"),
              const SizedBox(height: 10),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purpleAccent),
                  foregroundColor: MaterialStateProperty.all(Colors.white)
                ),
                onPressed: () {
                  AppSettings.openAppSettings();
                },
                child: const Text("Go to Settings")
              )
            ],
          ),
        );
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_checkingPermission) {
      _checkingPermission = true;
      _checkPermission(_permission).then((_) => _checkingPermission = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermission(_permission);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
      imageFormatGroup: Platform.isIOS
          ? ImageFormatGroup.bgra8888
          : ImageFormatGroup.yuv420
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
          return;
        }
        child = cameraViewWidget(camera);
      });
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
    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        void onTapUp(TapUpDetails details) async {
          if (controller.value.isInitialized) {
            setState(() {
              showFocusCircle = true;
            });

            x = details.localPosition.dx;
            y = details.localPosition.dy;

            double fullWidth = MediaQuery.of(context).size.width - 20;

            double xp = x / fullWidth;
            double yp = y / fullWidth;

            Offset point = Offset(xp, yp);

            await controller.setFocusPoint(point);
            await controller.setExposurePoint(point);

            await Future.delayed(const Duration(seconds: 1, milliseconds: 600)).whenComplete(() {
              setState(() {
                showFocusCircle = false;
              });
            });
          }
        }

        Widget buildFocusCircle() {
          if (showFocusCircle) {
            return Positioned(
              top: y-20,
              left: x-20,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5)
                ),
              )).animate()
                .fadeIn(duration: const Duration(milliseconds: 100))
                .fadeOut(delay: const Duration(seconds: 1), duration: const Duration(milliseconds: 500));
          } else {
            return const SizedBox();
          }
        }

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
                onTapUp: (TapUpDetails details) {
                  onTapUp(details);
                },
                child: CameraPreview(controller)
              ),
            ),
            buildFocusCircle(),
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
                      onPressed: () async {
                        HapticFeedback.lightImpact();
                        controller.takePicture().then((XFile selectedImage) async {
                          int imageWidth = 300;

                          if (mounted) {
                            imageWidth = (MediaQuery.of(context).size.width - 30).toInt() * 7;
                          }

                           Uint8List croppedImage = await img.NativeImageCropper.cropRect(
                             bytes: await selectedImage.readAsBytes(),
                             x: 0,
                             y: 0,
                             width: imageWidth,
                             height: imageWidth,
                           );

                          await controller.dispose();
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ImagePage(
                                image: croppedImage,
                                mirrored: camera.lensDirection == CameraLensDirection.front,
                              ))
                            ).then((_) {
                              _initCamera(camera);
                            });
                          }

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
    );
  }
}