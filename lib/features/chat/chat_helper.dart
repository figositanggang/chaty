import 'package:chaty/features/chat/models/chat_model.dart';
import 'package:chaty/features/chat/models/message_model.dart';
import 'package:chaty/features/user/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatHelper {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ! Get My Chats
  // Retrieve history chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyChats(
      String currentUserId) {
    return firestore
        .collection("chats")
        .where("users", arrayContains: currentUserId)
        .snapshots();
  }

  // ! Get Current Chat Data
  static Future<QuerySnapshot<Map<String, dynamic>>> getChatData(
    String currentUserId,
    String otherUserId,
  ) {
    return firestore
        .collection("chats")
        .where("users", arrayContainsAny: [currentUserId, otherUserId]).get();
  }

  // ! Get Messages
  // Retreive current messages
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
    String chatId,
  ) {
    return firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .snapshots();
  }

  // ! Create New Chat
  // memulai chat baru
  static Future createNewChat({
    required String currentUserId,
    required String otherUserId,
    required String messageText,
  }) async {
    try {
      // ! Create New Chat
      DocumentReference chatReference = await firestore.collection("chats").add(
            ChatModel(
              chatId: "",
              users: [currentUserId, otherUserId],
              lastMessage: messageText,
              createdAt: Timestamp.now(),
            ).toJson(),
          );
      await firestore
          .collection("chats")
          .doc(chatReference.id)
          .update({"chatId": chatReference.id});

      // ! Send New Message
      await firestore
          .collection("chats")
          .doc(chatReference.id)
          .collection("messages")
          .add(
            MessageModel(
              senderId: currentUserId,
              messageText: messageText,
              createdAt: Timestamp.now(),
            ).toMap(),
          );
    } catch (e) {}
  }

  // ! Send Message
  static Future sendMessage({
    required String chatId,
    required String currentUserId,
    required String messageText,
  }) async {
    try {
      // ! Send New Message
      await firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .add(
            MessageModel(
              senderId: currentUserId,
              messageText: messageText,
              createdAt: Timestamp.now(),
            ).toMap(),
          );
    } catch (e) {}
  }
}
