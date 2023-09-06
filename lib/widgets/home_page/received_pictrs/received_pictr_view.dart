import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:pictro/widgets/home_page/received_pictrs/received_pictr_details.dart';

class ReceivedPictrsView extends StatefulWidget {
  const ReceivedPictrsView({super.key});

  @override
  State<ReceivedPictrsView> createState() => _ReceivedPictrsViewState();
}

class _ReceivedPictrsViewState extends State<ReceivedPictrsView> {
  late Future<List?> future;

  Future<List?> getReceivedPictrs() async {
    try {
      DocumentReference doc = FirebaseFirestore.instance.collection("users").doc(
        FirebaseAuth.instance.currentUser!.phoneNumber!
      ).collection("private").doc("data");

      List receivedPictrs = ((await doc.get()).data()! as Map<String, dynamic>)["receivedPictrs"];

      return receivedPictrs;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  void initState() {
    future = getReceivedPictrs();
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
        List? receivedPictrs = snapshot.data;

        if (receivedPictrs == null) {
          return Center(
            child: Text("There was an error while fetching received Pictrs!", style: TextStyle(
              color: Colors.white.withOpacity(.9),
            ), textAlign: TextAlign.center),
          );
        }

        if (receivedPictrs.isEmpty) {
          return Center(
            child: Text("You don't have any received Pictrs!", style: TextStyle(
              color: Colors.white.withOpacity(.9)
            )),
          );
        }

        List<Widget> pictrsView = [];

        for (var pictr in receivedPictrs.reversed) {
          pictrsView.add(SizedBox(
            width: size,
            height: size,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();

                showGeneralDialog(
                  context: context,
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return ReceivedPictrDetails(
                      sentBy: pictr["sentBy"]!,
                      url: pictr["url"]!,
                      sentAt: pictr["sentAt"],
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
                  child: CachedNetworkImage(
                    imageUrl: pictr["url"]!,
                    fit: BoxFit.fill,
                    width: size,
                    height: size,
                    placeholder: (context, url) => const Center(
                      child: CupertinoActivityIndicator(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error_outline, color: Colors.red),
                  ),
                ),
              ),
            ),
          ));
        }

        return SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: SafeArea(
              left: false,
              right: false,
              top: false,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    runSpacing: 10,
                    spacing: 10,
                    children: pictrsView,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
