import 'package:flutter/material.dart';

class EmailInputProvider extends ChangeNotifier {
  var _email;
  get email => _email;

  updateEmail(text) {
    if (text == "") {
      _email = null;
    } else {
      _email = text;
    }
    notifyListeners();
  }
}

class PasswordInputProvider extends ChangeNotifier {
  var _password;
  get password => _password;

  updatePassword(text) {
    if (text == "") {
      _password = null;
    } else {
      _password = text;
    }
    notifyListeners();
  }
}
