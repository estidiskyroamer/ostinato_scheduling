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
              inputType: TextInputType.visiblePassword,
            ),
            Padding(padding: padding8),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: LinearBorder(),
                  padding: padding8),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => NavigationPage()));
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width / 3,
                    maxWidth: MediaQuery.of(context).size.width),
                child: Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ),
            Text(
              "- or -",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .merge(const TextStyle(fontStyle: FontStyle.italic)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, color: Colors.black)),
                  padding: padding8),
              onPressed: () {},
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width / 3,
                    maxWidth: MediaQuery.of(context).size.width),
                child: Text(
                  "Sign Up",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .merge(const TextStyle(color: Colors.black)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
