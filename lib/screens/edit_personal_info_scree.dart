import 'dart:io';
import 'package:chatting_app_v2/controllers/edit_personal_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditPersonaleInfoScreen extends StatelessWidget {
  EditPersonaleInfoScreen({super.key});

  final EditPersonaleInfoController _controller =
      Get.put(EditPersonaleInfoController());
  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              Stack(
                children: [
                  SizedBox(
                    height: 150.0,
                    child: CircleAvatar(
                      radius: 100.0,
                      backgroundColor: Colors.green[900],
                      child: GetBuilder<EditPersonaleInfoController>(
                        builder: (controller) {
                          if (controller.profileImage != null) {
                            return CircleAvatar(
                              radius: 72.0,
                              backgroundImage:
                                  FileImage(File(controller.profileImage!)),
                            );
                          } else {
                            // Handle case when profileImage is null, e.g., display a placeholder
                            return const CircleAvatar(
                              radius: 100.0,
                              backgroundColor: Colors.grey, // Placeholder color
                              child: Icon(
                                Icons.person,
                                size: 50.0,
                                color: Colors.black,
                              ), // Placeholder icon or text
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Builder(builder: (context) {
                    return Positioned(
                      top: 100.0,
                      left: 130.0,
                      child: GestureDetector(
                        onTap: () => _controller.getBottomSheet(context),
                        child: CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.green[900],
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              StreamBuilder(
                  stream: _controller.stream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("error"));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    Map<String, dynamic>? data = snapshot.data!.data();

                    // Extract personal information from the document data
                    final name = data!['displayName'];
                    final about =
                        data['about'] ?? 'No about information available';

                    return Column(
                      children: [
                        Builder(builder: (context) {
                          return BuildInfoCard(
                            textController: _controller.displayName,
                            controller: _controller,
                            pageWidth: pageWidth,
                            fieldLimit: 20,
                            label: 'Name',
                            title: name,
                            icon: Icons.person,
                          );
                        }),
                        BuildInfoCard(
                          textController: _controller.about,
                          controller: _controller,
                          fieldLimit: 70,
                          pageWidth: pageWidth,
                          label: 'About',
                          title: about,
                          icon: Icons.info,
                        ),
                        BuildInfoCard(
                          textController: null,
                          fieldLimit: 11,
                          controller: _controller,
                          pageWidth: pageWidth,
                          label: 'Phone',
                          title: '011458222533',
                          icon: Icons.phone,
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildInfoCard extends StatelessWidget {
  const BuildInfoCard({
    super.key,
    required this.pageWidth,
    required this.fieldLimit,
    required this.label,
    required this.title,
    required this.icon,
    required this.controller,
    required this.textController,
  });

  final double pageWidth;
  final String label;
  final String title;
  final IconData icon;
  final int fieldLimit;
  final EditPersonaleInfoController controller;
  final TextEditingController? textController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == "Phone") {
          return;
        }

        controller.showMyBottomSheet(
            textController!.text, fieldLimit, context, textController!);

      
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 20.0),
            SizedBox(
              width: pageWidth * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: pageWidth * 0.7),
                        child: Text(title.capitalize!,
                            maxLines: 2,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0)),
                      ),
                      Visibility(
                        visible: label == "Phone" ? false : true,
                        child: Icon(
                          Icons.edit,
                          color: Colors.lightGreen[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Visibility(
                    visible: label == "Name" ? true : false,
                    child: Text(
                      "this name is not your username or pin. this name will be visible to your contacts",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
