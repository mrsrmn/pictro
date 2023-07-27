import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:scribble/pages/main_pages/home_page/account_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.to(() => const AccountPage()),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(99)
              ),
              padding: const EdgeInsets.all(5),
              child: const Icon(CupertinoIcons.person_fill, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Text(FirebaseAuth.instance.currentUser!.displayName!, style: const TextStyle(
            fontSize: 20
          ))
        ],
      ),
    );
  }
}