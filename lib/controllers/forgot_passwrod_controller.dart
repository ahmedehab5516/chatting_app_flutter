import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController recoveryEmail = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future sendRestPasswordEmailFromFirebase() async {
    try {
      await _auth.sendPasswordResetEmail(email: recoveryEmail.text.trim());
    } on FirebaseAuthException catch (e) {
      
      Get.dialog(
        AlertDialog(
          content: Text(
            e.message.toString(),
          ),
        ),
      );
    }
  }
}
