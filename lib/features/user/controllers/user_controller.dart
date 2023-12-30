import 'package:chaty/features/user/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rx<UserModel> _currentUser = UserModel(
    userId: "",
    username: "",
    email: "",
    fullName: "",
    createdAt: Timestamp.now(),
  ).obs;

  UserModel get currentUser => _currentUser.value;

  void setUserModel(UserModel value) {
    _currentUser.value = value;
  }
}
