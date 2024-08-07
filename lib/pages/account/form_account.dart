import 'package:flutter/material.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';

class FormAccountPage extends StatefulWidget {
  const FormAccountPage({super.key});

  @override
  State<FormAccountPage> createState() => _FormAccountPageState();
}

class _FormAccountPageState extends State<FormAccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                  image: const AssetImage('assets/images/register.jpeg')),
              Padding(padding: padding16),
              Text(
                "Edit Account",
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
                hintText: "New Password",
                isPassword: true,
              ),
              Padding(padding: padding8),
              SolidButton(
                  action: () {
                    Navigator.pop(context);
                  },
                  text: "Save"),
            ],
          ),
        ),
      ),
    );
  }
}
