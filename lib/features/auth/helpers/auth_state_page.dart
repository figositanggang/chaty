import 'package:chaty/features/auth/pages/login_page.dart';
import 'package:chaty/features/chat/home/home_page.dart';
import 'package:chaty/main.dart';
import 'package:flutter/material.dart';

class AuthStatePage extends StatelessWidget {
  const AuthStatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.session != null) return HomePage();
        }

        return LoginPage();
      },
    );
  }
}
