import 'package:flutter/material.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/account/form_account.dart';
import 'package:ostinato/pages/account/summary.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                image: const AssetImage('assets/images/account.jpeg')),
            Padding(padding: padding16),
            StyledTextButton(
                action: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SummaryPage()));
                },
                text: "Summary"),
            StyledTextButton(action: () {}, text: "Tutorials"),
            StyledTextButton(
                action: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FormAccountPage()));
                },
                text: "Edit Account"),
            StyledTextButton(
                action: () {
                  Navigator.pop(context);
                },
                text: "Logout"),
          ],
        ),
      ),
    );
  }
}
