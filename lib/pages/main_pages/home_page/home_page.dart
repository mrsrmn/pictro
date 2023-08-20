import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:home_widget/home_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:pictro/widgets/home_page/home_topbar.dart';
import 'package:pictro/widgets/home_page/received_pictrs/received_pictr_view.dart';
import 'package:pictro/widgets/home_page/camera_view.dart';
import 'package:pictro/widgets/home_page/widget_usage_alert.dart';
import 'package:pictro/utils/utils.dart';

const String appGroupId = "group.pictrowidget";

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  DocumentReference doc = FirebaseFirestore.instance.collection("users").doc(
    FirebaseAuth.instance.currentUser!.phoneNumber!
  ).collection("private").doc("data");

  List? receivedPictrs = ((await doc.get()).data()! as Map<String, dynamic>)["receivedPictrs"];

  if (receivedPictrs == null) {
    Utils.updateWidget(null, null);
  } else if (receivedPictrs.isNotEmpty) {
    Utils.updateWidget(
      receivedPictrs.last["url"],
      receivedPictrs.last["sentBy"]
    );
  } else {
    Utils.updateWidget(null, null);
  }
}

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

  requestPermissions() async {
    if (await Permission.camera.request().isGranted) {
      requestContactPermission();
      return;
    }
    requestContactPermission();
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
    FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
  }

  @override
  void initState() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    super.initState();

    HomeWidget.setAppGroupId(appGroupId);
    requestPermissions();
    setupCloudMessaging();
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
            WidgetUsageAlert(),
            SizedBox(height: 10),
            CameraView(),
            SizedBox(height: 20),
            Expanded(child: ReceivedPictrsView())
          ],
        ),
      ),
    );
  }
}