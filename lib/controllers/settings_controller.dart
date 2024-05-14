import 'package:chatting_app_v2/services/auth%20services/auth_service.dart';
import 'package:chatting_app_v2/services/firestore%20services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final FirestoreService firestoreService = FirestoreService();
  final AuthService authService = AuthService();
  String? profileImage;
  String? about;

  User? user;

  void gettingCurrentUser() {
    user = authService.auth.currentUser;
  }

  Future<void> getPersonalInfo() async {
    try {
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userPersonalData =
            await firestoreService.firestoreInstance
                .collection("personal_info")
                .doc(user!.uid)
                .get();
        about = userPersonalData['about'];
        profileImage = userPersonalData['imageUrl'];
        update();
      }
    } catch (e) {
      throw Exception('Error getting personal information: $e');
      // Handle error here, such as showing a snackbar or toast
    }
  }

  Future<void> getProfileImg() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      profileImage = prefs.getString("profile_image");
      update();
    } catch (e) {
      throw Exception('Error getting profile image: $e');
      // Handle error here, such as showing a snackbar or toast
    }
  }

  @override
  void onInit() {
    super.onInit();
    gettingCurrentUser();
    getProfileImg();
    getPersonalInfo();
  }
}
