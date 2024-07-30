import 'package:chatting_app_v2/controllers/home_controller.dart';
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _homeController.userFirestoreStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("there are no users!!!"));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> users = snapshot
                .data!.docs
                .where((element) =>
                    element['state'] == true && element['isArchived'] == false)
                .toList();

            Map<String, dynamic> appBarTitle = users
                .firstWhereOrNull(
                    (element) => element['uid'] == _homeController.user!.uid)!
                .data();

            return CustomScaffold(
              appBarTitle: appBarTitle['username'],
              homeController: _homeController,
              users: users,
            );
          }
        },
      ),
    );
  }
}

class CustomScaffold extends StatelessWidget {
  final String appBarTitle;
  final HomeController homeController;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> users;

  const CustomScaffold({
    super.key,
    required this.appBarTitle,
    required this.homeController,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        elevation: 0,
        title: Text("$appBarTitle's Chats"),
        actions: [
          IconButton(
            onPressed: () => homeController.requestCameraPermission(),
            icon: const Icon(Icons.camera),
          ),
          GetBuilder<HomeController>(
            builder: (controller) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: SizedBox(
                child: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Let the Row take only the needed width
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: controller.toggel
                              ? AnimatedContainer(
                                  key: ValueKey(controller.selectedChatRoomId),
                                  duration: const Duration(milliseconds: 800),
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize
                                        .min, // Let the Row take only the needed width
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            controller.showMuteDialog(context),
                                        icon: const Icon(
                                          FontAwesomeIcons.bellSlash,
                                          size: 16.0,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.archive,
                                          size: 20.0,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            controller.deleteChatRoom(),
                                        icon: const Icon(
                                          FontAwesomeIcons.trashCan,
                                          size: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : IconButton(
                                  key: ValueKey(controller.selectedChatRoomId),
                                  onPressed: () {
                                    showMenu(
                                      elevation: 50.0,
                                      context: context,
                                      position: const RelativeRect.fromLTRB(
                                          100, 0, 0, 0),
                                      items: [
                                        PopupMenuItem(
                                          value: "setting",
                                          onTap: () =>
                                              Get.toNamed(Routes.setting),
                                          child: Text("setting".capitalize!),
                                        ),
                                        PopupMenuItem(
                                          value: "logout",
                                          onTap: () => homeController.signOut(),
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
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          GetBuilder<HomeController>(
            builder: (controller) => Visibility(
              visible: false,
              child: Container(
                width: double.infinity,
                height: 30.0,
                color: Colors.teal[900],
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.archiveScreen),
                  child: const Text(
                    "Archived Chats",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: false,
              itemBuilder: (context, index) {
                QueryDocumentSnapshot<Map<String, dynamic>> user = users[index];
                String userEmail = user['email'];
                String userID = user['uid'];
                String userName = userID == homeController.user!.uid
                    ? "${user['username']} (you)"
                    : user['username'];
                Timestamp userCreatedAt = user['createdAt'];
                String? imageUrl = user['imageUrl'];

                return GetBuilder<HomeController>(
                  builder: (controller) => GestureDetector(
                    onLongPress: () {
                      controller.selectChatRoom(users[index]['uid']);
                    },
                    child: BuildChatRoomCard(
                      homeController: homeController,
                      uid: userID,
                      username: userName,
                      profileImg: imageUrl!.isEmpty
                          ? "https://i.pinimg.com/236x/a9/4b/d2/a94bd23bcc4a522dd55b1ae5fef93972.jpg"
                          : imageUrl,
                      email: userEmail,
                      createdAt: userCreatedAt,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  thickness: 2.0,
                  color: Colors.teal[800],
                ),
              ),
              itemCount: users.length,
            ),
          ),
        ],
      ),
    );
  }
}
