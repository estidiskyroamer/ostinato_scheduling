import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/menu/form_account.dart';
import 'package:ostinato/pages/menu/settings.dart';
import 'package:ostinato/pages/menu/summary.dart';
import 'package:ostinato/pages/menu/tutorials/tutorials.dart';
import 'package:ostinato/services/auth_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  PackageInfo info = PackageInfo(appName: '', packageName: '', version: '', buildNumber: '');
  @override
  void initState() {
    super.initState();
    setRandomImage();
    getPackageInfo();
  }

  int setRandomImage() {
    final random = Random();
    int index = random.nextInt(6);
    return index;
  }

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      info = packageInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Menu",
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
            Expanded(
              flex: 12,
              child: Container(
                padding: padding4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledTextButton(
                        action: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SummaryPage()));
                        },
                        text: "Summary"),
                    /* StyledTextButton(
                      action: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const TutorialsPage()));
                      },
                      text: "Tutorials"), */
                    StyledTextButton(
                        action: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsPage()));
                        },
                        text: "Settings"),
                    StyledTextButton(
                        action: () async {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FormAccountPage()));
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
            ),
            Expanded(
              flex: 1,
              child: Text(
                "${info.appName} ${info.version}",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
