import 'dart:math';

import 'package:chaty/customs/custom_widgets.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController email;

  @override
  void initState() {
    super.initState();

    email = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                MyText("Login", fontSize: 30),
                SizedBox(height: 20),
                MyTextField(
                  controller: email,
                  hintText: "Email",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
