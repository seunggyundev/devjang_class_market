import 'package:devjang_class_market/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _isUpdate = false;
  bool get isUpdate => _isUpdate;

  updateIsUpdate(bool isUpdate) {
    _isUpdate = isUpdate;
    notifyListeners();
  }

  UserClass _user = UserClass();
  get user => _user;

  updateUser(UserClass data) {
    print('update data :${data}');
    _user = data;
    notifyListeners();
  }
}