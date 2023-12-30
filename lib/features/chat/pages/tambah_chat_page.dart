import 'package:chaty/features/chat/pages/chatting_page.dart';
import 'package:chaty/features/user/helpers/user_helper.dart';
import 'package:chaty/features/user/models/user_model.dart';
import 'package:chaty/main.dart';
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

  final currentUser = supabase.auth.currentUser!;

  List<UserModel> searchedUser = [];

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
          autofocus: true,
          hintText: "cari username...",
          maxLines: 1,
          validator: null,
          autovalidateMode: AutovalidateMode.disabled,
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          onChanged: (value) {
            setState(() {
              searchUsername(value);
            });
          },
        ),
      ),
      body: FutureBuilder(
        future: searchUsername(username.text.trim()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (searchedUser.isEmpty) {
            return Center(
              child: Icon(
                Icons.search,
                size: 100,
                color: Theme.of(context).primaryColor.withOpacity(.5),
              ),
            );
          }

          return ListView.builder(
            itemCount: searchedUser.length,
            itemBuilder: (context, index) {
              final otherUserModel = searchedUser[index];

              return ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MyRoute(ChattingPage(
                      currentUserModel: widget.currentUser,
                      otherUserModel: otherUserModel,
                    )),
                  );
                },
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(otherUserModel.photoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(otherUserModel.fullName),
                subtitle: MyText(
                  otherUserModel.username,
                  color: Colors.white.withOpacity(.5),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ! Search user with username
  Future<void> searchUsername(String text) async {
    if (text.isEmpty) return;

    List<UserModel> users = await UserHelper.getAllUsers();
    users.removeWhere((element) {
      return element.userId == currentUser.id;
    });

    if (users.isEmpty) return;

    List<UserModel> temp = [];

    for (var element in users) {
      if (element.username.contains(text)) {
        temp.add(element);
      }
    }

    searchedUser = temp.toSet().toList();
  }
}
