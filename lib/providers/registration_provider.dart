import 'package:flutter/material.dart';

class RegistrationProvider extends ChangeNotifier {
  // 이메일
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

  // 비밀번호
  var _password;
  get password => _password;

  updatePassword(password) {
    if (password == "") {
      _password = null;
    } else {
      _password = password;
    }
    notifyListeners();
  }

  // 비밀번호 확인
  var _confirmPassword;
  get confirmPassword => _confirmPassword;

  updateConfirmPassword(confirmPassword) {
    if (confirmPassword == "") {
      _confirmPassword = null;
    } else {
      _confirmPassword = confirmPassword;
    }
    notifyListeners();
  }

  // 휴대폰 인증여부
  bool _isPhoneNumCerti = false;
  bool get isPhoneNumCerti => _isPhoneNumCerti;

  updatePhoneNumCerti(bool) {
    _isPhoneNumCerti = bool;
    notifyListeners();
  }

  // 인증ID
  var _verificationId;
  get verificationId => _verificationId;

  updateVerificationId(id) {
    if (id == "") {
      _verificationId = null;
    } else {
      _verificationId = id;
    }
    notifyListeners();
  }
}