import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/auth services/auth_service.dart';
import '../services/firestore services/firestore_service.dart';

class HomeController extends GetxController {
  final AuthService authService = AuthService();
  final FirestoreService firestore = FirestoreService();

  String? selectedValue = "0";

  User? user;
  String? chatRoomID;

  String? selectedChatRoomId;
  bool toggel = false;
  bool toggelArchive = false;

  void toggleArchivFun(DragStartDetails details) {
    if (details.localPosition.dy != 0) {
      toggelArchive = !toggelArchive;
    }
    print(details.localPosition);

    update();
  }

  void selectChatRoom(String chatRoomId) {
    if (selectedChatRoomId == chatRoomId) {
      selectedChatRoomId = null;
      toggel = false;
    } else {
      selectedChatRoomId = chatRoomId;
      toggel = true;
    }
    update();
  }

  void deleteChatRoom() {
    try {
      if (selectedChatRoomId != user!.uid) {
        firestore.firestoreInstance
            .collection("users")
            .doc(selectedChatRoomId)
            .update({'state': false});
      } else {
        Get.snackbar("you idiot?", "you cant delete yourself.");
      }
    } catch (e) {
      throw ("error while tryingto delete chatroom $e");
    }
  }

  CameraController? _controller;
  List<CameraDescription>? _cameras;

  Future<void> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      // Permission is granted
      initializeCamera();
    } else if (status.isDenied) {
      Get.defaultDialog(
        title: "Permission Denied",
        content: const Text(
            "Camera permission is denied. Please grant the permission from settings."),
        confirm: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("OK"),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      Get.defaultDialog(
        title: "Permission Denied Permantently",
        content: const Text(
            "Camera permission is denied. Please grant the permission from settings."),
        confirm: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("OK"),
        ),
      );
      openAppSettings();
    }
  }

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUser();
 
    Timer(const Duration(milliseconds: 100), () => update());
  }

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

  // Sign out the user from Firebase
  Future<void> signOut() async {
    try {
      await authService.signOutFromFirebase();
    } catch (e) {
      throw ("Error signing out: $e");
    }
  }

  // Stream of users from Firestore
  Stream<QuerySnapshot<Map<String, dynamic>>> userFirestoreStream() {
    return firestore.firestoreInstance.collection("users").snapshots();
  }

  // Generate chat room ID
  Future<void> generateChatRoomId(String uid) async {
    if (user == null) {
      throw Exception("Current user is not available");
    }
    List<String> ids = [uid, user!.uid];
    ids.sort();
    chatRoomID = ids.join("_");
  }

  // Stream of last message from Firestore
  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(String uid) {
    try {
      generateChatRoomId(uid);
      if (chatRoomID == null) {
        throw Exception("Chat room ID is not generated");
      }
      return firestore.firestoreInstance
          .collection("chat_rooms")
          .doc(chatRoomID!)
          .collection("messages")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .snapshots();
    } catch (e) {
      throw Exception("Error getting the last message: $e");
    }
  }

  RxMap<String, String> userMuteDurations = <String, String>{}.obs;

  void setMuteDuration(String userId, String? duration) {
    if (duration != null) {
      userMuteDurations[userId] = duration;
    } else {
      userMuteDurations.remove(userId);
    }
    update();
  }

  String? getMuteDuration(String userId) {
    return userMuteDurations[userId];
  }

  bool isUserMuted(String userId) {
    if (userMuteDurations.containsValue(0)) {
      return false;
    }

    return userMuteDurations.containsKey(userId);
  }

  void showMuteDialog(BuildContext context) {
    String userId = selectedChatRoomId!;
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          backgroundColor: Colors.teal[800],
          icon: const Icon(FontAwesomeIcons.userNinja),
          elevation: 30.0,
          title: const Text(
            "How long do you need to forget this person? Just say the word and I will flush them in the toilet.",
            style: TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
          content: GetBuilder<HomeController>(
            builder: (controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile<String>(
                    title: const Text("Cancel Mute"),
                    value: "0",
                    groupValue: controller.getMuteDuration(userId),
                    onChanged: (value) {
                      controller.setMuteDuration(userId, value);
                      // controller.selectedValue = value;
                      // controller.update();
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("1 Day"),
                    value: "1",
                    groupValue: controller.getMuteDuration(userId),
                    onChanged: (value) {
                      controller.setMuteDuration(userId, value);
                      // controller.selectedValue = value;
                      // controller.update();
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("1 Week"),
                    value: "7",
                    groupValue: controller.getMuteDuration(userId),
                    onChanged: (value) {
                      controller.setMuteDuration(userId, value);
                      // controller.selectedValue = value;
                      // controller.update();
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("1 Month"),
                    value: "30",
                    groupValue: controller.getMuteDuration(userId),
                    onChanged: (value) {
                      controller.setMuteDuration(userId, value);
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
