import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scribble/widgets/home_page/camera_view.dart';

import 'package:scribble/widgets/home_page/home_topbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    requestContactPermission();
  }

  requestContactPermission() async {
    if (await Permission.contacts.request().isGranted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black87
        ),
        padding: const EdgeInsets.all(15),
        child: const Column(
          children: [
            HomeTopBar(),
            SizedBox(height: 15),
            CameraView(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}