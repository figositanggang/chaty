import 'package:chaty/features/chat/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  Rx<TextEditingController> _messageController = TextEditingController().obs;
  TextEditingController get messageController => _messageController.value;
  void setMessageController(TextEditingController value) {
    _messageController.value = value;
  }

  Rx<ScrollController> _scrollController = ScrollController().obs;
  ScrollController get scrollController => _scrollController.value;
  void setScrollController(ScrollController value) {
    _scrollController.value = value;
  }

  Rx<ChatModel>? chatModel = ChatModel(
    chatId: "",
    users: [],
    lastPosition: [],
    lastMessage: {},
    createdAt: Timestamp.now(),
  ).obs;
  void setChatModel(ChatModel value) {
    chatModel!.value = value;
  }
}
