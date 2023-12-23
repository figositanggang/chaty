import 'package:chaty/features/auth/login_page.dart';
import 'package:chaty/features/chat/home_page.dart';
import 'package:chaty/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthStatePage extends StatelessWidget {
  const AuthStatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        print(snapshot.data!.event);
        if (snapshot.hasData &&
            snapshot.data!.event == AuthChangeEvent.signedIn) {
          return HomePage();
        }

        return LoginPage();
      },
    );
  }
}
