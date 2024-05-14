
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared_componants/pic_selecting_bottom_sheet.dart';

class ProfileController extends GetxController {
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
    profileImage = prefs.getString("profile_image");
    update();
  }

  void getBottomSheet(BuildContext context) {
    const double radius = 30.0;
    const Color backgroundColor = Colors.white;
    Color? strockColor = Colors.green[900];

    showBottomSheet(
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
  }

  getMenu(BuildContext context) {
    showMenu(
      elevation: 50.0,
      context: context,
      position: const RelativeRect.fromLTRB(100, 0, 0, 0),
      items: const [
        PopupMenuItem(
          value: "share",
          child: Text("Share"),
        ),
        PopupMenuItem(
          value: "edit",
          child: Text("Edit"),
        ),
        PopupMenuItem(
          value: "address_book",
          child: Text("View in address book"),
        ),
        PopupMenuItem(
          value: "security_code",
          child: Text("Verifiy security code"),
        ),
      ],
    ).then((value) {
      
    });
  }

  @override
  void onInit() {
    super.onInit();
    // Fetch profile image when the controller is initialized
    updateProfileImage();
  }
}
