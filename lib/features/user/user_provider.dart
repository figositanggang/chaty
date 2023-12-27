import 'package:chaty/features/user/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  UserModel? get currentUser => this._currentUser;

  set setCurrentUser(UserModel? value) {
    this._currentUser = value;
    notifyListeners();
  }
}
