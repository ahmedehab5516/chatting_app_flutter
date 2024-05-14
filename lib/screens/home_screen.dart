import 'package:chatting_app_v2/controllers/home_controller.dart';
import 'package:chatting_app_v2/models/message.dart';
import 'package:chatting_app_v2/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../shared_componants/chat_room_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        elevation: 0,
        title: const Text("Chats"),
        actions: [
          IconButton(
            onPressed: () {
              showMenu(
                elevation: 50.0,
                context: context,
                position: const RelativeRect.fromLTRB(100, 0, 0, 0),
                items: [
                  PopupMenuItem(
                    value: "setting",
                    onTap: () => Get.toNamed(Routes.setting),
                    child: Text("setting".capitalize!),
                  ),
                  PopupMenuItem(
                    value: "logout",
                    onTap: () => _homeController.signOut(),
                    child: Text("log out".capitalize!),
                  ),
                ],
              );
            },
            icon: const Icon(
              FontAwesomeIcons.ellipsisVertical,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _homeController.userFirestoreStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("no other users yet"));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> users =
                snapshot.data!.docs;

            List<BuildChatRoomCard> chatRoomWidgets = [];

            for (var user in users) {
              String userEmail = user['email'];
              String userID = user['uid'];
              String userName = user['username'];
              Timestamp userCreatedAt = user['createdAt'];
              String? imageUrl = user['imageUrl'];
          

              BuildChatRoomCard chatRoomWidget = BuildChatRoomCard(
                homeController: _homeController,
                uid: userID,
                username: userName,
                profileImg: imageUrl,
                email: userEmail,
                createdAt: userCreatedAt,
                lastMessage: Message(
                    messageContent:
                        "_homeController.lastMessage!['messageContent']",
                    receiverEmail: '',
                    senderEmail: '',
                    timestamp: Timestamp.now()),
              );
              chatRoomWidgets.addIf(
                  _homeController.user!.email != userEmail, chatRoomWidget);
            }
            return ListView.separated(
              shrinkWrap: false,
              itemBuilder: (context, index) => chatRoomWidgets[index],
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  thickness: 2.0,
                  color: Colors.teal[800],
                ),
              ),
              itemCount: chatRoomWidgets.length,
            );
          }
        },
      ),
    );
  }
}
