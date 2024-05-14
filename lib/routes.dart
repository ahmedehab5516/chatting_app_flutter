import 'package:chatting_app_v2/screens/calling%20screens/audio_call.dart';
import 'package:chatting_app_v2/screens/chat_room.dart';
import 'package:chatting_app_v2/screens/profile.dart';
import 'package:chatting_app_v2/screens/register_screen.dart';
import 'package:get/get.dart';
import 'screens/edit_personal_info_scree.dart';
import 'screens/forgot_password.dart/forgot_passwrod_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/signin_screen.dart';

class Routes {
  static const String home = "/home";
  static const String signin = "/signin";
  static const String register = "/register";
  static const String chatroom = "/chatroom";
  static const String forgotpassword = "/forgotpassword";
  static const String audiocall = "/audiocall";
  static const String profile = "/profile";
  static const String setting = "/setting";
  static const String editPersonalInfo = "/editpersonalinfo";

  static List<GetPage<dynamic>>? pages = [
    GetPage(name: Routes.home, page: () => HomeScreen()),
    GetPage(name: Routes.signin, page: () => SignInScreen()),
    GetPage(name: Routes.register, page: () => RegisterScreen()),
    GetPage(name: Routes.chatroom, page: () => ChatRoom()),
    GetPage(name: Routes.forgotpassword, page: () => ForgotPasswordScreen()),
    GetPage(name: Routes.audiocall, page: () => const AudioCall()),
    GetPage(name: Routes.profile, page: () => Profile()),
    GetPage(name: Routes.setting, page: () =>  SettingsScreen()),
    GetPage(
        name: Routes.editPersonalInfo, page: () => EditPersonaleInfoScreen()),
  ];
}
