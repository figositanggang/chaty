import 'package:chaty/firebase_options.dart';
import 'package:chaty/customs/custom_theme.dart';
import 'package:chaty/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtucGZzbWt3aXVjanVlaHBmZXBhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDMyNzgxNjksImV4cCI6MjAxODg1NDE2OX0.Jr8sXBhJsR8t3pqQ3ORpgRdimJrreoLTVslYeFHD3tA",
    url: "https://knpfsmkwiucjuehpfepa.supabase.co",
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}
