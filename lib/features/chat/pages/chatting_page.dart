// ignore_for_file: must_be_immutable

import 'package:chaty/features/chat/chat_helper.dart';
import 'package:chaty/features/chat/models/chat_model.dart';
import 'package:chaty/features/chat/models/message_model.dart';
import 'package:chaty/features/user/models/user_model.dart';
import 'package:chaty/utils/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  late TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    currentUserModel = widget.currentUserModel;
    otherUserModel = widget.otherUserModel;
    chatModel = widget.chatModel;

    messageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // @ App Bar
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // @ User Avatar
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
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
                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          MessageModel messageModel =
                              MessageModel.fromSnapshot(docs[index]);

                          return Align(
                            alignment:
                                messageModel.senderId == currentUserModel.userId
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            child: ChatBubble(messageModel: messageModel),
                          );
                        },
                      );
                    },
                  )
                : Text("Belum ada pesan"),
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
              child: Row(
                children: [
                  // @ Text Field
                  Expanded(
                    child: MyTextField(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.5)),
                      ),
                      controller: messageController,
                      hintText: "Masukkan pesan..",
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                    ),
                  ),

                  // @ Send Message Button
                  IconButton(
                    onPressed: () {
                      // ! Create New Chat
                      if (chatModel == null) {
                        ChatHelper.createNewChat(
                          otherUserId: otherUserModel.userId,
                          currentUserId: currentUserModel.userId,
                          messageText: messageController.text.trim(),
                        );
                      }

                      // ! Send Message
                      else {
                        ChatHelper.sendMessage(
                          chatId: chatModel!.chatId,
                          currentUserId: currentUserModel.userId,
                          messageText: messageController.text.trim(),
                        );
                      }
                    },
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    icon: Icon(Icons.send),
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
