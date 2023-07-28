import 'package:flutter/material.dart';

import 'package:scribble/widgets/account_page/change_username.dart';
import 'package:scribble/widgets/account_page/change_pfp.dart';

import 'package:scribble/widgets/account_page/sign_out.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account", style: TextStyle(color: Colors.white.withOpacity(.9))),
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(.9),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black87
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ChangeUsername()
            ),
            SizedBox(
              width: double.infinity,
              child: ChangePfp()
            ),
            const Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: SafeArea(child: SignOut())
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}