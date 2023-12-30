import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String messageText;
  final Timestamp createdAt;

  MessageModel({
    required this.senderId,
    required this.messageText,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        "senderId": this.senderId,
        "messageText": this.messageText,
        "createdAt": this.createdAt,
      };

  factory MessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    return MessageModel(
      senderId: snap["senderId"],
      messageText: snap["messageText"],
      createdAt: snap["createdAt"],
    );
  }
}