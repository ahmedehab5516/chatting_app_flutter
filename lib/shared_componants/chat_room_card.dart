import 'dart:io';

import 'package:chatting_app_v2/controllers/home_controller.dart';
import 'package:chatting_app_v2/models/message.dart';
import 'package:chatting_app_v2/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BuildChatRoomCard extends StatelessWidget {
  final String username;
  final String email;
  final Timestamp createdAt;
  final String uid;
  final Message lastMessage;
  final String? profileImg;
  final HomeController homeController;
  const BuildChatRoomCard({
    super.key,
    required this.username,
    required this.homeController,
    required this.profileImg,
    required this.lastMessage,
    required this.email,
    required this.createdAt,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: SizedBox(
        height: 75.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.dialog(
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: profileImg != null
                            ? Image.file(
                                File(profileImg!),
                                fit: BoxFit.cover,
                                scale: 1.5,
                              )
                            : Image.asset("assets/images/sexy_sundress.jpg"),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => Get.toNamed(Routes.chatroom,
                                arguments: {
                                  "email": email,
                                  "uid": uid,
                                  "username": username
                                }),
                            child: CircleAvatar(
                              backgroundColor: Colors.teal[800],
                              child:
                                  const Icon(Icons.chat, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 15.0),
                          CircleAvatar(
                            backgroundColor: Colors.teal[800],
                            child: const Icon(Icons.call, color: Colors.white),
                          ),
                          const SizedBox(width: 15.0),
                          CircleAvatar(
                            backgroundColor: Colors.teal[800],
                            child: const Icon(Icons.video_call,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 15.0),
                          GestureDetector(
                            onTap: () => Get.toNamed(Routes.profile),
                            child: CircleAvatar(
                              backgroundColor: Colors.teal[800],
                              child: const Icon(FontAwesomeIcons.user,
                                  size: 20.0, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  name: "$username profile photo",
                );
              },
              child: profileImg != null
                  ? CircleAvatar(
                      radius: 40,
                      backgroundImage: FileImage(
                        File(profileImg!),
                      ),
                    )
                  : const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                        "assets/images/sexy_sundress.jpg",
                      ),
                    ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: GestureDetector(
                onTap: () => Get.toNamed(Routes.chatroom, arguments: {
                  "email": email,
                  "uid": uid,
                  "username": username,
                }),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Expanded(
                      child: GetBuilder<HomeController>(
                        builder: (controller) => StreamBuilder(
                          stream: homeController.getLastMessage(uid),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(
                                "error getting last message",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              );
                            }
                            if (!snapshot.hasData) {
                              return Text(
                                "no messages yet!!",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                "getting last message....",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              );
                            }

                            Map<String, dynamic> data =
                                snapshot.data!.docs[0].data();
                            String formattedTime = DateFormat('hh:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                data['timestamp'].millisecondsSinceEpoch,
                                isUtc: true,
                              ),
                            );

                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    data['messageContent'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  height: 7.0,
                                  width: 7.0,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.amber),
                                ),
                                Text(formattedTime),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
