import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderId,
        required this.senderEmail,
        required this.receiverId,
        required this.message,
        required this.timestamp});

  //convert to map because that's how information is stored on firebase
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
