import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scribble/widgets/home_page/camera_view.dart';

import 'package:scribble/widgets/home_page/home_topbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String appGroupId = "group.scribblewidget";
  final String iOSWidgetName = "Scribble";

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId(appGroupId);

    requestContactPermission();
    startListening();
  }

  Future<void> requestContactPermission() async {
    if (await Permission.contacts.request().isGranted) {
      return;
    }
  }

  Future<void> startListening() async {
    DocumentReference doc = FirebaseFirestore.instance.collection("users").doc(
      FirebaseAuth.instance.currentUser!.phoneNumber!
    );
    doc.snapshots().listen((DocumentSnapshot documentSnapshot) {
      List receivedScribbs = (documentSnapshot.data()! as Map<String, dynamic>)["receivedScribbs"];

      if (receivedScribbs.isNotEmpty) {
        HomeWidget.saveWidgetData("scribb_url", receivedScribbs.last["url"]);
        HomeWidget.saveWidgetData("sent_by", receivedScribbs.last["sentBy"]);
        HomeWidget.updateWidget(iOSName: iOSWidgetName);
      }
    });
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