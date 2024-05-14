
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageContent;
  final String receiverEmail;
  final String senderEmail;
  final Timestamp timestamp;

  Message(
      {required this.messageContent,
      required this.receiverEmail,
      required this.senderEmail,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'messageContent': messageContent,
      'receiverEmail': receiverEmail,
      'senderEmail': senderEmail,
      'timestamp': timestamp,
    };
  }
}
