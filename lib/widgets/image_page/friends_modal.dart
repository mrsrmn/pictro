import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
                        child: Text("You don't have any contacts!"),
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
                      await Database().putData(
                        (await widget.drawingController.getImageData())!.buffer.asUint8List(),
                        FirebaseAuth.instance.currentUser!.phoneNumber!
                      );
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
    ListResult dbUsers = await FirebaseStorage.instance.ref().child("users/").list();
    List<Contact> availableContacts = [];

    for (var user in dbUsers.prefixes) {
      var contact = (await ContactsService.getContactsForPhone(user.name));

      if (contact.isNotEmpty) {
        availableContacts.add(contact[0]);
      }
    }

    return availableContacts;
  }
}
