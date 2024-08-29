import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/user.dart';

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

  late Future<String?> _user;
  @override
  void initState() {
    _user = Config().storage.read(key: 'user');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              FutureBuilder(
                future: _user,
                builder:
                    (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                        child: Config().loadingIndicator,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.hasData) {
                    var jsonData = jsonDecode(snapshot.data!);
                    User user = User.fromJson(jsonData);
                    nameController.text = user.name;
                    emailController.text = user.email;
                    phoneController.text = user.phoneNumber;
                  }

                  return buildForm(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Column(
      children: [
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
    );
  }
}
