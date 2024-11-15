import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class UserServices {

  // 사용자 데이터를 Firestore에서 가져오는 함수
  Future<List> getUserData(String uid) async {
    try {
      // UID가 비어 있는 경우, 기본값으로 빈 UserClass 객체 반환
      if (uid.isEmpty) {
        return [true, UserClass()];
      }

      // Firestore에서 'userCol' 컬렉션에서 uid에 해당하는 사용자 문서 가져오기
      var res = await FirebaseFirestore.instance.collection('userCol').doc(uid).get();

      // 문서가 존재하면 데이터를 UserClass 객체로 변환하여 반환
      if (res.exists) {
        UserClass userClass = UserClass().returnUserClass(userMap: res.data());
        return [true, userClass];
      } else {
        // 문서가 존재하지 않으면 에러 메시지 반환
        return [false, '유저정보가 존재하지 않습니다.'];
      }
    } catch (e) {
      // 예외 발생 시 에러 메시지 포함하여 반환
      print("error getUserData $e");
      return [false, e.toString()];
    }
  }

  // Firestore에 새로운 사용자를 등록하는 함수
  Future<List> registUser({
    required String phoneNumber,
    required String nickName,
    required String email,
    required String pw,
  }) async {
    try {
      // Firebase 인증을 통해 현재 로그인된 사용자 가져오기
      User? user = FirebaseAuth.instance.currentUser;

      // Firestore의 'userCol' 컬렉션에 사용자 UID를 문서 ID로 하여 사용자 정보 저장
      await FirebaseFirestore.instance.collection('userCol').doc('${user?.uid}').set({
        'uid': '${user?.uid}',       // UID 저장
        'phoneNumber': phoneNumber,   // 전화번호 저장
        'nickName': nickName,         // 닉네임 저장
        'point' : 0,                  // 초기 포인트 설정
        'account': '',                // 계좌 정보 (빈 값)
        'address': '',                // 주소 (빈 값)
        'bank': '',                   // 은행 (빈 값)
        'detailAddress': '',          // 상세 주소 (빈 값)
        'email': email,               // 이메일 저장
        'pw': pw,                     // 비밀번호 저장 (안전성 고려 시 암호화 필요)
      });

      return [true]; // 성공 시 true 반환
    } catch (e) {
      // 예외 발생 시 에러 메시지 포함하여 반환
      print("error registUser $e");
      return [false, e.toString()];
    }
  }
}
