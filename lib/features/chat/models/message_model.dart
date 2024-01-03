import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messageId;
  final String senderId;
  final String messageText;
  final Timestamp createdAt;
  final num position;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.messageText,
    required this.createdAt,
    required this.position,
  });

  Map<String, dynamic> toMap() => {
        "messageId": this.messageId,
        "senderId": this.senderId,
        "messageText": this.messageText,
        "createdAt": this.createdAt,
        "position": this.position,
      };

  factory MessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    return MessageModel(
      messageId: snap["messageId"],
      senderId: snap["senderId"],
      messageText: snap["messageText"],
      createdAt: snap["createdAt"],
      position: snap["position"],
    );
  }

  factory MessageModel.fromMap(Map<String, dynamic> snap) {
    return MessageModel(
      messageId: snap["messageId"],
      senderId: snap["senderId"],
      messageText: snap["messageText"],
      createdAt: snap["createdAt"],
      position: snap["position"],
    );
  }
}
