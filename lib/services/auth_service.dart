import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devjang_class_market/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  // 비밀번호 재설정 이메일 보내기
  Future<List> sendResetPasswordEmail(String email) async {
    try {
      // Firebase 인증 언어를 한국어("ko")로 설정
      await FirebaseAuth.instance.setLanguageCode("ko");

      // 입력된 이메일 주소로 비밀번호 재설정 이메일 전송
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      return [true]; // 성공 시 true 반환
    } catch (e) {
      // 실패 시 에러 메시지를 포함하여 반환
      print('error sendResetPasswordEmail : ${e}');
      return [false, '${e}'];
    }
  }

  // 이메일과 비밀번호를 사용하여 로그인
  Future<List> login({required String email, required String password}) async {
    try {
      try {
        // Firebase에 이메일과 비밀번호로 로그인 시도
        UserCredential _cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email, password: password);

        // 로그인 성공 시 사용자 UID와 이메일을 반환
        return [true, _cred.user?.uid, _cred.user?.email];
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // 이메일이 존재하지 않는 경우 에러 메시지 반환
          return [false, '존재하지 않는 이메일입니다.'];
        } else if (e.code == 'wrong-password') {
          // 비밀번호가 틀린 경우 에러 메시지 반환
          return [false, '비밀번호 오류'];
        }
      }
      // 로그인 실패 시 메시지 반환
      return [false, '로그인 실패'];
    } catch (e) {
      // 예외 발생 시 에러 메시지 포함하여 반환
      print('error login ${e}');
      return [false, '${e}'];
    }
  }

  // 이메일과 비밀번호를 사용하여 회원가입
  Future<List> signUpWithEmail({
    required String email,
    required String password,
    required context,
  }) async {
    try {
      // Firebase에 이메일과 비밀번호로 회원가입 시도
      UserCredential _cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password);

      // 회원가입 성공 시 사용자 UID와 이메일 반환
      return [true, _cred.user?.uid, _cred.user?.email];
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        // 인증 자격 증명이 잘못되었을 때 메시지 반환
        print('The supplied auth credential is incorrect, malformed or has expired.');
        return [false, '인증 자격 증명이 잘못되었거나, 형식이 올바르지 않거나, 만료되었음'];
      } else if (e.code == 'weak-password') {
        // 비밀번호가 보안에 취약한 경우 메시지 반환
        return [false, '비밀번호가 보안에 취약합니다'];
      } else if (e.code == 'email-already-in-use') {
        // 이미 존재하는 이메일인 경우 메시지 반환
        return [false, '이미 존재하는 이메일'];
      }
      // 기타 오류 메시지 반환
      return [false, e.toString()];
    } catch (e) {
      // 예외 발생 시 에러 메시지 포함하여 반환
      print('on FirebaseAuthException catch (');
      return [false, e.toString()];
    }
  }

  // 로그아웃 함수
  Future logoutUser() async {
    // Firebase에서 로그아웃 수행
    await FirebaseAuth.instance.signOut();
  }

  // 전화번호로 사용자 정보 찾기
  Future<List> findId({required String phoneNumber}) async {
    try {
      // Firestore에서 'userCol' 컬렉션에서 전화번호가 일치하는 사용자 문서를 찾음
      var res = await FirebaseFirestore.instance.collection('userCol')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      if (res.docs.isNotEmpty) {
        // 일치하는 사용자가 있으면 사용자 데이터 반환
        List resList = res.docs;
        var data = resList.first;
        var dataMap = data.data();

        // UserClass 모델로 반환
        return [true, UserClass().returnUserClass(userMap: dataMap)];
      }

      // 일치하는 사용자가 없는 경우 에러 메시지 반환
      return [false, '등록되어 있지 않은 회원정보이거나, 잘못 입력하셨습니다.'];
    } catch (e) {
      // 예외 발생 시 에러 메시지 포함하여 반환
      print('error ceoFindId ${e}');
      return [false, '${e}'];
    }
  }

  Future<List> removeUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('userCol').doc('${user?.uid}').delete();
      return [true];
    } catch(e) {
      print("error removeUser : $e");
      return [false, e.toString()];
    }
  }
}
