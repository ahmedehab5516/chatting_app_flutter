
import 'package:chatting_app_v2/controllers/chat_room_controller.dart';
import 'package:chatting_app_v2/models/message.dart';
import 'package:chatting_app_v2/shared_componants/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ChatRoom extends StatelessWidget {
  ChatRoom({super.key});
  final ChatRoomController _chatRoomController = Get.put(ChatRoomController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(100, 0, 0, 0),
                  items: const [
                    PopupMenuItem<String>(
                      value: 'clear_chat',
                      child: Text('Clear Chat'),
                    ),
                    PopupMenuItem<String>(
                      value: 'wallpaper',
                      child: Text('WallPaper'),
                    ),
                    PopupMenuItem<String>(
                      value: 'report',
                      child: Text('Report'),
                    ),
                    PopupMenuItem<String>(
                      value: 'block',
                      child: Text('Block'),
                    ),
                  ],
                ).then((String? value) {
                  if (value == "clear_chat") {
                    _chatRoomController.clearChat();
                  }
                  if (value == "wallpaper") {
                    _chatRoomController.chooseAndUploadWallpaper();
                  }
                });
              },
              icon: const Icon(FontAwesomeIcons.ellipsisVertical)),
        ],
        leadingWidth: 25.0,
        title: Row(
          children: [
            GetBuilder<ChatRoomController>(
              builder: (controller) => CircleAvatar(
                radius: 23,
                backgroundImage: NetworkImage(controller.profileImage ??
                    "https://i.pinimg.com/236x/80/ef/85/80ef85c30a3fe9e338fc668ab10d136b.jpg"),
              ),
            ),
            const SizedBox(width: 10.0),
            Text(_chatRoomController.routeArgument['username'].toString()),
          ],
        ),
        backgroundColor: Colors.teal[800],
      ),
      body: GetBuilder<ChatRoomController>(
        builder: (controller) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(controller.wallpaperImage!),
                fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: controller.gettingStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Error");
                    } else if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    List<QueryDocumentSnapshot<Map<String, dynamic>>>?
                        messages = snapshot.data!.docs;
                    List<BuildMessageBubble> messageBubbles = [];
                    for (var message in messages) {
                      final messageContent = message['messageContent'];
                      final receiverEmail = message['receiverEmail'];
                      final senderEmail = message['senderEmail'];
                      final timestamp = message['timestamp'];
                      BuildMessageBubble messageBubble = BuildMessageBubble(
                        message: Message(
                          messageContent: messageContent,
                          receiverEmail: receiverEmail,
                          senderEmail: senderEmail,
                          timestamp: timestamp,
                        ),
                        isMe: _chatRoomController.user!.email == senderEmail,
                      );
                      messageBubbles.add(messageBubble);
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ListView(children: messageBubbles),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: BuildTextField(
                        controller: _chatRoomController.messageController,
                        validatorFunction: (value) => null,
                        isPasswordField: false,
                        obsecureText: false,
                        hintText: "message here...",
                      ),
                    ),
                    MaterialButton(
                      onPressed: () => _chatRoomController.sendMessage(),
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(18.0),
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text(
                          "send",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BuildMessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const BuildMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              color: isMe ? Colors.amberAccent : Colors.teal[800],
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width *
                    0.7, // Adjust this value as needed
              ),
              child: Text(
                message.messageContent,
                textAlign: isMe ? TextAlign.right : TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
