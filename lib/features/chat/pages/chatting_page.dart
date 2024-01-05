// ignore_for_file: must_be_immutable

import 'package:chaty/features/chat/chat_controller.dart';
import 'package:chaty/features/chat/chat_helper.dart';
import 'package:chaty/features/chat/models/chat_model.dart';
import 'package:chaty/features/chat/models/last_position_model.dart';
import 'package:chaty/features/chat/models/message_model.dart';
import 'package:chaty/features/user/models/user_model.dart';
import 'package:chaty/features/user/pages/user_page.dart';
import 'package:chaty/utils/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ChattingPage extends StatefulWidget {
  final String chatId;
  final UserModel currentUserModel;
  final UserModel otherUserModel;

  ChattingPage({
    super.key,
    required this.currentUserModel,
    required this.otherUserModel,
    required this.chatId,
  });

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  late UserModel currentUserModel;
  late UserModel otherUserModel;
  late String chatId;

  final ChatController chatController = Get.put(ChatController());

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    currentUserModel = widget.currentUserModel;
    otherUserModel = widget.otherUserModel;
    chatId = widget.chatId;
  }

  // ! Create New Chat
  Future<ChatModel> createOrGetChat(String _chatId) async {
    if (_chatId != "") {
      final snapshot = await ChatHelper.getChat(_chatId);

      return ChatModel.fromSnapshot(snapshot);
    }

    ChatModel? _chatModel = await ChatHelper.createNewChat(
      currentUserId: currentUserModel.userId,
      otherUserId: otherUserModel.userId,
    );

    setState(() {
      chatId = _chatModel!.chatId;
    });

    return _chatModel!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: createOrGetChat(chatId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return FullScreenLoading();
        }

        final _chatModel = snapshot.data!;
        return Scaffold(
          extendBody: true,
          // @ App Bar
          appBar: AppBar(
            titleSpacing: 0,

            // @ User Avatar & Name
            title: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MyRoute(UserPage(
                    userModel: otherUserModel,
                    isMine: false,
                  )),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // @ User Avatar
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(otherUserModel.photoUrl),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),

                  // @ User Name
                  Text(
                    widget.otherUserModel.fullName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              // @ All Message
              Expanded(
                child: StreamBuilder(
                  stream: ChatHelper.getMessages(_chatModel.chatId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Ada kesalahan"),
                      );
                    }

                    final docs = snapshot.data!.docs;
                    // ! Scroll to Bottom
                    if (docs.isNotEmpty) {
                      chatController.setScrollController(
                        ScrollController(
                          initialScrollOffset: LastPositionModel(
                            userId: currentUserModel.userId,
                            lastPosition:
                                _chatModel.lastPosition.where((element) {
                              final aw = LastPositionModel.fromMap(element);

                              return aw.userId == currentUserModel.userId;
                            }).first['lastPosition'],
                          ).lastPosition.toDouble(),
                        ),
                      );
                    }
                    return NotificationListener<ScrollEndNotification>(
                      onNotification: (notification) {
                        updateLastPosition(
                          _chatModel.chatId,
                          notification.metrics.pixels,
                          _chatModel,
                        );

                        return false;
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListView.builder(
                          controller: chatController.scrollController,
                          itemCount: docs.length,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          itemBuilder: (context, index) {
                            MessageModel messageModel =
                                MessageModel.fromSnapshot(docs[index]);

                            // @ Message Bubble
                            return Align(
                              alignment: messageModel.senderId ==
                                      currentUserModel.userId
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: MessageBubble(
                                chatId: _chatModel.chatId,
                                otherUserId: otherUserModel.userId,
                                isMine: messageModel.senderId ==
                                    currentUserModel.userId,
                                messageModel: messageModel,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              // @ Message Field
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                  ),

                  // @ FORM
                  child: Form(
                    key: formKey,
                    child: Row(
                      children: [
                        // @ Text Field
                        Obx(
                          () => Expanded(
                            child: MyTextField(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.5)),
                              ),
                              autovalidateMode: AutovalidateMode.disabled,
                              controller: chatController.messageController,
                              hintText: "Masukkan pesan..",
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              maxLines: null,
                            ),
                          ),
                        ),

                        // @ Send Message Button
                        IconButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              sendMessage(
                                chatController,
                                chatId: _chatModel.chatId,
                                messageText: chatController
                                    .messageController.text
                                    .trim(),
                              );
                            }
                          },
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          icon: Icon(Icons.send),
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ! Scroll to Bottom
  void scrollToBottom(ScrollController scrollController) async {
    try {
      await scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    } catch (e) {
      print("GAGAL: $e");
    }
  }

  // ! Update last scroll position
  void updateLastPosition(
      String chatId, num position, ChatModel _chatModel) async {
    try {
      DocumentSnapshot snapshot =
          await ChatHelper.firestore.collection("chats").doc(chatId).get();
      final _chat = ChatModel.fromSnapshot(snapshot);
      final positions = _chat.lastPosition;
      positions[positions.indexWhere(
              (element) => element['userId'] == currentUserModel.userId)] =
          LastPositionModel(
                  userId: currentUserModel.userId, lastPosition: position)
              .toMap();

      await ChatHelper.firestore.collection("chats").doc(chatId).update({
        "lastPosition": positions,
      });
    } catch (e) {}
  }

  // ! Create Chat or Send Message
  void sendMessage(
    ChatController chatController, {
    required String chatId,
    required String messageText,
  }) async {
    String _text = chatController.messageController.text.trim();

    chatController.setMessageController(TextEditingController(text: ""));

    await ChatHelper.sendMessage(
      chatId: chatId,
      currentUserId: currentUserModel.userId,
      messageText: _text,
      position: chatController.scrollController.hasClients
          ? chatController.scrollController.position.maxScrollExtent
          : 0.0,
    );

    scrollToBottom(chatController.scrollController);
  }
}
