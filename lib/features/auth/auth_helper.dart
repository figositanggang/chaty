import 'package:chaty/features/auth/auth_state_page.dart';
import 'package:chaty/features/auth/login_page.dart';
import 'package:chaty/features/auth/models/user_model.dart';
import 'package:chaty/features/chat/home/home_page.dart';
import 'package:chaty/main.dart';
import 'package:chaty/utils/custom_methods.dart';
import 'package:chaty/utils/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthHelper {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        "833031792575-n451mm7l2dndrs69mm61nluqj4ujfavj.apps.googleusercontent.com",
  );
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ! Login With Email
  static Future<void> loginWithEmail(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      showLoading(context);

      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      Navigator.pushAndRemoveUntil(
          context, MyRoute(AuthStatePage()), (route) => false);
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnackBar("Email atau password salah"));
    }
  }

  // ! Login With Google
  static Future<void> loginWithGoogle(BuildContext context) async {
    try {
      showLoading(context);

      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw "No Access Token";
      }
      if (idToken == null) {
        throw "No Id Token";
      }

      AuthResponse authResponse = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      User user = authResponse.user!;

      DateTime createdAt = DateTime.parse(user.createdAt);

      DocumentSnapshot snapshot =
          await _firestore.collection("users").doc(user.id).get();

      if (!snapshot.exists) {
        await _firestore.collection("users").doc(user.id).set(
              UserModel(
                userId: user.id,
                username: "",
                email: user.email!,
                fullName: user.userMetadata!["full_name"] ?? "",
                createdAt: Timestamp.fromDate(createdAt),
              ).toJson(),
            );
      }

      Navigator.pushAndRemoveUntil(
          context, MyRoute(HomePage()), (route) => false);
    } catch (e) {
      Navigator.pop(context);
      throw e;
    }
  }

  // ! Register With Email
  static Future<void> registerWithEmail(
    BuildContext context, {
    required String email,
    required String username,
    required String full_name,
    required String password,
  }) async {
    try {
      showLoading(context);

      await supabase.auth.signUp(
        email: email,
        password: password,
        data: {"username": username, "full_name": full_name},
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(MySnackBar("Silahkan verifikasi email anda"));

      Navigator.pushAndRemoveUntil(
          context, MyRoute(LoginPage()), (route) => false);
    } catch (e) {
      Navigator.pop(context);
      print("GAGAL DAFTAR: $e");
    }
  }

  // ! Sign Out
  static Future<void> signOut(BuildContext context) async {
    try {
      await supabase.auth.signOut();
      await _googleSignIn.signOut();

      Navigator.pushAndRemoveUntil(
          context, MyRoute(LoginPage()), (route) => false);
    } catch (e) {}
  }
}
