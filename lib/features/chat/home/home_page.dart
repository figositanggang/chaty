import 'package:chaty/features/auth/auth_helper.dart';
import 'package:chaty/features/chat/chat_helper.dart';
import 'package:chaty/features/chat/models/chat_model.dart';
import 'package:chaty/features/user/controllers/user_controller.dart';
import 'package:chaty/features/user/models/user_model.dart';
import 'package:chaty/features/chat/home/home-drawer.dart';
import 'package:chaty/features/chat/tambah_chat_page.dart';
import 'package:chaty/utils/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chaty/main.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = supabase.auth.currentUser!;
  final UserController userController = Get.put(UserController());

  late Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUser;
  late Stream<QuerySnapshot<Map<String, dynamic>>> getMyChats;

  @override
  void initState() {
    super.initState();

    getCurrentUser = AuthHelper.firestore
        .collection("users")
        .doc(currentUser.id)
        .get()
        .then((value) {
      userController.setUserModel(UserModel.fromSnapshot(value));
      return value;
    });
    getMyChats = ChatHelper.getMyChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: kIsWeb ? true : false,
        title: FutureBuilder(
          future: getCurrentUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("");
            }

            UserModel userModel = UserModel.fromSnapshot(snapshot.data!);
            return Text("Halo ${userModel.fullName.split(" ")[0]}");
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder(
        stream: getMyChats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("Belum ada chats"),
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
              ChatModel chatModel = ChatModel.fromSnapshot(docs[index]);
              return ChatCard(
                chatModel: chatModel,
                currentUserId: currentUser.id,
              );
            },
          );
        },
      ),
      drawer: HomeDrawer(),
      drawerEdgeDragWidth: MediaQuery.sizeOf(context).width - 100,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MyRoute(
              TambahChatPage(
                currentUser: userController.userModel,
              ),
            ),
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
