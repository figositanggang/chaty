import 'package:chaty/features/auth/auth_helper.dart';
import 'package:chaty/features/auth/models/user_model.dart';
import 'package:chaty/features/chat/home/home-drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chaty/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = supabase.auth.currentUser!;

  late Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser =
        AuthHelper.firestore.collection("users").doc(currentUser.id).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Admin"),
            onTap: () {},
            minVerticalPadding: 25,
          );
        },
      ),
      drawer: HomeDrawer(),
      drawerEdgeDragWidth: MediaQuery.sizeOf(context).width - 100,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.edit),
      ),
    );
  }
}
