// ignore_for_file: must_be_immutable

import 'package:chaty/features/chat/chat_controller.dart';
import 'package:chaty/features/chat/chat_helper.dart';
import 'package:chaty/features/chat/models/chat_model.dart';
import 'package:chaty/features/chat/models/message_model.dart';
import 'package:chaty/features/user/models/user_model.dart';
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
          onTap: () {},
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

    // ! Create New Chat
    if (chatModel == null) {
      ChatModel? _chatModel = await ChatHelper.createNewChat(
        otherUserId: otherUserModel.userId,
        currentUserId: currentUserModel.userId,
        messageModel: MessageModel(
          senderId: currentUserModel.userId,
          messageText: messageText,
          createdAt: Timestamp.now(),
          position: chatController.scrollController.hasClients
              ? chatController.scrollController.position.maxScrollExtent
              : 0.0,
        ),
      );

      setState(() {
        chatModel = _chatModel;
      });
    }

    // ! Send Message
    else {
      await ChatHelper.sendMessage(
        chatId: chatModel!.chatId,
        currentUserId: currentUserModel.userId,
        messageText: messageText,
        position: chatController.scrollController.hasClients
            ? chatController.scrollController.position.maxScrollExtent
            : 0.0,
      );
    }

    scrollToBottom(chatController.scrollController);

    chatController.setMessageController(TextEditingController(text: ""));
  }
}

// Hello young lady, can we talk?

// Jadi gini...
// Kenapa aku kemarin add friend kamu di facebook...
// Kenapa aku ngechat kamu panjang2, ngajak jalan, dan lain-lain...
// Ya tentu karena aku tertarik sama kamu
// Jadi aku memberanikan diri untuk mendekati kamu
// Nah, kenapa aku mau memberanikan diri untuk mendekati kamu?
// Karena aku ngeliat kamu juga seperti tertarik kepadaku
// Nah sekarang, yang ini betul gk?

//? Jika betul
// Nah, kan kalo orang sama2 suka biasa mereka pacaran kan..
// Tapi aku belum mau pacaran, karena aku masih belum menghasilkan apa2, masih dibiayai orang tua
// Jadi aku memutuskan untuk tidak mengajakmu berpacaran
// Aku mau kita berteman seperti biasa, mengenal satu sama lain
// 
// Nanti, kalo kamu jumpa dengan lelaki yang suka samamu dan sebaliknya, tidak apa-apa jika kalian berhubungan atau berpacaran
// Yang penting sudah ada kepastian
// ..

//? Jika salah
// Oh maaf kalo aku sudah berpikiran seperi itu
// Hanya memastikan saja
// Biar gk sukkun2 roha ini wkwk
