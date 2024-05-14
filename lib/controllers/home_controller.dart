import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth services/auth_service.dart';
import '../services/firestore services/firestore_service.dart';

class HomeController extends GetxController {
  final AuthService authService = AuthService();
  final FirestoreService firestore = FirestoreService();

  User? user;
  String? chatRoomID;
  Map<String, dynamic>? routeArgumentData;
  Map<String, dynamic>? lastMessage;

  void signOut() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("profile_image");
    preferences.remove("about");
    await authService.signOutFromFirebase();
  }

  Future<void> gettingCurrentUser() async {
    if (authService.auth.currentUser != null) {
      user = authService.auth.currentUser;
 
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> userFirestoreStream() {
    return firestore.firestoreInstance.collection("users").snapshots();
  }

 

  Future<void> getChatRoomId(String uid) async {
    List<String> ids = [uid, user!.uid];
    ids.sort();
    chatRoomID = ids.join("_");
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      String uid)  {
    getChatRoomId(uid);
    try {
      return  firestore.firestoreInstance
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .snapshots();
    } catch (e) {
      throw Exception(
          "Something went wrong while getting the last message: $e");
    }
  }



  @override
  void onInit() {
    super.onInit();
    gettingCurrentUser();
  }
}
