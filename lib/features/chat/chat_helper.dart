import 'package:chaty/features/chat/models/chat_model.dart';
import 'package:chaty/features/chat/models/last_position_model.dart';
import 'package:chaty/features/chat/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatHelper {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ! Get My Chats
  // Retrieve history chat
  static Future<QuerySnapshot<Map<String, dynamic>>> getMyChats(
      String currentUserId) {
    return firestore
        .collection("chats")
        .where("users", arrayContains: currentUserId)
        .get();
  }

  // ! Get Current Chat
  static Future<DocumentSnapshot<Map<String, dynamic>>> getChat(String chatId) {
    return firestore.collection("chats").doc(chatId).get();
  }

  // ! Stream Current Chat
  static Stream<DocumentSnapshot<Map<String, dynamic>>> streamChat(
      String chatId) {
    return firestore.collection("chats").doc(chatId).snapshots();
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
        .orderBy("createdAt", descending: false)
        .snapshots();
  }

  // ! Create New Chat
  // memulai chat baru
  static Future<ChatModel?> createNewChat({
    required String currentUserId,
    required String otherUserId,
  }) async {
    ChatModel? chatModel;
    try {
      // ! Create New Chat
      DocumentReference chatReference = await firestore.collection("chats").add(
            ChatModel(
              chatId: "",
              users: [currentUserId, otherUserId],
              lastPosition: [
                LastPositionModel(
                  userId: currentUserId,
                  lastPosition: 0.0,
                ).toMap(),
                LastPositionModel(
                  userId: otherUserId,
                  lastPosition: 0.0,
                ).toMap(),
              ],
              lastMessage: {},
              createdAt: Timestamp.now(),
            ).toJson(),
          );
      await firestore
          .collection("chats")
          .doc(chatReference.id)
          .update({"chatId": chatReference.id});
      await firestore.collection("users").doc(currentUserId).update({
        "chats": [chatReference.id]
      });
      await firestore.collection("users").doc(otherUserId).update({
        "chats": [chatReference.id]
      });

      chatModel = ChatModel.fromSnapshot(
          await firestore.collection("chats").doc(chatReference.id).get());
    } catch (e) {
      print("GAGAL CREATE CHATTTTTTTTTTTTTTTTT: $e");
    }

    return chatModel;
  }

  // ! Send Message
  static Future sendMessage({
    required String chatId,
    required String currentUserId,
    required String messageText,
    required double position,
  }) async {
    try {
      DocumentSnapshot chatReference =
          await firestore.collection("chats").doc(chatId).get();

      // ! Send Message
      DocumentReference messageRef = await firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .add(
            MessageModel(
              messageId: "",
              senderId: currentUserId,
              messageText: messageText,
              createdAt: Timestamp.now(),
              position: position,
            ).toMap(),
          );

      // ! Update Last Message
      await firestore.collection("chats").doc(chatId).update({
        "lastMessage": MessageModel(
          messageId: "",
          senderId: currentUserId,
          messageText: messageText,
          createdAt: Timestamp.now(),
          position: position,
        ).toMap(),
      });

      await firestore
          .collection("chats")
          .doc(chatReference.id)
          .collection("messages")
          .doc(messageRef.id)
          .update({"messageId": messageRef.id});
    } catch (e) {}
  }

  // ! DELETE Message
  static Future deleteMessage({
    required String userId,
    required String otherUserId,
    required String chatId,
    required String messageId,
  }) async {
    try {
      await firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(messageId)
          .delete();

      final querySnapshot = await firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .get();

      if (querySnapshot.docs.isEmpty) {
        await firestore
            .collection("chats")
            .doc(chatId)
            .update({"lastMessage": {}});
      }
    } catch (e) {
      print("GAGAL: $e");
    }
  }
}
