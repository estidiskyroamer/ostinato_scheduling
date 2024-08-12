import 'package:flutter/material.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/navigation.dart';
import 'package:ostinato/pages/register.dart';
import 'package:ostinato/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  void doLogin() async {
    setState(() {
      _isLoading = true;
    });

    bool loginSuccess = await AuthService()
        .login(emailController.text, passwordController.text);

    setState(() {
      _isLoading = false;
    });
    if (loginSuccess) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => NavigationPage()));
    } else {
      print("LOgin failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: padding16,
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
              ),
              InputField(
                textEditingController: passwordController,
                hintText: "Password",
                isPassword: true,
              ),
              Padding(padding: padding8),
              SolidButton(
                  action: () {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      doLogin();
                    } else {
                      null;
                    }
                  },
                  text: "Login"),
              Text(
                "- or -",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .merge(const TextStyle(fontStyle: FontStyle.italic)),
              ),
              OutlineButton(
                  action: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterPage()));
                  },
                  text: "Register")
            ],
          ),
        ),
      ),
    );
  }
}
