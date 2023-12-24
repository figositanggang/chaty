import 'package:chaty/features/auth/auth_helper.dart';
import 'package:chaty/features/chat/home/home-drawer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Halo Figo"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(),
      drawer: HomeDrawer(),
      drawerEdgeDragWidth: MediaQuery.sizeOf(context).width - 100,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          AuthHelper.signOut(context);
        },
      ),
    );
  }
}
