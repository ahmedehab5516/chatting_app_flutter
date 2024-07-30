import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restart_app/restart_app.dart';

import '../services/auth services/auth_service.dart';

class SigninController extends GetxController {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final AuthService _authService = AuthService();

  bool obsecureText = true;
  void passwrodVisiability() {
    obsecureText = !obsecureText;
    update();
  }

  Future<void> signIn() async {
    try {
      await _authService.signInWithEmailAndPasswordToFirebase(
          email.text, password.text);
    } catch (e) {
      Get.snackbar('', '',
          titleText: const Text(
            "ooooops!!!",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          messageText: Text(
            e.toString(),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ));
    }
    Restart.restartApp();
  }

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential;
    } on Exception catch (e) {
      throw ('exception->$e');
    }
  }

  @override
  void onClose() {
    super.onClose();
    email.dispose();
    password.dispose();
  }
}
