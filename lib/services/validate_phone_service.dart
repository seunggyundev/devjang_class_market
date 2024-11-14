
import 'package:firebase_auth/firebase_auth.dart';

import '../dialogs/cupertino_dialog.dart';
import '../providers/registration_provider.dart';

class ValidatePhoneService {
  Future verificationPhoneNumber({required context, required String phoneNumber, required RegistrationProvider registrationProvider,}) async {
       try {
         await FirebaseAuth.instance.verifyPhoneNumber(
           timeout: const Duration(seconds: 60),
           verificationCompleted: (phoneAuthCredential) {
           },
           verificationFailed: (verificationFailed) {
             ReturnCupertinoDialog().onlyContentOneActionDialog(
               context: context,
               content: "인증이 실패하였습니다.",
               firstText: "확인",
             );
             print(verificationFailed.code);
           },
           codeSent: (verificationId, resendingToken) async {
             ReturnCupertinoDialog().onlyContentOneActionDialog(
               context: context,
               content: "인증코드를 발송하였습니다.",
               firstText: "확인",
             );

             registrationProvider.updateVerificationId(verificationId);
           },
           codeAutoRetrievalTimeout: (String verificationId) {},
           phoneNumber: phoneNumber.replaceRange(0, 0, '+82'),  // '+821012341234' 형태
         );
       } catch(e) {
         print('error verificationPhoneNumber $e');

       }
  }

  Future checkAuthCode({required context, required verificationCode, required RegistrationProvider registrationProvider,required isAlertShow}) async {
        PhoneAuthCredential phoneAuthCredential =
        PhoneAuthProvider.credential(
                verificationId: registrationProvider.verificationId, smsCode: '${verificationCode}');

        var res = await signInWithPhoneAuthCredential(phoneAuthCredential, context, registrationProvider: registrationProvider, isAlertShow: isAlertShow);
        return res;
      }

  Future<bool> signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential, context, {required RegistrationProvider registrationProvider,required isAlertShow}) async {
        try {
            final authCredential = await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
            if (isAlertShow) {
              if (authCredential.user != null) {
                registrationProvider.updatePhoneNumCerti(true);
                ReturnCupertinoDialog().onlyContentOneActionDialog(
                    context: context,
                    content: "가입이 완료되었습니다.",
                    firstText: "확인",
                );
              }
            } else {

            }
            return true;
          } on FirebaseAuthException catch(e) {
            registrationProvider.updatePhoneNumCerti(false);
            ReturnCupertinoDialog().onlyContentOneActionDialog(
                context: context,
                content: "가입(휴대폰 인증)에 실패하였습니다.",
                firstText: "확인",
            );
            return false;
            print('인증실패');
          }

      }
}