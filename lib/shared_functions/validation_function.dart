import 'package:get/get.dart';

String? validationFunction(String validateType, String value) {
  String numbersAndSpecialChars = '@.0123456789!#\$%^&*()-_=+[{]}|;:,<>?/~';

  if (validateType == "email") {
    if (value.isEmpty) {
      return "Email Field Can't be Empty";
    } else if (!value.contains("@") || !value.contains(".")) {
      return "Please Enter A Valid Email Address";
    } else {
      for (int i = 12; i < numbersAndSpecialChars.length; i++) {
        if (value.contains(numbersAndSpecialChars[i])) {
          return "Can't Use Special Characters in Email Address.";
        }
      }
    }
  } else if (validateType == "password") {
    if (value.isEmpty) {
      return "Password Field Can't be Empty";
    } else if (value.length <= 6 || value.length >= 12) {
      return "Password Must Be Between 6 and 12";
    }
  } else if (validateType == "username") {
    if (value.isEmpty) {
      return "This Field Can't be Empty";
    } else if (value.length > 20) {
      return "This Field is to long";
    } else if (value.length < 3) {
      return "This Field is to short";
    } else {
      for (int i = 0; i < numbersAndSpecialChars.length; i++) {
        if (value.contains(numbersAndSpecialChars[i])) {
          return "Can't Use numbers or Special Characters in User Name.";
        }
      }
    }
  } else if (validateType == "phone") {
    if (value.isEmpty) {
      return "phone number Can't be Empty";
    } else if (value.length > 11) {
      return "phone number is to long";
    } else if (!value.startsWith("01")) {
      return "Please Enter Valid Phone Number";
    } else {
      if (!value.isNumericOnly) {
        return "Please Enter Valid Phone Number";
      }
    }
  }
  return null;
}

// signInWithGoogle(BuildContext context) async {

//   try {
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//     final GoogleSignInAuthentication? googleAuth =
//         await googleUser?.authentication;

//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth?.accessToken,
//       idToken: googleAuth?.idToken,
//     );
//     UserCredential userCredential =
//         await FirebaseAuth.instance.signInWithCredential(credential);


//     return userCredential;
//   } on Exception catch (e) {
//     print('exception->$e');
//   }
// }
