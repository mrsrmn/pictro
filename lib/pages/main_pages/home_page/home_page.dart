import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:pictro/widgets/home_page/home_topbar.dart';
import 'package:pictro/widgets/home_page/received_pictrs/received_pictr_view.dart';
import 'package:pictro/widgets/home_page/camera_view.dart';
import 'package:pictro/widgets/home_page/widget_usage_alert.dart';
import 'package:pictro/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  requestContactPermission() async {
    if (await Permission.contacts.request().isGranted) {
      return;
    }
  }

  void setupCloudMessaging() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.instance.subscribeToTopic(
      FirebaseAuth.instance.currentUser!.phoneNumber!.replaceAll("+", "")
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Utils.updateWidgetForImage();
    });
  }

  @override
  void initState() {
    super.initState();

    Utils.updateWidgetForImage();

    requestContactPermission();
    setupCloudMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black87
        ),
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: const Column(
          children: [
            HomeTopBar(),
            SizedBox(height: 15),
            WidgetUsageAlert(),
            SizedBox(height: 10),
            CameraView(),
            SizedBox(height: 10),
            Divider(height: 1, thickness: 1),
            Expanded(child: ReceivedPictrsView())
          ],
        ),
      ),
    );
  }
}