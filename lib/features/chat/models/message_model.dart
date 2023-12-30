import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String messageText;
  final Timestamp createdAt;
  final double position;

  MessageModel({
    required this.senderId,
    required this.messageText,
    required this.createdAt,
    required this.position,
  });

  Map<String, dynamic> toMap() => {
        "senderId": this.senderId,
        "messageText": this.messageText,
        "createdAt": this.createdAt,
        "position": this.position,
      };

  factory MessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    return MessageModel(
      senderId: snap["senderId"],
      messageText: snap["messageText"],
      createdAt: snap["createdAt"],
      position: snap["position"],
    );
  }

  factory MessageModel.fromMap(Map<String, dynamic> snap) {
    return MessageModel(
      senderId: snap["senderId"],
      messageText: snap["messageText"],
      createdAt: snap["createdAt"],
      position: snap["position"],
    );
  }
}
