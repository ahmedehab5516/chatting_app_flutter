import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../services/auth services/auth_service.dart';
import '../services/firestore services/firestore_service.dart';

class ArchiveController extends GetxController {
  final AuthService authService = AuthService();
  final FirestoreService firestore = FirestoreService();

  Stream<QuerySnapshot<Map<String, dynamic>>> userFirestoreStream() {
    return firestore.firestoreInstance.collection("users").snapshots();
  }

  User? user;
  // Fetch current user and handle potential null value
  Future<void> fetchCurrentUser() async {
    try {
      user = authService.auth.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }
    } catch (e) {
      throw ("Error fetching current user: $e");
    }
  }
}
