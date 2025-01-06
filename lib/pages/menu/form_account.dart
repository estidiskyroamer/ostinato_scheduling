import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/input_field.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/services/user_service.dart';

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

  late String? user;
  late User userData;
  bool isLoading = false;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    isLoading = true;
    user = await Config().storage.read(key: 'user');
    if (mounted) {
      setState(() {
        isLoading = false;
        if (user != null) {
          userData = User.fromJson(jsonDecode(user!));
          nameController.text = userData.name;
          emailController.text = userData.email;
          phoneController.text = userData.phoneNumber;
        }
      });
    }
  }

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
              isLoading
                  ? Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                        child: Config().loadingIndicator,
                      ),
                    )
                  : buildForm(context),
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
              User update = User(
                  id: userData.id,
                  email: emailController.text,
                  name: nameController.text,
                  phoneNumber: phoneController.text,
                  password: passwordController.text,
                  roles: userData.roles,
                  companies: userData.companies,
                  isActive: userData.isActive);
              UserService().updateUser(update).then((value) {
                Config()
                    .storage
                    .write(
                      key: 'user',
                      value: jsonEncode(
                        value!.toJson(),
                      ),
                    )
                    .then(
                      (value) => Navigator.pop(context),
                    );
              });
            },
            text: "Save"),
      ],
    );
  }
}
