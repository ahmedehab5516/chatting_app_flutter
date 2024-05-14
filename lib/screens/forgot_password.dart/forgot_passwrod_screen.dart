import 'package:chatting_app_v2/controllers/forgot_passwrod_controller.dart';
import 'package:chatting_app_v2/shared_componants/my_button.dart';
import 'package:chatting_app_v2/shared_componants/text_field.dart';
import 'package:chatting_app_v2/shared_functions/validation_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final ForgotPasswordController _forgotPasswordController =
      Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    "Recovering Your Password",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Enter an email address. so you can change your password",
                style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: BuildTextField(
                controller: _forgotPasswordController.recoveryEmail,
                validatorFunction: (value) =>
                    validationFunction("email", value!),
                isPasswordField: false,
                obsecureText: false,
                hintText: "Email",
              ),
            ),
            const SizedBox(height: 30.0),
            MyButton(
                onTap: () => _forgotPasswordController
                    .sendRestPasswordEmailFromFirebase(),
                buttonLabel: "Send Email"),
          ],
        ),
      ),
    );
  }
}
