import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String chatId;
  final Map<String, dynamic> lastMessage;
  final num lastPosition;
  final List users;
  final Timestamp createdAt;

  ChatModel({
    required this.chatId,
    required this.users,
    required this.lastPosition,
    required this.lastMessage,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        "chatId": this.chatId,
        "users": this.users,
        "lastPosition": this.lastPosition,
        "lastMessage": this.lastMessage,
        "createdAt": this.createdAt,
      };

  factory ChatModel.fromSnapshot(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    return ChatModel(
      chatId: snap["chatId"],
      users: snap["users"],
      lastPosition: snap["lastPosition"],
      lastMessage: snap["lastMessage"],
      createdAt: snap["createdAt"],
    );
  }
}
