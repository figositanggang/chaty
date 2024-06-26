// ignore_for_file: must_be_immutable

import 'package:chaty/features/chat/chat_helper.dart';
import 'package:chaty/features/chat/models/chat_model.dart';
import 'package:chaty/features/chat/models/message_model.dart';
import 'package:chaty/features/chat/pages/chatting_page.dart';
import 'package:chaty/features/user/helpers/user_helper.dart';
import 'package:chaty/features/user/models/user_model.dart';
import 'package:chaty/features/user/pages/user_page.dart';
import 'package:chaty/utils/custom_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Stateless Widgets
// @ Button
class MyButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  bool isPrimary;
  Color? backgroundColor;
  BorderRadiusGeometry? borderRadius;
  Color? foregroundColor;
  double? elevation;

  MyButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isPrimary = true,
    this.backgroundColor,
    this.borderRadius,
    this.foregroundColor = Colors.white,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        backgroundColor: isPrimary
            ? backgroundColor ?? Theme.of(context).colorScheme.primary
            : backgroundColor ??
                Theme.of(context).buttonTheme.colorScheme!.background,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(30),
        ),
      ),
    );
  }
}

// @ TextFormField
class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  bool obscureText;
  Function(String value)? onChanged;
  AutovalidateMode autovalidateMode;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  Iterable<String>? autofillHints;
  List<TextInputFormatter>? inputFormatters;
  String? Function(String? value)? validator;
  InputBorder? border;
  Widget? suffixIcon;
  int? maxLines;
  bool autofocus;
  void Function(String value)? onFieldSubmitted;

  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    this.inputFormatters,
    this.validator,
    this.border,
    this.suffixIcon,
    this.maxLines = 1,
    this.autofocus = false,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      controller: controller,
      maxLines: obscureText ? 1 : maxLines,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      validator: validator ??
          (value) {
            if (value!.isEmpty) {
              return "Masih kosong...";
            }

            return null;
          },
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        border: border ??
            OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(.25)),
              borderRadius: BorderRadius.circular(30),
            ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: border ??
            OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(.25)),
              borderRadius: BorderRadius.circular(30),
            ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

// @ Chat Card
class ChatCard extends StatelessWidget {
  final UserModel currentUserModel;
  final ChatModel chatModel;

  const ChatCard({
    super.key,
    required this.chatModel,
    required this.currentUserModel,
  });

  @override
  Widget build(BuildContext context) {
    String otherUserId = chatModel.users
        .where((element) => element != currentUserModel.userId)
        .first;

    return StreamBuilder(
      stream: UserHelper.streamUserData(otherUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("...");
        }

        if (!snapshot.hasData) {
          return Text("User ini telah dihapus");
        }

        final _otherUserModel = UserModel.fromSnapshot(snapshot.data!);
        Timestamp lastMessageCreatedAt = chatModel.lastMessage['createdAt'];
        return Material(
          elevation: 15,
          shadowColor: Colors.black.withOpacity(.5),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MyRoute(ChattingPage(
                  currentUserModel: currentUserModel,
                  otherUserModel: _otherUserModel,
                  chatId: chatModel.chatId,
                )),
              );
            },
            leading: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MyRoute(UserPage(
                    userModel: _otherUserModel,
                    isMine: false,
                  )),
                );
              },
              customBorder: CircleBorder(),
              child: Ink(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  image: DecorationImage(
                    image: NetworkImage(_otherUserModel.photoUrl),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            title: Text(_otherUserModel.fullName),
            subtitle: chatModel.lastMessage.isEmpty
                ? Text(_otherUserModel.username)
                : StreamBuilder(
                    stream: ChatHelper.streamChat(chatModel.chatId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("...");
                      }

                      final _chatModel = ChatModel.fromSnapshot(snapshot.data!);
                      return Text(
                        _chatModel.lastMessage['messageText'],
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.5),
                        ),
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
            trailing: Text(
              differenceDate(DateTime.now(), lastMessageCreatedAt.toDate()),
            ),
            tileColor: Theme.of(context).primaryColor.withOpacity(.1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            minVerticalPadding: 25,
          ),
        );
      },
    );
  }
}

// @ Message Bubble
class MessageBubble extends StatelessWidget {
  final String chatId;
  final String otherUserId;
  final MessageModel messageModel;

  // ! is this my chat or not
  final bool isMine;

  MessageBubble({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.messageModel,
    required this.isMine,
  });

  final format = DateFormat("d/M/y");

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                contentPadding: EdgeInsets.zero,
                children: [
                  // @ Copy Message Button
                  MyButton(
                    onPressed: () async {
                      await Clipboard.setData(
                          ClipboardData(text: messageModel.messageText));
                      showSnackBar(context, "Pesan disalin");

                      Navigator.pop(context);
                    },
                    isPrimary: false,
                    borderRadius: BorderRadius.zero,
                    child: Text("Salin pesan"),
                  ),
                  Divider(height: 0),

                  // @ Delete Message Button
                  MyButton(
                    onPressed: () async {
                      await ChatHelper.deleteMessage(
                        userId: messageModel.senderId,
                        otherUserId: otherUserId,
                        chatId: chatId,
                        messageId: messageModel.messageId,
                      );

                      Navigator.pop(context);
                    },
                    isPrimary: false,
                    borderRadius: BorderRadius.zero,
                    child: Text("Hapus pesan"),
                    foregroundColor: Colors.red,
                  ),
                  Divider(height: 0),
                ],
              ),
            );
          },
          child: DefaultTextStyle(
            style: TextStyle(
                fontSize: 18, color: isMine ? Colors.black : Colors.white),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: EdgeInsets.symmetric(vertical: 5),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width - 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: isMine
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(.5),
                          offset: Offset(-2, 2),
                          blurRadius: 15,
                        ),
                      ]
                    : [],
                color: isMine ? Colors.white : Colors.white.withOpacity(.1),
              ),
              child: Column(
                crossAxisAlignment:
                    isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // @ Message Text
                  Text(
                    messageModel.messageText,
                    style: TextStyle(height: 1.5),
                  ),
                  SizedBox(height: 5),

                  // @ Message Created At
                  Text(
                    "${messageModel.createdAt.toDate().hour}:${messageModel.createdAt.toDate().minute}",
                    style: TextStyle(
                      color: isMine
                          ? Colors.black.withOpacity(.5)
                          : Colors.white.withOpacity(.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // @ Message Date
        Container(
          margin: isMine
              ? EdgeInsets.only(right: 7, bottom: 5)
              : EdgeInsets.only(left: 7, bottom: 5),
          child: Text(
            format.format(messageModel.createdAt.toDate()),
            style: TextStyle(color: Colors.white.withOpacity(.5)),
          ),
        ),
      ],
    );
  }
}

// Non Stateless Widgets

// @ My Route
PageRouteBuilder MyRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

// @ Size Text
Text MyText(
  String text, {
  double? fontSize,
  FontWeight? fontWeight,
  double? letterSpacing,
  Color? color,
  TextOverflow? overflow,
  int? maxLines,
}) {
  return Text(
    text,
    overflow: overflow,
    maxLines: maxLines,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
    ),
  );
}

// @ MySnackBar
SnackBar MySnackBar(
  String content, {
  Duration duration = const Duration(seconds: 1),
  Color? backgroundColor,
}) {
  return SnackBar(
    content: Text(content),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    duration: duration,
    backgroundColor: backgroundColor,
  );
}

// @ Full Screen Loading
Material FullScreenLoading() {
  return Material(
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

// @ Dialog Loading
Widget DialogLoading() {
  return Dialog(
    child: Center(
      child: CircularProgressIndicator(),
      heightFactor: 3,
      widthFactor: 1,
    ),
  );
}
