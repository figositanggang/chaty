import 'package:chaty/features/auth/helpers/auth_helper.dart';
import 'package:chaty/features/chat/chat_helper.dart';
import 'package:chaty/features/chat/models/chat_model.dart';
import 'package:chaty/features/user/controllers/user_controller.dart';
import 'package:chaty/features/user/models/user_model.dart';
import 'package:chaty/features/chat/home/home-drawer.dart';
import 'package:chaty/features/chat/pages/new_chat_page.dart';
import 'package:chaty/utils/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chaty/main.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = supabase.auth.currentUser!;
  final UserController userController = Get.put(UserController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUser;

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
  }

  void refresh() {
    getCurrentUser = AuthHelper.firestore
        .collection("users")
        .doc(currentUser.id)
        .get()
        .then((value) {
      userController.setUserModel(UserModel.fromSnapshot(value));
      return value;
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return FullScreenLoading();
        }

        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Obx(
              () => Text(
                  "Halo ${userController.currentUser.fullName.split(" ")[0]}"),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
              ),
              SizedBox(width: 10),
            ],
          ),
          body: FutureBuilder(
            future: ChatHelper.getMyChats(currentUser.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text("Belum ada chats"),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text("Ada kesalahan"),
                );
              }

              // @ All My Chats
              final docs = snapshot.data!.docs;
              return RefreshIndicator(
                onRefresh: () async {
                  refresh();
                },
                child: ListView.builder(
                  itemCount: docs.length,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    try {
                      ChatModel? chatModel =
                          ChatModel.fromSnapshot(docs[index]);

                      return ChatCard(
                        chatModel: chatModel,
                        currentUserModel: userController.currentUser,
                      );
                    } catch (e) {
                      return Text("AW");
                    }
                  },
                ),
              );
            },
          ),
          drawer: HomeDrawer(scaffoldKey: scaffoldKey),
          drawerEdgeDragWidth: MediaQuery.sizeOf(context).width - 100,
          floatingActionButton: FloatingActionButton(
            tooltip: "Tambah chat",
            onPressed: () {
              Navigator.push(
                context,
                MyRoute(
                  TambahChatPage(
                    currentUser: userController.currentUser,
                  ),
                ),
              );
            },
            child: Icon(Icons.edit),
          ),
        );
      },
    );
  }
}
