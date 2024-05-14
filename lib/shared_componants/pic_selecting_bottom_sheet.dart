import 'package:flutter/material.dart';

class BuildBottomSheetItemForSelectingPic extends StatelessWidget {
  const BuildBottomSheetItemForSelectingPic({
    super.key,
    required this.radius,
    required this.strockColor,
    required this.backgroundColor,
    required this.icon,
    required this.title,
  });

  final double radius;
  final Color? strockColor;
  final Color backgroundColor;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.0,
      child: Column(
        children: [
          CircleAvatar(
            radius: radius + 3,
            backgroundColor: Colors.black54,
            child: CircleAvatar(
              radius: radius,
              backgroundColor: backgroundColor,
              child: Icon(
                icon,
                color: strockColor,
              ),
            ),
          ),
          Text(title),
        ],
      ),
    );
  }
}
