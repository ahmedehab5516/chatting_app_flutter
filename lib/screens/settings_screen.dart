import 'dart:io';

import 'package:chatting_app_v2/controllers/settings_controller.dart';
import 'package:chatting_app_v2/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.editPersonalInfo),
              child: Row(
                children: [
                  GetBuilder<SettingsController>(
                    builder: (controller) {
                      if (controller.profileImage != null) {
                        return CircleAvatar(
                          radius: 40.0,
                          backgroundImage:
                              FileImage(File(controller.profileImage!)),
                        );
                      } else {
                        // Handle case when profileImage is null, e.g., display a placeholder
                        return const CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Colors.grey, // Placeholder color
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                          ), // Placeholder icon or text
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 10.0),
                  GetBuilder<SettingsController>(
                    builder: (controller) {
                      if (controller.about != null) {
                        return ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: pageWidth * 0.68),
                          child: Text(
                            controller.about!.capitalize!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        );
                      } else {
                        // Return a fallback widget when about is null
                        return Text(
                          'No about information available',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Column(
                children: [
                  BuildSettingCard(
                    desc: 'security notification, change number',
                    title: 'account',
                    icon: FontAwesomeIcons.key,
                  ),
                  Divider(
                    thickness: 3.0,
                    color: Colors.black45,
                  ),
                  BuildSettingCard(
                    title: 'privacy',
                    desc: 'block contacts , disapearing messages',
                    icon: FontAwesomeIcons.lock,
                  ),
                  Divider(
                    thickness: 3.0,
                    color: Colors.black45,
                  ),
                  BuildSettingCard(
                    title: 'chats',
                    desc: 'theme , wallpapers , chat history',
                    icon: FontAwesomeIcons.chartArea,
                  ),
                  Divider(
                    thickness: 3.0,
                    color: Colors.black45,
                  ),
                  BuildSettingCard(
                    title: 'help',
                    desc: 'help center, contact us, privacy policy',
                    icon: FontAwesomeIcons.question,
                  ),
                  Divider(
                    thickness: 3.0,
                    color: Colors.black45,
                  ),
                  BuildSettingCard(
                    title: 'invite a friend',
                    desc: '',
                    // ignore: deprecated_member_use
                    icon: FontAwesomeIcons.userFriends,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildSettingCard extends StatelessWidget {
  final String title;
  final String desc;
  final IconData icon;
  const BuildSettingCard(
      {super.key, required this.desc, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Icon(
            icon,
            color: Colors.teal[800],
            size: 20.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title.capitalize!,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            desc.isNotEmpty
                ? const SizedBox(height: 10.0)
                : const SizedBox(height: 0.0),
            Text(
              desc,
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}
