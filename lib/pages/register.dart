import 'package:flutter/material.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/input_field.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/services/user_service.dart';

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
  TextEditingController companyController = TextEditingController();

  bool isLoading = false;

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
              InputField(
                textEditingController: companyController,
                hintText: "Company code (optional)",
                inputType: TextInputType.text,
              ),
              Padding(padding: padding8),
              isLoading
                  ? Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                        child: Config().loadingIndicator,
                      ),
                    )
                  : SolidButton(
                      action: () {
                        if (nameController.text != "" &&
                            emailController.text != "" &&
                            phoneController.text != "" &&
                            passwordController.text != "") {
                          createTeacher(context);
                        }
                      },
                      text: "Register"),
            ],
          ),
        ),
      ),
    );
  }

  void createTeacher(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    User user = User(
      name: nameController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
      password: passwordController.text,
      isActive: 1,
    );
    /* Teacher teacher =
        Teacher(user: user, isActive: 1, companyCode: companyController.text); */

    UserService().createUser(user).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value != null && context.mounted) {
        Navigator.pop(context);
      }
    });
  }
}
