import 'package:chaty/features/auth/auth_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Halo Figo"),
      ),
      body: SingleChildScrollView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          AuthHelper.signOut(context);
        },
      ),
    );
  }
}
