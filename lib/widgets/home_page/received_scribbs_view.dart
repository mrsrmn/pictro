import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReceivedScribbsView extends StatefulWidget {
  const ReceivedScribbsView({super.key});

  @override
  State<ReceivedScribbsView> createState() => _ReceivedScribbsViewState();
}

class _ReceivedScribbsViewState extends State<ReceivedScribbsView> {
  late Future<List?> future;

  Future<List?> getReceivedScribbs() async {
    try {
      DocumentReference doc = FirebaseFirestore.instance.collection("users").doc(
          FirebaseAuth.instance.currentUser!.phoneNumber!
      );

      List receivedScribbs = ((await doc.get()).data()! as Map<String, dynamic>)["receivedScribbs"];

      return receivedScribbs;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  void initState() {
    future = getReceivedScribbs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = (MediaQuery.of(context).size.width / 3) - 20;

    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CupertinoActivityIndicator());
        }
        List receivedScribbs = snapshot.data!;

        if (receivedScribbs.isEmpty) {
          return Center(
            child: Text("You don't have any received scribbs!", style: TextStyle(
              color: Colors.white.withOpacity(.9)
            )),
          );
        }

        List<Widget> scribbsView = [];

        for (var scribb in receivedScribbs) {
          scribbsView.add(SizedBox(
            width: size,
            height: size,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                )
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  scribb["url"]!,
                  fit: BoxFit.fill,
                  width: size,
                  height: size,
                ),
              ),
            ),
          ));
        }

        return SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.start,
              runSpacing: 10,
              spacing: 10,
              children: scribbsView,
            ),
          ),
        );
      },
    );
  }
}
