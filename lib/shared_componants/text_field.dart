import 'package:flutter/material.dart';

class BuildTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obsecureText;
  final String hintText;
  final bool isPasswordField;
  final void Function()? suffixFunction;
  final String? Function(String?)? validatorFunction;
  final IconData? suffixIcon;
  final bool readOnly;
  const BuildTextField(
      {super.key,
      required this.controller,
      required this.validatorFunction,
      this.suffixFunction,
      this.suffixIcon,
      this.readOnly = false,
      required this.isPasswordField,
      required this.obsecureText,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      obscureText: obsecureText,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: suffixFunction,
          child: Visibility(
            visible: isPasswordField,
            child: obsecureText ? Icon(suffixIcon) : Icon(suffixIcon),
          ),
        ),
        fillColor: Colors.grey.shade100,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
        ),
      ),
      validator: validatorFunction,
    );
  }
}
