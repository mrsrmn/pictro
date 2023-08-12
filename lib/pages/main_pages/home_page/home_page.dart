import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:home_widget/home_widget.dart';

import 'package:scribble/widgets/home_page/home_topbar.dart';
import 'package:scribble/widgets/home_page/received_scribbs/received_scribbs_view.dart';
import 'package:scribble/widgets/home_page/camera_view.dart';
import 'package:scribble/utils/utils.dart';

const String appGroupId = "group.scribblewidget";

Future<void> startListener() async {
  DocumentReference doc = FirebaseFirestore.instance.collection("users").doc(
    FirebaseAuth.instance.currentUser!.phoneNumber!
  ).collection("private").doc("data");
  doc.snapshots().listen((DocumentSnapshot documentSnapshot) {
    List? receivedScribbs = (documentSnapshot.data()! as Map<String, dynamic>)["receivedScribbs"];

    if (receivedScribbs == null) {
      Utils.updateWidget(null, null);
    } else if (receivedScribbs.isNotEmpty) {
      Utils.updateWidget(
        receivedScribbs.last["url"],
        receivedScribbs.last["sentBy"]
      );
    } else {
      Utils.updateWidget(null, null);
    }
  });
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

  @override
  void initState() {
    super.initState();

    HomeWidget.setAppGroupId(appGroupId);
    requestPermissions();
    startListener();
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
            SizedBox(height: 20),
            Expanded(child: ReceivedScribbsView())
          ],
        ),
      ),
    );
  }
}