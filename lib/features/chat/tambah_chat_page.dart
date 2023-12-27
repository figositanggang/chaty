import 'package:chaty/features/user/models/user_model.dart';
import 'package:chaty/utils/custom_widgets.dart';
import 'package:flutter/material.dart';

class TambahChatPage extends StatefulWidget {
  final UserModel currentUser;

  const TambahChatPage({super.key, required this.currentUser});

  @override
  State<TambahChatPage> createState() => _TambahChatPageState();
}

class _TambahChatPageState extends State<TambahChatPage> {
  late TextEditingController username;

  @override
  void initState() {
    super.initState();

    username = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyTextField(
          controller: username,
          hintText: "Masukkan username",
          maxLines: 1,
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      ),
    );
  }
}
