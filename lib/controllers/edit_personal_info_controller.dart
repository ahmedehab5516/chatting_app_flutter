import 'dart:async';
import 'dart:io';

import 'package:chatting_app_v2/controllers/settings_controller.dart';
import 'package:chatting_app_v2/services/auth%20services/auth_service.dart';
import 'package:chatting_app_v2/services/firebase_storage/online_storage.dart';
import 'package:chatting_app_v2/services/firestore%20services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


import '../shared_componants/pic_selecting_bottom_sheet.dart';

class EditPersonalInfoController extends GetxController {
  // Services
  final FirestoreService firestoreService = FirestoreService();
  final AuthService authService = AuthService();

  // Controllers
  late TextEditingController displayName;
  late TextEditingController about;

  // User info
  User? user;
  String? profileImage;
  int charactersCount = 0;

  @override
  void onInit() {
    super.onInit();
    displayName = TextEditingController();
    about = TextEditingController();
    gettingCurrentUser();
    fetchProfileImage();
  }

  @override
  void onClose() {
    displayName.dispose();
    about.dispose();
    super.onClose();
    updateSettingsController();
  }

  void gettingCurrentUser() {
    user = authService.auth.currentUser;
  }

  Future<void> fetchProfileImage() async {
    try {
      OnlineStorage onlineStorage = OnlineStorage();
      update();
      List<Reference>? items = await onlineStorage.getUserUploadedFiles(
          "root", "profileImages", user!.uid);
      if (items!.isNotEmpty) {
        profileImage = await items.last.getDownloadURL();
      }
    } catch (e) {
      throw ("Error getting image from the cloud: $e");
    }
    Timer(const Duration(milliseconds: 500), () => update());
  }

  Future<void> saveProfileImage() async {
    try {
      if (profileImage != null) {
        await firestoreService.updateProfileImage(
            "personal_info", user!.uid, profileImage!);
        await firestoreService.updateProfileImage(
            "users", user!.uid, profileImage!);
      }
    } catch (e) {
      Get.snackbar(
          "Error!",
          "Something went wrong while updating profile information"
              .capitalize!);
      throw ("Error updating profile information: $e");
    }
  }

  Future<void> saveProfileDetails() async {
    try {


      if (displayName.text.isNotEmpty) {
        await firestoreService.updateDisplayName(user!.uid, displayName.text);
      }
      if (about.text.isNotEmpty) {
        await firestoreService.updateAbout(user!.uid, about.text);
   
      }
    } catch (e) {
      Get.snackbar(
          "Error!",
          "Something went wrong while updating profile information"
              .capitalize!);
      throw ("Error updating profile information: $e");
    }
    update();
  }

  Future<void> selectGalleryImage() async {
    try {
      final pickedImg =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImg != null) {
        OnlineStorage onlineStorage = OnlineStorage();
        profileImage = await onlineStorage.uploadFileForUser(
            "root", "profileImages", user!.uid, File(pickedImg.path));
      }
    } catch (e) {
      throw ("Error selecting image: $e");
    }
    update();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> personalInfoStream() {
    return firestoreService.firestoreInstance
        .collection("personal_info")
        .doc(user!.uid)
        .snapshots();
  }

  Future<void> showEditBottomSheet(String newText, int fieldLimit,
      BuildContext context, TextEditingController textController) async {
    final result = showBottomSheet(
      enableDrag: true,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: 70.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      onChanged: (value) async {
                        if (textController.text.isNotEmpty) {
                          saveProfileDetails();
                        }
                        if (charactersCount < fieldLimit) {
                          setState(() => charactersCount = value.length);
                        }
                      },
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Text Here',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text("$charactersCount/$fieldLimit"),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          );
        },
      ),
    );
    result.closed.then((value) {
      displayName.clear();
      about.clear();
    });
  }

  void showProfileImageBottomSheet(BuildContext context) {
    const double radius = 30.0;
    const Color backgroundColor = Colors.white;
    Color? strockColor = Colors.green[900];

    final result = showBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => selectGalleryImage(),
              child: BuildBottomSheetItemForSelectingPic(
                title: "Gallery",
                backgroundColor: backgroundColor,
                strockColor: strockColor,
                radius: radius,
                icon: Icons.browse_gallery,
              ),
            ),
            const SizedBox(width: 10.0),
            BuildBottomSheetItemForSelectingPic(
              title: "Take a picture",
              backgroundColor: backgroundColor,
              strockColor: strockColor,
              radius: radius,
              icon: Icons.camera_sharp,
            ),
            const SizedBox(width: 10.0),
          ],
        ),
      ),
    );
    result.closed.then((value) {
      saveProfileImage();
      update();
    });
  }

  void updateSettingsController() {
    SettingsController settingsController = Get.put(SettingsController());
    settingsController.update();
  }
}
