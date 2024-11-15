import 'package:devjang_class_market/dialogs/cupertino_dialog.dart';
import 'package:devjang_class_market/models/user_model.dart';
import 'package:devjang_class_market/providers/registration_provider.dart';
import 'package:devjang_class_market/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../models/colors_model.dart';
import '../services/auth_service.dart';
import '../services/validate_phone_service.dart';

class FindIdPage extends StatefulWidget {
  const FindIdPage({Key? key}) : super(key: key);

  @override
  State<FindIdPage> createState() => _FindIdPageState();
}

class _FindIdPageState extends State<FindIdPage> {
  ColorsModel _colorsModel = ColorsModel();
  TextEditingController _representController = TextEditingController();
  TextEditingController _ceoNumController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _phoneNumController = TextEditingController();
  TextEditingController _authCodeController = TextEditingController();
  TextEditingController _householderNameController = TextEditingController();

  RegistrationProvider _registrationProvider = RegistrationProvider();
  UserClass _userClass = UserClass();
  bool _isResultPage = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _representController = TextEditingController();
    _ceoNumController = TextEditingController();
    _phoneNumController = TextEditingController();
    _authCodeController = TextEditingController();
    _householderNameController = TextEditingController();

    _idController.addListener(() {
      setState(() {
      });
    });
    _representController.addListener(() {
      setState(() {
      });
    });
    _ceoNumController.addListener(() {
      setState(() {
      });
    });
    _phoneNumController.addListener(() {
      setState(() {
      });
    });
    _authCodeController.addListener(() {
      setState(() {
      });
    });
    _householderNameController.addListener(() {
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    _representController.dispose();
    _ceoNumController.dispose();
    _phoneNumController.dispose();
    _authCodeController.dispose();
    _householderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _registrationProvider = Provider.of<RegistrationProvider>(context, listen: true);

    var screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: _colorsModel.white,
          appBar: AppBar(
            toolbarHeight: 48.4,
            elevation: 0,
            backgroundColor: _colorsModel.white,
            leading: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset("assets/icons/arrowLeft.png",
                        color: _colorsModel.bl,))),
            ),
            title: Text('아이디 찾기', style: TextStyle(fontSize: 16.sp,
                color: _colorsModel.bl),),
            leadingWidth: 40,
            centerTitle: true,
          ),
          body: Stack(
            children: [
              _isResultPage ? IdResultPage(userClass: _userClass) : phoneAuthWidget(screenWidth),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0, left: 15, right: 15),
                    child: GestureDetector(
                      onTap: () async {
                        if (_isResultPage) {
                          Navigator.pushNamed(context, '/LoginPage');
                        } else {
                          if (_registrationProvider.isPhoneNumCerti) {
                            setState(() {
                              _isResultPage = true;
                            });
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _colorsModel.main,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: screenWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                _isResultPage ? '로그인 하러가기' : '다음',
                                style: TextStyle(
                                  color: _colorsModel.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              _loading ? Center(child: CircularProgressIndicator(color: _colorsModel.main,),) : Container(),
            ],
          ),
        ));
  }

  Widget phoneAuthWidget(screenWidth) {

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('전화번호', style: TextStyle(
            fontSize: 14.sp,
            color: _colorsModel.bl,
          ),),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: screenWidth - 160.w,
                child: textFieldWidget(_phoneNumController, '전화번호를 입력해주세요'),
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    _loading = true;
                  });
                  var inputValue = _phoneNumController.text;
                  if (_phoneNumController.text.contains(' ')) {
                    inputValue = _phoneNumController.text.replaceAll(' ', '');
                  }
                  if (_phoneNumController.text.contains('-')) {
                    inputValue = _phoneNumController.text.replaceAll('-', '');
                  }
                  await ValidatePhoneService().verificationPhoneNumber(context: context, phoneNumber: inputValue, registrationProvider: _registrationProvider);
                  setState(() {
                    _loading = false;
                  });
                },
                child: Container(
                  width: 120.w,
                  height: 42.h,
                  decoration: BoxDecoration(
                    color: _phoneNumController.text.isEmpty ? _colorsModel.loginContanierColor : _colorsModel.main,
                    border: Border.all(color: _phoneNumController.text.isEmpty ? _colorsModel.lightGrey : _colorsModel.main),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text('인증번호', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: _phoneNumController.text.isEmpty ? _colorsModel.deepGrey : _colorsModel.white),)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Text('인증번호', style: TextStyle(
            fontSize: 14.sp,
            color: _colorsModel.bl,
          ),),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: screenWidth - 160.w,
                child: textFieldWidget(_authCodeController, '인증번호를 입력해주세요'),
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    _loading = true;
                  });

                  bool isClear = await ValidatePhoneService().checkAuthCode(context: context, verificationCode: _authCodeController.text.toString(), registrationProvider: _registrationProvider, isAlertShow: true);

                  if (isClear) {
                    // 전화번호를 통해 유저정보 가져오기
                    List resList = await AuthService().findId(phoneNumber: _phoneNumController.text);
                    setState(() {
                      _loading = false;
                    });

                    if (resList.first) {
                      setState(() {
                        _userClass = resList.last;
                      });
                      ReturnCupertinoDialog().onlyContentOneActionDialog(context: context, content: '인증이 완료되었습니다.', firstText: '확인');
                    } else {
                      ReturnCupertinoDialog().onlyContentOneActionDialog(context: context, content: '${resList.last}', firstText: '확인');
                    }
                  } else {
                    setState(() {
                      _loading = false;
                    });
                  }
                },
                child: Container(
                  width: 120.w,
                  height: 42.h,
                  decoration: BoxDecoration(
                    color: _authCodeController.text.isEmpty ? _colorsModel.loginContanierColor : _colorsModel.main,
                    border: Border.all(color: _authCodeController.text.isEmpty ? _colorsModel.lightGrey : _colorsModel.main),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text('확인', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: _authCodeController.text.isEmpty ? _colorsModel.deepGrey : _colorsModel.white),)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget textFieldWidget(
      TextEditingController textEditingController,
      String hintText,
      ) {

    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          textDirection: TextDirection.ltr,
          cursorColor: _colorsModel.main,
          controller: textEditingController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: _colorsModel.bl,
            fontSize: 16.sp,
          ),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            filled: true,
            fillColor: _colorsModel.loginContanierColor,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 16, color: _colorsModel.deepGrey),
            helperStyle: TextStyle(fontSize: 11.sp, color: _colorsModel.lightGrey),
            border: InputBorder.none,
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _colorsModel.lightGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              // borderSide: BorderSide.none,
              borderSide: BorderSide(
                color: _colorsModel.lightGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _colorsModel.main,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _colorsModel.lightGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _colorsModel.lightGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class IdResultPage extends StatelessWidget {
  final ColorsModel _colorsModel = ColorsModel();
  final UserClass userClass;

  IdResultPage({Key? key, required this.userClass}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          const SizedBox(height: 30,),
          Text('해당 정보와 일치하는 아이디입니다.', style: TextStyle(
            fontSize: 16.sp,
            color: _colorsModel.bl,
          ),),
          const SizedBox(height: 15,),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: _colorsModel.plusLightGrey,
              border: Border.all(color: _colorsModel.lightGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Center(
                child: Text('${userClass.email}', style: TextStyle(
                  fontSize: 16.sp,
                  color: _colorsModel.bl,
                ),),
              ),
            ),
          ),
          const SizedBox(height: 40,),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/FindPasswordPage');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('비밀번호 찾기', style: TextStyle(
                  fontSize: 14.sp,
                  color: _colorsModel.main,
                ),),
                const SizedBox(width: 5,),
                SizedBox(width: 16.w, height: 16.h,
                child: Image.asset('assets/icons/caretRight.png'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

