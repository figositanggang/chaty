// ignore_for_file: must_be_immutable

import 'package:chaty/features/chat/models/chat_model.dart';
import 'package:chaty/features/chat/models/message_model.dart';
import 'package:chaty/features/chat/pages/chatting_page.dart';
import 'package:chaty/features/user/helpers/user_helper.dart';
import 'package:chaty/features/user/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Stateless Widgets
// @ Button
class MyButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  bool isPrimary;
  Color? backgroundColor;
  BorderRadiusGeometry? borderRadius;

  MyButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isPrimary = true,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        backgroundColor: isPrimary
            ? backgroundColor ?? Theme.of(context).colorScheme.primary
            : Theme.of(context).buttonTheme.colorScheme!.background,
        foregroundColor: Colors.white,
        shape: !isPrimary
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                // side: BorderSide(color: Colors.white.withOpacity(.75)),
              )
            : null,
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
      stream: UserHelper.getUserData(otherUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            title: Text(""),
            minVerticalPadding: 25,
          );
        }

        final otherUserModel = UserModel.fromSnapshot(snapshot.data!);
        return UserCard(
          otherUserModel: otherUserModel,
          currentUserModel: currentUserModel,
          chatModel: chatModel,
        );
      },
    );
  }
}

// @ Message Bubble
class MessageBubble extends StatelessWidget {
  final MessageModel messageModel;

  // ! is this my chat or not
  final bool isMine;

  const MessageBubble({
    super.key,
    required this.messageModel,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(fontSize: 18),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isMine
              ? Theme.of(context).primaryColor.withOpacity(.75)
              : Theme.of(context).primaryColor.withOpacity(.15),
        ),
        child: Text(
          messageModel.messageText,
          style: TextStyle(color: Colors.white, height: 1.5),
        ),
      ),
    );
  }
}

// @ User Card
class UserCard extends StatelessWidget {
  final UserModel currentUserModel;
  final UserModel otherUserModel;
  final ChatModel chatModel;

  const UserCard({
    super.key,
    required this.otherUserModel,
    required this.currentUserModel,
    required this.chatModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        await Navigator.push(
          context,
          MyRoute(ChattingPage(
            chatModel: chatModel,
            currentUserModel: currentUserModel,
            otherUserModel: otherUserModel,
          )),
        );
      },
      leading: Container(
        height: 50,
        width: 50,
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
      title: Text(otherUserModel.fullName),
      subtitle: MyText(
        chatModel.lastMessage,
        color: Colors.white.withOpacity(.5),
        overflow: TextOverflow.ellipsis,
      ),
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
}) {
  return Text(
    text,
    overflow: overflow,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
    ),
  );
}

// @ MySnackBar
SnackBar MySnackBar(String content) {
  return SnackBar(
    content: Text(content),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
