import 'package:chaty/features/auth/login_page.dart';
import 'package:chaty/features/chat/home_page.dart';
import 'package:chaty/main.dart';
import 'package:chaty/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthHelper {
  // ! Login With Google
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        "833031792575-n451mm7l2dndrs69mm61nluqj4ujfavj.apps.googleusercontent.com",
  );

  static Future<void> loginWithGoogle(BuildContext context) async {
    try {
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

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      Navigator.pushAndRemoveUntil(
          context, MyRoute(HomePage()), (route) => false);
    } catch (e) {
      throw e;
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
