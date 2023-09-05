import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pictro/pages/main_pages/home_page/home_page.dart';
import 'package:pictro/utils/database.dart';
import 'package:pictro/widgets//custom_button.dart';

class FriendsModal extends StatefulWidget {
  final DrawingController drawingController;

  const FriendsModal({super.key, required this.drawingController});

  @override
  State<FriendsModal> createState() => _FriendsModalState();
}

class _FriendsModalState extends State<FriendsModal> {
  bool? isChecked = false;
  late Future<List<Map<String, String>>> availableContacts;
  List<String> selectedNumbers = [];

  @override
  void initState() {
    availableContacts = getAvailableContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30)
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cancel_outlined, color: Colors.red)
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: FutureBuilder(
                  future: availableContacts,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }

                    List<Map<String, String>> contacts = snapshot.data;

                    if (contacts.isEmpty) {
                      return const Center(
                        child: Text("You don't have any contacts that use Pictro!"),
                      );
                    }

                    String currentNumber = FirebaseAuth.instance.currentUser!.phoneNumber!;
                    String phoneValue;

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: contacts.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        phoneValue = contacts[index]["phoneNumber"]!
                            .replaceAll(" ", "")
                            .replaceAll("(", "")
                            .replaceAll(")", "");

                        if (phoneValue == currentNumber) {
                          return const SizedBox();
                        }

                        return StatefulBuilder(
                          builder: (context, StateSetter setState) {
                            return CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                contacts[index]["displayName"]!,
                                style: const TextStyle(
                                  color: Colors.white
                                ),
                              ),
                              value: isChecked,
                              onChanged: (bool? value) {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  isChecked = value;
                                  phoneValue = contacts[index]["phoneNumber"]!
                                      .replaceAll(" ", "")
                                      .replaceAll("(", "")
                                      .replaceAll(")", "");
                                });
                                if (isChecked!) {
                                  selectedNumbers.add(phoneValue);
                                } else {
                                  selectedNumbers.remove(phoneValue);
                                }
                              },
                            );
                          }
                        );
                      },
                    );
                  }
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onPressed: () async {
                      HapticFeedback.lightImpact();

                      if (selectedNumbers.isNotEmpty) {
                        if (context.mounted) {
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: false,
                            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                              return Container(
                                color: Colors.black.withOpacity(.5),
                                child: const Center(child: CircularProgressIndicator())
                              );
                            },
                          );
                        }

                        try {
                          await Database().putData(
                            (await widget.drawingController.getImageData())!.buffer.asUint8List(),
                            selectedNumbers
                          );
                        } catch (e) {
                          if (mounted) {
                            Navigator.pop(context);
                            debugPrint(e.toString());
                          }
                          Get.snackbar(
                            "Error!",
                            "We couldn't send your Pictr!",
                            colorText: Colors.white,
                            icon: const Icon(Icons.warning_amber, color: Colors.red),
                            shouldIconPulse: false
                          );
                          return;
                        }

                        if (mounted) {
                          Navigator.pop(context);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                            (route) => false
                          );

                          Get.snackbar(
                            "Success!",
                            "You successfully sent your Pictr to ${selectedNumbers.length} friends!",
                            colorText: Colors.white,
                            icon: const Icon(Icons.verified_outlined, color: Colors.green)
                          );
                        }
                      } else {
                        Get.snackbar(
                          "Error!",
                          "Please select at least 1 person to send your Pictr to!",
                          colorText: Colors.white,
                          icon: const Icon(Icons.warning_amber, color: Colors.red),
                          shouldIconPulse: false
                        );
                      }
                    },
                    text: "Send",
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white.withOpacity(.9),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<List<Map<String, String>>> getAvailableContacts() async {
    QuerySnapshot<Map<String, dynamic>> dbUsers = await FirebaseFirestore.instance.collection("users").get();
    List<Map<String, String>> availableContacts = [];

    for (var user in dbUsers.docs) {
      var contact = await ContactsService.getContactsForPhone(user.id);

      if (contact.isNotEmpty) {
        availableContacts.add({
          "displayName": contact[0].displayName!,
          "phoneNumber": user.id
        });
      }
    }

    return availableContacts;
  }
}
