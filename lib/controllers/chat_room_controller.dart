import 'dart:async';
import 'dart:io';

import 'package:chatting_app_v2/services/auth%20services/auth_service.dart';
import 'package:chatting_app_v2/services/firestore%20services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../services/firebase_storage/online_storage.dart';

class ChatRoomController extends GetxController {
  final FirestoreService firestoreService = FirestoreService();
  final AuthService authService = AuthService();
  final TextEditingController messageController = TextEditingController();
  final Map<String, dynamic> routeArgument = Get.arguments;
  String? profileImage;
  String? wallpaperImage;

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

  Future<void> getProfileImg() async {
    try {
      Stream<DocumentSnapshot<Map<String, dynamic>>> chatInfo = firestoreService
          .firestoreInstance
          .collection("users")
          .doc(routeArgument['uid'])
          .snapshots();

      chatInfo.listen(
        (snapshot) {
          if (snapshot.exists && snapshot.data() != null) {
            profileImage = snapshot.data()!['imageUrl'];
            update();
          } else {
            profileImage =
                "https://i.pinimg.com/236x/80/ef/85/80ef85c30a3fe9e338fc668ab10d136b.jpg"; // Default image URL
            update();
          }
        },
        onError: (error) {
          throw Exception("Something went wrong getting each user image: $error"
              .capitalize);
        },
      );
    } catch (e) {
      throw Exception(
          "Something went wrong getting each user image: $e".capitalize);
    }
  }

  Future<void> chooseAndUploadWallpaper() async {
    try {
      final pickedImg =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImg != null) {
        OnlineStorage onlineStorage = OnlineStorage();
        wallpaperImage = await onlineStorage.uploadFileForUser(
            "root",
            "chatWallpaper/${routeArgument['uid']}",
            user!.uid,
            File(pickedImg.path));
      }

      update();
    } catch (e) {
      throw ("Error selecting image: $e");
    }
  }

  Future<void> fetchProfileImage() async {
    try {
      wallpaperImage =
          "https://i.pinimg.com/474x/43/db/2b/43db2b3dbb56d0b1c1b5aeca80544ef0.jpg";

      OnlineStorage onlineStorage = OnlineStorage();

      List<Reference>? items = await onlineStorage.getUserUploadedFiles(
          "root", "chatWallpaper/${routeArgument['uid']}", user!.uid);
      if (items!.isNotEmpty) {
        wallpaperImage = await items.last.getDownloadURL();
      }
      update();
    } catch (e) {
      throw ("Error getting image from the cloud: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    gettingCurrentUser();
    getProfileImg();
    fetchProfileImage();
    // Timer(const Duration(milliseconds: 500), () => update());
  }
}
