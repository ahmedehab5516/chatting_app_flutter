
import 'package:chatting_app_v2/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  final ProfileController _profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      extendBody: true,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_ios)),
                  
                  IconButton(
                      onPressed: () =>_profileController.getMenu(context),
                      icon: const Icon(FontAwesomeIcons.ellipsisVertical)),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ProfileActionTile(
                    title: 'Message', icon: Icons.chat, ontap: () {}),
                ProfileActionTile(
                    title: 'Audio Call', icon: Icons.call, ontap: () {}),
                ProfileActionTile(
                    title: 'Video Call', icon: Icons.video_call, ontap: () {}),
              ],
            ),
            // const SizedBox(height: 5.0),
            Divider(
              thickness: 2.0,
              color: Colors.teal[800],
              endIndent: 10.0,
              indent: 10.0,
            ),
            const SizedBox(height: 5.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "i love you 3000",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "date date date ",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Divider(
              thickness: 2.0,
              color: Colors.teal[800],
              endIndent: 10.0,
              indent: 10.0,
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Container(
                alignment: Alignment.center,
                height: 120.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      elevation: 10.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          "https://i.pinimg.com/474x/41/6e/9a/416e9a8813f6f4bc0933e165464837ee.jpg",
                          width: 80.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  itemCount: 10,
                ),
              ),
            ),
            // const SizedBox(height: 5.0),
            Divider(
              thickness: 2.0,
              color: Colors.teal[800],
              endIndent: 10.0,
              indent: 10.0,
            ),
            // const SizedBox(height: 5.0),

            SwitchListTile(
              value: false,
              onChanged: (value) {},
              title: const Text(
                "Mute Notification",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileActionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? ontap;
  const ProfileActionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.0,
            color: Colors.black45,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(children: [
          Icon(
            icon,
            color: Colors.green[900]!,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ]),
      ),
    );
  }
}
