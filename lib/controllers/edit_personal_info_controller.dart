import 'package:chatting_app_v2/services/auth%20services/auth_service.dart';
import 'package:chatting_app_v2/services/firestore%20services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared_componants/pic_selecting_bottom_sheet.dart';

class EditPersonaleInfoController extends GetxController {
  final FirestoreService firestoreService = FirestoreService();
  final AuthService authService = AuthService();
  late TextEditingController displayName;
  late TextEditingController about;

  User? user;
  void gettingCurrentUser() {
    if (authService.auth.currentUser != null) {
      user = authService.auth.currentUser;
    }
  }

  Future<void> saveProfileImage() async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      if (profileImage != null) {
        await firestoreService.updateProfileImage(
            "personal_info", user!.uid, profileImage!);
        await firestoreService.updateProfileImage(
            "users", user!.uid, profileImage!);
      }
      preferences.setString("profile_image", profileImage!);
    } catch (e) {
      Get.snackbar(
          "Error!",
          "Something went wrong while updating profile information"
              .capitalize!);
      throw ("Error updating profile information: $e");
    }
  }

  Future<void> saveControllers() async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      if (displayName.text.isNotEmpty) {
        await firestoreService.updateDisplayName(user!.uid, displayName.text);
      }
      if (about.text.isNotEmpty) {
        await firestoreService.updateAbout(user!.uid, about.text);

        preferences.setString("about", about.text);
      }
    } catch (e) {
      Get.snackbar(
          "Error!",
          "Something went wrong while updating profile information"
              .capitalize!);
      throw ("Error updating profile information: $e");
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> stream() {
    return firestoreService.firestoreInstance
        .collection("personal_info")
        .doc(user!.uid)
        .snapshots();
  }

  int charactersCount = 0;
  Future<void> showMyBottomSheet(String newText, int fieldLimit,
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
                          saveControllers();
                        }
                        if (charactersCount < fieldLimit) {
                          setState(
                            () => charactersCount = value.length,
                          );
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

  String? profileImage;
  Future<void> galleryImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final pickedImg =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImg != null) {
        prefs.setString("profile_image", pickedImg.path);
        updateProfileImage();
      }
    } catch (e) {
      throw ("Error selecting image: $e");
    }
  }

  Future<void> clearProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("profile_image");
    updateProfileImage();
  }

  Future<void> updateProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DocumentSnapshot<Map<String, dynamic>> userPersonalDate =
        await firestoreService.firestoreInstance
            .collection("personal_info")
            .doc(user!.uid)
            .get();

    profileImage =
        prefs.getString("profile_image") ?? userPersonalDate['imageUrl'];

    update();
  }

  void getBottomSheet(BuildContext context) {
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
              onTap: () => galleryImage(),
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
    });
  }

  @override
  void onClose() {
    super.onClose();
    displayName.dispose();
    about.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    // Fetch profile image when the controller is initialized
    updateProfileImage();
    displayName = TextEditingController();
    about = TextEditingController();
    gettingCurrentUser();
  }
}
// showBottomSheet(
//           enableDrag: true,
//           context: context,
//           builder: (context) => StatefulBuilder(
//             builder: (context, setState) => SizedBox(
//               height: 70.0,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                       child: TextField(
//                         onChanged: (value) async {
//                           if (textController!.text.isNotEmpty) {
//                             controller.saveController();
//                           }
//                           if (charactersCount < 20) {
//                             setState(
//                               () => charactersCount = value.length,
//                             );
//                           }
//                           textController!.addListener(() {
//                             final newText = controller.displayName.text;
//                             if (newText.length > 20) {
//                               // If the text length exceeds the maximum limit, remove the extra characters
//                               final truncatedText = newText.substring(0, 20);

//                               textController!.value = TextEditingValue(
//                                 text: truncatedText,
//                                 selection: TextSelection.collapsed(
//                                     offset: truncatedText.length),
//                               );
//                             }

//                             setState(() {
//                               charactersCount = newText.length;
//                             });
//                           });
//                         },