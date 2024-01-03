// ignore_for_file: must_be_immutable

import 'package:chaty/features/chat/chat_controller.dart';
import 'package:chaty/features/chat/chat_helper.dart';
import 'package:chaty/features/chat/models/chat_model.dart';
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
  ChatModel? chatModel;
  final UserModel currentUserModel;
  final UserModel otherUserModel;

  ChattingPage({
    super.key,
    required this.currentUserModel,
    required this.otherUserModel,
    this.chatModel,
  });

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  late UserModel currentUserModel;
  late UserModel otherUserModel;
  ChatModel? chatModel;

  final ChatController chatController = Get.put(ChatController());

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    currentUserModel = widget.currentUserModel;
    otherUserModel = widget.otherUserModel;
    chatModel = widget.chatModel;
  }

  @override
  Widget build(BuildContext context) {
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
            child: chatModel != null
                ? StreamBuilder(
                    stream: ChatHelper.getMessages(chatModel!.chatId),
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
                        chatController.setScrollController(ScrollController(
                            initialScrollOffset:
                                chatModel!.lastPosition.toDouble()));
                      }
                      return NotificationListener<ScrollEndNotification>(
                        onNotification: (notification) {
                          updateLasPosition(
                              chatModel!.chatId, notification.metrics.pixels);

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
                                  chatId: chatModel!.chatId,
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
                  )
                : Center(child: Text("Belum ada pesan")),
          ),

          // @ Message Field
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(.1),
                    offset: Offset(0, -4),
                    blurRadius: 20,
                  ),
                ],
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
                          onFieldSubmitted: (value) {
                            createOrSend(
                              chatController,
                              messageText: value.trim(),
                            );
                          },
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
                          createOrSend(
                            chatController,
                            messageText:
                                chatController.messageController.text.trim(),
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
  }

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
  void updateLasPosition(String chatId, num position) async {
    try {
      await ChatHelper.firestore.collection("chats").doc(chatId).update({
        "lastPosition": position,
      });
    } catch (e) {}
  }

  // ! Create Chat or Send Message
  void createOrSend(
    ChatController chatController, {
    required String messageText,
  }) async {
    chatController.setMessageController(TextEditingController(text: ""));
    try {
      // ! Send Message
      DocumentSnapshot snapshot = await ChatHelper.firestore
          .collection("chats")
          .doc(chatModel!.chatId)
          .get();

      ChatModel _chatModel = ChatModel.fromSnapshot(snapshot);

      await ChatHelper.sendMessage(
        chatId: _chatModel.chatId,
        currentUserId: currentUserModel.userId,
        messageText: messageText,
        position: chatController.scrollController.hasClients
            ? chatController.scrollController.position.maxScrollExtent
            : 0.0,
      );
    } catch (e) {
      // ! Create New Chat
      showDialog(
        context: context,
        builder: (context) => DialogLoading(),
      );

      ChatModel? _chatModel = await ChatHelper.createNewChat(
        otherUserId: otherUserModel.userId,
        currentUserId: currentUserModel.userId,
        messageModel: MessageModel(
          messageId: "",
          senderId: currentUserModel.userId,
          messageText: messageText,
          createdAt: Timestamp.now(),
          position: chatController.scrollController.hasClients
              ? chatController.scrollController.position.maxScrollExtent
              : 0.0,
        ),
      );

      Navigator.pop(context);

      setState(() {
        chatModel = _chatModel;
      });
    }

    scrollToBottom(chatController.scrollController);

    chatController.setMessageController(TextEditingController(text: ""));
  }
}
