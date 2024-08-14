import 'package:flutter/material.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/services/user_service.dart';

class FormAccountPage extends StatefulWidget {
  final String? userId;
  const FormAccountPage({super.key, this.userId});

  @override
  State<FormAccountPage> createState() => _FormAccountPageState();
}

class _FormAccountPageState extends State<FormAccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late Future<UserDetail?> _userDetail;
  @override
  void initState() {
    _userDetail = UserService().getUserDetail(widget.userId!);
    super.initState();
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
                  image: const AssetImage('assets/images/register.jpeg')),
              Padding(padding: padding16),
              FutureBuilder(
                future: _userDetail,
                builder: (BuildContext context,
                    AsyncSnapshot<UserDetail?> snapshot) {
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
                    User user = snapshot.data!.data;
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
