import 'package:chaty/features/user/controllers/user_controller.dart';
import 'package:chaty/features/user/models/user_model.dart';
import 'package:chaty/utils/custom_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ! Get All Users
  static Future<List<UserModel>> getAllUsers() async {
    List<UserModel> users = [];

    try {
      QuerySnapshot snapshot = await _firestore.collection("users").get();

      if (snapshot.docs.isNotEmpty) {
        users = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
      }
    } catch (e) {}

    return users;
  }

  // ! Stream User Data
  static Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserData(
      String userId) {
    return _firestore.collection("users").doc(userId).snapshots();
  }

  // ! Change User Avatar
  static Future changeUserAvatar(
    BuildContext context, {
    required String photoUrl,
    required UserController userController,
  }) async {
    try {
      showLoading(context);

      await _firestore
          .collection("users")
          .doc(userController.currentUser.userId)
          .update({"photoUrl": photoUrl});

      DocumentSnapshot snapshot = await _firestore
          .collection("users")
          .doc(userController.currentUser.userId)
          .get();

      userController.setUserModel(UserModel.fromSnapshot(snapshot));

      showSnackBar(context, "Berhasil ubah avatar");
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      showSnackBar(context, "Gagal ubah avatar");
      Navigator.pop(context);
    }
  }
}
