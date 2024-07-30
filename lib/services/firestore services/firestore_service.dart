import 'package:chatting_app_v2/models/message.dart';
import 'package:chatting_app_v2/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseFirestore get firestoreInstance => _firestore;

  // add new user
  Future<void> addUserToFirestore(
      String userID,
      String username,
      String email,
      String phonenumber,
      int birthDay,
      int birthMonth,
      int birthYear,
      String gender) async {
    try {
      await _firestore.collection("users").doc(userID).set(User(
            username: username,
            uid: userID,
            email: email,
            phoneNumber: phonenumber,
            imageUrl: "",
            birthDay: birthDay,
            state: true,
            isArchived : false,
            birthMonth: birthMonth,
            birthYear: birthYear,
            gender: gender,
            createdAt: DateTime.now().toUtc(),
          ).toMap());
    } catch (e) {
      throw Exception(
          "Error occurred while adding a new user to Firestore: $e");
    }
  }

  // add new messages
  Future<void> addNewMessages(String chatRoomID, String messageContent,
      String senderEmail, String receiverEmail) async {
    try {
      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .add(Message(
            messageContent: messageContent,
            receiverEmail: receiverEmail,
            senderEmail: senderEmail,
            timestamp: Timestamp.now(),
          ).toMap());
    } catch (e) {
      throw Exception("Error sending new message: $e");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      String chatRoomID) {
    try {
      return _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .snapshots();
    } catch (e) {
      throw Exception("Error getting the last message sent by a user: $e");
    }
  }

  Future<void> addPersonalInfo(
      String userID, String displayName, String about, String imageUrl) async {
    try {
      await firestoreInstance.collection("personal_info").doc(userID).set({
        "displayName": displayName,
        "about": about,
        "imageUrl": imageUrl,
      });
    } catch (e) {
      throw ("help meeeee $e");
    }
  }

  Future<void> updateDisplayName(String userID, String displayName) async {
    try {
      await _firestore
          .collection("personal_info")
          .doc(userID)
          .update({"displayName": displayName});
    } catch (e) {
      throw Exception("Error updating display name: $e");
    }
  }

  Future<void> updateAbout(String userID, String about) async {
    try {
      await _firestore
          .collection("personal_info")
          .doc(userID)
          .update({"about": about});
    } catch (e) {
      throw Exception("Error updating about information: $e");
    }
  }

  Future<void> updateProfileImage(
      String collectionName, String userID, String profileImgPath) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(userID)
          .update({"imageUrl": profileImgPath});
    } catch (e) {
      throw Exception("Error updating profile image information: $e");
    }
  }
}
