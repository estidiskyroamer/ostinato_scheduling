import 'package:flutter/material.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: padding16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            ),
            InputField(
              textEditingController: passwordController,
              hintText: "Password",
              isPassword: true,
            ),
            Padding(padding: padding8),
            SolidButton(
                action: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NavigationPage()));
                },
                text: "Login"),
            Text(
              "- or -",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .merge(const TextStyle(fontStyle: FontStyle.italic)),
            ),
            OutlineButton(action: () {}, text: "Sign Up")
          ],
        ),
      ),
    );
  }
}
