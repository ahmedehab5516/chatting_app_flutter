// ignore_for_file: must_be_immutable

import 'package:chatting_app_v2/controllers/signin_controller.dart';
import 'package:chatting_app_v2/routes.dart';
import 'package:chatting_app_v2/shared_componants/square_tile.dart';
import 'package:chatting_app_v2/shared_componants/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../shared_componants/my_button.dart';
import '../shared_functions/validation_function.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final SigninController _signinController = Get.put(SigninController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 50),
                //logo
                Icon(
                  Icons.lock,
                  size: 100,
                  color: Colors.teal[700],
                ),
                const SizedBox(height: 50),

                //welcome back, you've been missed
                Text(
                  "welcome back, you've been missed",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),

                const SizedBox(height: 25),

                //username textfield

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: BuildTextField(
                    validatorFunction: (value) =>
                        validationFunction("email", value!),
                    isPasswordField: false,
                    controller: _signinController.email,
                    obsecureText: false,
                    hintText: 'Email or User Name',
                  ),
                ),
                const SizedBox(height: 10.0),

                //password textfield
                GetBuilder<SigninController>(
                  builder: (controller) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: BuildTextField(
                      suffixFunction: () => controller.passwrodVisiability(),
                      suffixIcon: controller.obsecureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      validatorFunction: (value) =>
                          validationFunction("password", value!),
                      isPasswordField: true,
                      controller: controller.password,
                      obsecureText: controller.obsecureText,
                      hintText: 'password',
                    ),
                  ),
                ),

                const SizedBox(height: 10.0),

                //forgot password
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.forgotpassword),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),

                // sign in button
                MyButton(
                  onTap: () async => _signinController.signIn(),
                  buttonLabel: 'Sign In',
                ),

                const SizedBox(height: 30.0),
                //or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey[400],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("or continue with"),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),

                // google + apple + facebook sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      imagePath: "assets/images/facebook-circular-logo.png",
                      onTap: () {},
                    ),
                    const SizedBox(width: 10.0),
                    SquareTile(
                        imagePath: "assets/images/google.png",
                        onTap: () =>
                            _signinController.signInWithGoogle(context)),
                  ],
                ),
                const SizedBox(height: 50.0),
                // not a  member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("not a member?"),
                    TextButton(
                        onPressed: () => Get.toNamed(Routes.register),
                        child: const Text("Register now")),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
