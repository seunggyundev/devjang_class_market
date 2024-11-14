import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class UserServices {
  Future<List> getUserData(String uid) async {
    try {
      if (uid.isEmpty) {
        return [true, UserClass()];
      }
      var res = await FirebaseFirestore.instance.collection('userCol').doc(uid).get();
      if (res.exists) {
        UserClass userClass = UserClass().returnUserClass(userMap: res.data());
        return [true, userClass];
      } else {
        return [false, '유저정보가 존재하지 않습니다.'];
      }
    } catch(e) {
      print("error getUserData $e");
      return [false, e.toString()];
    }
  }

  Future<List> registUser({
  required String phoneNumber,
    required String nickName,
    required String email,
    required String pw,
}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('userCol').doc('${user?.uid}').set({
        'uid': '${user?.uid}',
        'phoneNumber': phoneNumber,
        'nickName': nickName,
        'point' : 0,
        'account': '',
        'address': '',
        'bank': '',
        'detailAddress': '',
        'email': email,
        'pw': pw,
      });
      return [true];
    } catch(e) {
      print("error registUser $e");
      return [false, e.toString()];
    }
  }
}