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
}
