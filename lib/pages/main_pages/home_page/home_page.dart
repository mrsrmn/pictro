import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scribble/widgets/home_page/camera_view.dart';

import 'package:scribble/widgets/home_page/home_topbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Contact>> contacts;

  @override
  void initState() {
    super.initState();
    requestContactPermission();
    contacts = getAvailableContacts();
  }

  requestContactPermission() async {
    if (await Permission.contacts.request().isGranted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black87
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const HomeTopBar(),
            const SizedBox(height: 15),
            const CameraView(),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: contacts,
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
                      return Text(contacts[index].displayName!);
                    },
                  );
                }
              ),
            )
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