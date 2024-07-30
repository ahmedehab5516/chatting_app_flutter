  import 'package:flutter/material.dart';

import '../../shared_componants/pic_selecting_bottom_sheet.dart';

void getBottomSheetFunc(BuildContext context ,void Function()? galleryPicker ,void Function()? afterClose) {
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
              onTap: () => galleryPicker,
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
    result.closed.then((value) => afterClose);
  }
