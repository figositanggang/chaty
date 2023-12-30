import 'package:chaty/features/chat/chat_helper.dart';
import 'package:chaty/features/chat/models/chat_model.dart';
import 'package:chaty/features/chat/models/message_model.dart';
import 'package:chaty/features/user/models/user_model.dart';
import 'package:chaty/utils/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class ChattingPage extends StatefulWidget {
  final UserModel currentUserModel;
  final UserModel otherUserModel;
  const ChattingPage({
    super.key,
    required this.currentUserModel,
    required this.otherUserModel,
  });

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  late UserModel currentUserModel;
  late UserModel otherUserModel;

  late TextEditingController messageController;

  late Future<QuerySnapshot<Map<String, dynamic>>> getChatData;

  @override
  void initState() {
    super.initState();
    currentUserModel = widget.currentUserModel;
    otherUserModel = widget.otherUserModel;

    getChatData =
        ChatHelper.getChatData(currentUserModel.userId, otherUserModel.userId);

    messageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ChatModel? chatModel;

    return FutureBuilder(
      future: ChatHelper.getChatData(
          currentUserModel.userId, otherUserModel.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return FullScreenLoading();
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          chatModel = ChatModel.fromSnapshot(snapshot.data!.docs[0]);
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.otherUserModel.fullName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          body: Column(
            children: [
              // @ All Message
              Expanded(
                child: StreamBuilder(
                  stream: ChatHelper.getMessages(currentUserModel.userId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return SizedBox();
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
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: ChatBubble(messageModel: messageModel),
                        );
                      },
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
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.5)),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
      },
    );
  }
}
