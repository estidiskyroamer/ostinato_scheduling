import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/account/form_account.dart';
import 'package:ostinato/pages/account/summary.dart';
import 'package:ostinato/services/auth_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    setRandomImage();
    super.initState();
  }

  int setRandomImage() {
    final random = Random();
    int index = random.nextInt(6);
    return index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Account",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        padding: padding16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
                width: MediaQuery.sizeOf(context).width / 2,
                image: AssetImage(
                    'assets/images/dashboard${setRandomImage()}.jpeg')),
            Padding(padding: padding16),
            StyledTextButton(
                action: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SummaryPage()));
                },
                text: "Summary"),
            StyledTextButton(action: () {}, text: "Tutorials"),
            StyledTextButton(
                action: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FormAccountPage()));
                },
                text: "Edit Account"),
            StyledTextButton(
                action: () {
                  AuthService().logout();
                },
                text: "Logout"),
          ],
        ),
      ),
    );
  }
}
