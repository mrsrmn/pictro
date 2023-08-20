import 'package:flutter/material.dart';

import 'package:pictro/widgets/account_page/change_username.dart';
import 'package:pictro/widgets/account_page/change_pfp.dart';
import 'package:pictro/widgets/account_page/sign_out.dart';
import 'package:pictro/widgets/account_page/delete_account.dart';

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
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    const Expanded(child: SafeArea(child: SignOut())),
                    const SizedBox(width: 5),
                    Expanded(child: SafeArea(child: DeleteAccount()))
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
