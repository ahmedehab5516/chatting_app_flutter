import 'package:chatting_app_v2/services/firestore%20services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/auth services/auth_service.dart';

class RegisterController extends GetxController {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phonenumber = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController birthDate = TextEditingController();
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final GlobalKey<FormState> regirsterKey = GlobalKey<FormState>();

  bool obsecureText = true;
  void passwrodVisiability() {
    obsecureText = !obsecureText;
    update();
  }

  bool acceptTerms = false;
  void termsAndConditions() {
    acceptTerms = !acceptTerms;
    update();
  }

  String genderChoice = "Male";
  void genderChoiceUpdate(String? newChoice) {
    genderChoice = newChoice!;
    update();
  }

  Future<void> pickBirthDate(BuildContext context) async {
    DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (datePicked != null) {
      birthDate.text = DateFormat("dd/MM/yyyy").format(datePicked).toString();
    }
  }

  Future<void> signUp() async {

    if (regirsterKey.currentState!.validate() && acceptTerms) {
      try {
        UserCredential currentUser =
            await _authService.createUserWithEmailAndPasswordToFirebase(
                email.text, password.text);
        DocumentSnapshot<Map<String, dynamic>> userPersonalDate =
            await _firestoreService.firestoreInstance
                .collection("personal_info")
                .doc(currentUser.user!.uid)
                .get();
       
        await _firestoreService.addUserToFirestore(
          currentUser.user!.uid,
          username.text,
          email.text,
          phonenumber.text,
          int.parse(birthDate.text.substring(0, 2)),
          int.parse(birthDate.text.substring(3, 5)),
          int.parse(birthDate.text.substring(6, 10)),
          userPersonalDate['imageUrl'],
          genderChoice,
        );
        update();
        await _firestoreService.updateDisplayName(
            currentUser.user!.uid, username.text);
        Get.back();
      } on FirebaseException catch (e) {
        Get.snackbar("", '',
            titleText: const Text(
              "ooooops!!!",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            messageText: Text(
              e.message.toString(),
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ));
      }
    } else {
      Get.snackbar(
        '',
        '',
        titleText: const Text(
          "Fields error",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        messageText: Text(
          acceptTerms
              ? "try check the fields you just entered."
              : "try check the fields you just entered.\nevery user must agree to the terms and conditions to create their account",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      );
    }
  }
}
