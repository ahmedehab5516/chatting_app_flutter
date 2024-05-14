import 'package:chatting_app_v2/controllers/register_controller.dart';
import 'package:chatting_app_v2/shared_componants/my_button.dart';
import 'package:chatting_app_v2/shared_componants/text_field.dart';
import 'package:chatting_app_v2/shared_functions/validation_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final RegisterController _registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 30.0),
                  // create account
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text(
                          "Create account",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "we're trying to make the world a small village, through our chatting application",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ),

                  // username textfield
                  const SizedBox(height: 30.0),
                  Form(
                    key: _registerController.regirsterKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: BuildTextField(
                            controller: _registerController.username,
                            validatorFunction: (value) =>
                                validationFunction("username", value!),
                            isPasswordField: false,
                            obsecureText: false,
                            hintText: "User Name",
                          ),
                        ),
                        const SizedBox(height: 10.0),

                        //email textfield
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: BuildTextField(
                            controller: _registerController.email,
                            validatorFunction: (value) =>
                                validationFunction("email", value!),
                            isPasswordField: false,
                            obsecureText: false,
                            hintText: "Email",
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        //phone number textfield

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: BuildTextField(
                            controller: _registerController.phonenumber,
                            validatorFunction: (value) =>
                                validationFunction("phone", value!),
                            isPasswordField: false,
                            obsecureText: false,
                            hintText: "Phone Number",
                          ),
                        ),
                        const SizedBox(height: 10.0),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: GetBuilder<RegisterController>(
                                  builder: (controller) =>
                                      DropdownButton<String>(
                                    dropdownColor: Colors.white,
                                    alignment: Alignment.center,
                                    value: controller.genderChoice,
                                    items: const [
                                      DropdownMenuItem<String>(
                                          value: "Male", child: Text("Male")),
                                      DropdownMenuItem<String>(
                                          value: "Female",
                                          child: Text("Female")),
                                    ],
                                    onChanged: (String? newChoice) => controller
                                        .genderChoiceUpdate(newChoice),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              Expanded(
                                child: BuildTextField(
                                  controller: _registerController.birthDate,
                                  validatorFunction: (value) => null,
                                  suffixIcon: Icons.date_range_outlined,
                                  readOnly: true,
                                  suffixFunction: () => _registerController
                                      .pickBirthDate(context),
                                  isPasswordField: true,
                                  obsecureText: false,
                                  hintText: "DD/MM/YYYY",
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        // password textfield

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: GetBuilder<RegisterController>(
                            builder: (controller) => BuildTextField(
                              controller: controller.password,
                              validatorFunction: (value) =>
                                  validationFunction("password", value!),
                              suffixIcon: controller.obsecureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              suffixFunction: () =>
                                  controller.passwrodVisiability(),
                              isPasswordField: true,
                              obsecureText: controller.obsecureText,
                              hintText: "Password",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // i accept the terms and conditions an privacy policy
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        GetBuilder<RegisterController>(
                          builder: (controller) => Checkbox(
                              value: controller.acceptTerms,
                              onChanged: (value) =>
                                  controller.termsAndConditions()),
                        ),
                        const Text("I accept the terms and privacy policy")
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // create account button
                  MyButton(
                      onTap: () async => await _registerController.signUp(),
                      buttonLabel: "Create Account"),
                ],
              ),

              // already have an account ? log in

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Sign in")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
