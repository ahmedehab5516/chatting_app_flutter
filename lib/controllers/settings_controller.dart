import 'package:chatting_app_v2/services/auth%20services/auth_service.dart';
import 'package:chatting_app_v2/services/firestore%20services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  // Services
  final FirestoreService firestoreService = FirestoreService();
  final AuthService authService = AuthService();

  // User info
  User? user;
  String? profileImage;
  String? about;

  @override
  void onInit() {
    super.onInit();
    gettingCurrentUser();
    getPersonalInfo();
  }

  // Fetch current user from AuthService
  void gettingCurrentUser() {
    user = authService.auth.currentUser;
  }

  // Fetch personal info from Firestore
  Future<void> getPersonalInfo() async {
    if (user == null) return;

    try {
      DocumentSnapshot<Map<String, dynamic>> userPersonalData =
          await firestoreService.firestoreInstance
              .collection("personal_info")
              .doc(user!.uid)
              .get();

      about = userPersonalData['about'];
      profileImage = userPersonalData['imageUrl'];
      update();
    } catch (e) {
      throw Exception('Error getting personal information: $e');
      // Handle error here, such as showing a snackbar or toast
    }
  }

  // Fetch personal info from Firestore (returns a Future)
  Future<DocumentSnapshot<Map<String, dynamic>>> personalInfoFuture() async {
    if (user == null) {
      throw Exception('User not logged in');
    }

    return await firestoreService.firestoreInstance
        .collection("personal_info")
        .doc(user!.uid)
        .get();
  }
}
