import 'package:chaty/features/user/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}
