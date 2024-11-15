import 'package:firebase_auth/firebase_auth.dart';

import '../dialogs/cupertino_dialog.dart'; // 커스텀 다이얼로그 클래스 가져오기
import '../providers/registration_provider.dart'; // 등록 상태 관리 제공자 가져오기

class ValidatePhoneService {
  // 전화번호 인증을 시작하는 함수
  Future verificationPhoneNumber({
    required context,
    required String phoneNumber,
    required RegistrationProvider registrationProvider,
  }) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: const Duration(seconds: 60), // 인증 시간 제한 설정 (60초)

        // 인증이 자동으로 완료될 경우 실행될 함수
        verificationCompleted: (phoneAuthCredential) {
          // 이 부분은 자동 인증 완료 시의 처리 내용입니다.
        },

        // 인증 실패 시 실행될 함수
        verificationFailed: (verificationFailed) {
          // 인증 실패 메시지를 다이얼로그로 표시
          ReturnCupertinoDialog().onlyContentOneActionDialog(
            context: context,
            content: "인증이 실패하였습니다.",
            firstText: "확인",
          );
          print(verificationFailed.code); // 에러 코드 출력
        },

        // 인증 코드가 전송된 경우 실행될 함수
        codeSent: (verificationId, resendingToken) async {
          // 인증 코드 전송 완료 메시지 다이얼로그로 표시
          ReturnCupertinoDialog().onlyContentOneActionDialog(
            context: context,
            content: "인증코드를 발송하였습니다.",
            firstText: "확인",
          );

          // RegistrationProvider의 verificationId를 업데이트하여 저장
          registrationProvider.updateVerificationId(verificationId);
        },

        // 인증 코드 자동 회수가 실패할 경우 실행될 함수
        codeAutoRetrievalTimeout: (String verificationId) {
          // 자동 회수 타임아웃 시 처리 내용
        },

        // 휴대폰 번호를 국제 전화번호 형식으로 변환 (예: +821012341234)
        phoneNumber: phoneNumber.replaceRange(0, 0, '+82'),
      );
    } catch (e) {
      // 인증 과정에서 발생한 예외를 출력
      print('error verificationPhoneNumber $e');
    }
  }

  // 사용자가 입력한 인증 코드로 인증을 검증하는 함수
  Future<bool> checkAuthCode({
    required context,
    required verificationCode,
    required RegistrationProvider registrationProvider,
    required isAlertShow,
  }) async {
    // Firebase PhoneAuthCredential 객체를 생성하여 인증 코드와 함께 사용
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: registrationProvider.verificationId, // 저장된 verificationId 사용
      smsCode: '${verificationCode}', // 사용자가 입력한 인증 코드
    );

    // 인증 결과를 반환
    var res = await signInWithPhoneAuthCredential(
      phoneAuthCredential,
      context,
      registrationProvider: registrationProvider,
      isAlertShow: isAlertShow,
    );
    return res;
  }

  // 인증 자격 증명을 통해 사용자를 로그인 시키는 함수
  Future<bool> signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential,
      context, {
        required RegistrationProvider registrationProvider,
        required isAlertShow,
      }) async {
    try {
      // Firebase를 통해 인증 자격 증명을 사용하여 로그인 시도
      final authCredential = await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);

      if (isAlertShow) {
        if (authCredential.user != null) {
          // 로그인 성공 시, 사용자 인증 상태 업데이트
          registrationProvider.updatePhoneNumCerti(true);

          // 인증 성공 후 현재 사용자를 삭제 (임시 인증 계정 제거)
          await FirebaseAuth.instance.currentUser?.delete();
          FirebaseAuth.instance.signOut();
        }
      }

      return true; // 인증 성공 시 true 반환
    } on FirebaseAuthException catch (e) {
      // 인증 실패 시 예외 처리
      registrationProvider.updatePhoneNumCerti(false);

      // 인증 실패 다이얼로그 표시
      ReturnCupertinoDialog().onlyContentOneActionDialog(
        context: context,
        content: "휴대폰 인증에 실패하였습니다.",
        firstText: "확인",
      );

      print('인증실패'); // 실패 메시지 출력
      return false; // 인증 실패 시 false 반환
    }
  }
}
