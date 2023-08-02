import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:intl/intl.dart';

class ReceivedScribbDetails extends StatelessWidget {
  final String sentBy;
  final String url;
  final Timestamp sentAt;

  const ReceivedScribbDetails({
    super.key,
    required this.sentBy,
    required this.url,
    required this.sentAt
  });

  @override
  Widget build(BuildContext context) {
    var dt = DateTime.fromMillisecondsSinceEpoch(sentAt.millisecondsSinceEpoch);

    return Material(
      color: Colors.black.withOpacity(.85),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.cancel_outlined, color: Colors.white, size: 30),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                        url,
                        fit: BoxFit.fill,
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
                  const SizedBox(height: 15),
                  FutureBuilder(
                    future: getSenderName(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CupertinoActivityIndicator());
                      }

                      return Text(snapshot.data!, style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ));
                    }
                  ),
                  Text(DateFormat('dd/MM/yyyy, HH:mm').format(dt))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> getSenderName() async {
    try {
      String? contactName = (await ContactsService.getContactsForPhone(sentBy))[0].displayName;
      if (contactName == null) {
        throw Exception("Couldn't reach contact name!");
      } else {
        return contactName;
      }

    } catch (e) {
      debugPrint(e.toString());

      try {
        return (await FirebaseFirestore.instance.collection("users").doc(sentBy).get()).data()!["displayName"];
      } catch (e) {
        debugPrint(e.toString());

        return sentBy;
      }
    }
  }
}
