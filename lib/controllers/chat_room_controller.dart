import 'package:chatting_app_v2/services/auth%20services/auth_service.dart';
import 'package:chatting_app_v2/services/firestore%20services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomController extends GetxController {
  final FirestoreService firestoreService = FirestoreService();
  final AuthService authService = AuthService();
  final TextEditingController messageController = TextEditingController();
  final Map<String, dynamic> routeArgument = Get.arguments;

  User? user;
  void gettingCurrentUser() {
    if (authService.auth.currentUser != null) {
      user = authService.auth.currentUser;
    }
  }

  String getChatRoomID() {
    List<String> ids = [
      routeArgument['uid'],
      authService.auth.currentUser!.uid
    ];

    ids.sort();
    return ids.join("_");
  }

  Future<void> sendMessage() async {
    String chatRoomID = getChatRoomID();

    await firestoreService.addNewMessages(
      chatRoomID,
      messageController.text,
      authService.auth.currentUser!.email!,
      routeArgument['email'],
    );
    messageController.clear();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> gettingStream() {
    String chatRoomID = getChatRoomID();
    return firestoreService.firestoreInstance
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<void> clearChat() async {
    String chatRoomID = getChatRoomID();
    QuerySnapshot<Map<String, dynamic>> chatRoom = await firestoreService
        .firestoreInstance
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .get();

    for (var doc in chatRoom.docs) {
      await doc.reference.delete();
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getProfileImg() {
    try {
      return firestoreService.firestoreInstance
          .collection("users")
          .doc(routeArgument['uid'])
          .get();
    } catch (e) {
      throw Exception(
          "Something went wrong getting each user image".capitalize);
    }
  }

  @override
  void onInit() {
    super.onInit();
    gettingCurrentUser();
  }
}
