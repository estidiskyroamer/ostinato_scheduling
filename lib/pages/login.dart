import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/components/input_field.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/pages/navigation.dart';
import 'package:ostinato/pages/register.dart';
import 'package:ostinato/services/auth_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  late User? _user;

  PackageInfo info =
      PackageInfo(appName: '', packageName: '', version: '', buildNumber: '');

  void doLogin() async {
    setState(() {
      _isLoading = true;
    });

    AuthService()
        .login(emailController.text, passwordController.text)
        .then((value) async {
      if (value) {
        _user = await AuthService().getMe();
        setState(() {
          _isLoading = false;
          Config().storage.write(
                key: 'teacher',
                value: jsonEncode(
                  _user!.toJson(),
                ),
              );
        });
        if (mounted) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NavigationPage()));
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        toastNotification("Cannot authenticate");
      }
    });
  }

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      info = packageInfo;
    });
  }

  @override
  void initState() {
    super.initState();
    getPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        padding: padding16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      width: MediaQuery.sizeOf(context).width / 2,
                      image: const AssetImage('assets/images/login.jpeg')),
                  Padding(padding: padding16),
                  Text(
                    "Ostinato",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "Music Lesson Scheduling",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Padding(padding: padding16),
                  InputField(
                    textEditingController: emailController,
                    hintText: "Email",
                    inputType: TextInputType.emailAddress,
                    isReadOnly: _isLoading,
                  ),
                  InputField(
                    textEditingController: passwordController,
                    hintText: "Password",
                    isPassword: true,
                    isReadOnly: _isLoading,
                  ),
                  Padding(padding: padding8),
                  _isLoading
                      ? Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 6,
                            child: Config().loadingIndicator,
                          ),
                        )
                      : Column(
                          children: [
                            SolidButton(
                                action: () {
                                  if (emailController.text.isNotEmpty &&
                                      passwordController.text.isNotEmpty) {
                                    doLogin();
                                  } else {
                                    toastNotification(
                                        "Email and password cannot be empty");
                                  }
                                },
                                text: "Login"),
                            Text(
                              "- or -",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .merge(const TextStyle(
                                      fontStyle: FontStyle.italic)),
                            ),
                            OutlineButton(
                                action: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage()));
                                },
                                text: "Register")
                          ],
                        ),
                ],
              ),
            ),
            Text(
              "${info.appName} ${info.version}",
              style: Theme.of(context).textTheme.labelSmall,
            )
          ],
        ),
      ),
    );
  }
}
