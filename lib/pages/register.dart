import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ostinato/common/components/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/navigation.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: padding16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                  width: MediaQuery.sizeOf(context).width / 2,
                  image: const AssetImage('assets/images/register.jpeg')),
              Padding(padding: padding16),
              Text(
                "Register as Teacher",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Padding(padding: padding16),
              InputField(
                textEditingController: nameController,
                hintText: "Full name",
                inputType: TextInputType.name,
              ),
              InputField(
                textEditingController: emailController,
                hintText: "Email",
                inputType: TextInputType.emailAddress,
              ),
              InputField(
                textEditingController: phoneController,
                hintText: "Phone number",
                inputType: TextInputType.phone,
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
                  text: "Register"),
            ],
          ),
        ),
      ),
    );
  }
}
