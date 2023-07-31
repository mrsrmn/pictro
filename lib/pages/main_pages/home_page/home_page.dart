import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workmanager/workmanager.dart';
import 'package:home_widget/home_widget.dart';

import 'package:scribble/widgets/home_page/home_topbar.dart';
import 'package:scribble/widgets/home_page/camera_view.dart';

const String appGroupId = "group.scribblewidget";
const String iOSWidgetName = "Scribble";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await startListener();
    return Future.value(true);
  });
}

Future<void> startListener() async {
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId(appGroupId);

    startListener();

    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    ).then((_) {
      Workmanager().registerOneOffTask(
        "emirs.scribble.bgtask",
        "emirs.scribble.bgtask",
        initialDelay: Duration.zero,
        existingWorkPolicy: ExistingWorkPolicy.append,
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
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