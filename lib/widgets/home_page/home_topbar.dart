import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:scribble/pages/main_pages/home_page/account_page.dart';
import 'package:scribble/widgets/scribble_name.dart';

import 'package:firebase_auth/firebase_auth.dart';

class HomeTopBar extends StatefulWidget {
  const HomeTopBar({super.key});

  @override
  State<HomeTopBar> createState() => _HomeTopBarState();
}

class _HomeTopBarState extends State<HomeTopBar> {
  User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AccountPage()
                )
              ).then((_) async {
                await user.reload();
                user = FirebaseAuth.instance.currentUser!;
                setState(() {});
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(99)
              ),
              child: buildPfp(),
            ),
          ),
          const SizedBox(width: 10),
          Text(user.displayName!, style: const TextStyle(
            fontSize: 20
          )),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Theme(
                data: ThemeData(dialogBackgroundColor: Colors.black),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    showAboutDialog(
                      context: context,
                      applicationLegalese: "© 2023 Emir Sürmen",
                      applicationVersion: "1.0.0"
                    );
                  },
                  child: ScribbleName(fontSize: 25)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPfp() {
    if (user.photoURL == null) {
      return const Padding(
        padding: EdgeInsets.all(5),
        child: Icon(CupertinoIcons.person_fill, color: Colors.white),
      );
    }

    return SizedBox(
      height: 36,
      width: 36,
      child: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(.9),
        foregroundImage: NetworkImage(user.photoURL!),
        radius: 17
      ),
    );
  }
}