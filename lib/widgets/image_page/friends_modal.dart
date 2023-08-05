import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:scribble/pages/main_pages/home_page/home_page.dart';
import 'package:scribble/utils/database.dart';
import 'package:scribble/widgets//custom_button.dart';

class FriendsModal extends StatefulWidget {
  final DrawingController drawingController;

  const FriendsModal({super.key, required this.drawingController});

  @override
  State<FriendsModal> createState() => _FriendsModalState();
}

class _FriendsModalState extends State<FriendsModal> {
  bool? isChecked = false;
  late Future<List<Contact>> availableContacts;
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

                    List<Contact> contacts = snapshot.data;

                    if (contacts.isEmpty) {
                      return const Center(
                        child: Text("You don't have any contacts that use Scribble!"),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: contacts.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return StatefulBuilder(
                          builder: (context, StateSetter setState) {
                            return CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(contacts[index].displayName!),
                              value: isChecked,
                              onChanged: (bool? value) {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  isChecked = value;
                                });
                                if (isChecked!) {
                                  selectedNumbers.add(contacts[index].phones![0].value!);
                                } else {
                                  selectedNumbers.remove(contacts[index].phones![0].value!);
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

                        for (var phone in selectedNumbers) {
                          try {
                            await Database().putData(
                              (await widget.drawingController.getImageData())!.buffer.asUint8List(),
                              phone
                                .replaceAll(" ", "")
                                .replaceAll("(", "")
                                .replaceAll(")", "")
                            );
                          } catch (e) {
                            Navigator.pop(context);
                            debugPrint(e.toString());
                            Get.snackbar(
                              "Error!",
                              "We couldn't send your Scribb's!",
                              colorText: Colors.white,
                              icon: const Icon(Icons.warning_amber, color: Colors.red),
                              shouldIconPulse: false
                            );
                            return;
                          }
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
                            "You successfully sent your Scribb to ${selectedNumbers.length} friends!",
                            colorText: Colors.white,
                            icon: const Icon(Icons.verified_outlined, color: Colors.green)
                          );
                        }
                      } else {
                        Navigator.pop(context);

                        Get.snackbar(
                          "Error!",
                          "Please select at least 1 person to send your Scribb to!",
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


  Future<List<Contact>> getAvailableContacts() async {
    QuerySnapshot<Map<String, dynamic>> dbUsers = await FirebaseFirestore.instance.collection("users").get();
    List<Contact> availableContacts = [];

    for (var user in dbUsers.docs) {
      var contact = (await ContactsService.getContactsForPhone(user.id));

      if (contact.isNotEmpty) {
        availableContacts.add(contact[0]);
      }
    }

    return availableContacts;
  }
}
