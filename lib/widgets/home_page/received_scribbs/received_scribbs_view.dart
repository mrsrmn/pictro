import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:scribble/widgets/home_page/received_scribbs/received_scribb_details.dart';

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
      ).collection("private").doc("data");

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
    double size = (MediaQuery.of(context).size.width / 3) - 17;

    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CupertinoActivityIndicator(color: Colors.white));
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

        for (var scribb in receivedScribbs.reversed) {
          scribbsView.add(SizedBox(
            width: size,
            height: size,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();

                showGeneralDialog(
                  context: context,
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return ReceivedScribbDetails(
                      sentBy: scribb["sentBy"]!,
                      url: scribb["url"]!,
                      sentAt: scribb["sentAt"],
                    );
                  },
                );
              },
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
                    loadingBuilder: (_, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return const Center(
                        child: CupertinoActivityIndicator(color: Colors.white),
                      );
                    },
                    errorBuilder: (_, __, ___) {
                      return const Icon(Icons.error_outline, color: Colors.red);
                    }
                  ),
                ),
              ),
            ),
          ));
        }

        return SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.start,
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
