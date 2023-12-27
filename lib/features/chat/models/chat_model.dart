import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final List messages;
  final List users;
  final Timestamp createdAt;

  ChatModel({
    required this.id,
    required this.messages,
    required this.users,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "messages": this.messages,
        "users": this.users,
        "createdAt": this.createdAt,
      };

  factory ChatModel.fromSnapshot(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    return ChatModel(
      id: snap["id"],
      messages: snap["messages"],
      users: snap["users"],
      createdAt: snap["createdAt"],
    );
  }
}
