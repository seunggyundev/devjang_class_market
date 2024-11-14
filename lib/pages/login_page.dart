import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devjang_class_market/dialogs/cupertino_dialog.dart';
import 'package:devjang_class_market/providers/validate_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../models/colors_model.dart';
import '../providers/registration_provider.dart';
import '../services/auth_service.dart';
import '../services/user_services.dart';
import '../services/validate.dart';
import '../services/validate_phone_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ColorsModel _colorsModel = ColorsModel();
  bool _loading = false;

  bool _isPasswordShow = false;
  ValidateProvider _validateProvider = ValidateProvider();

  late TextEditingController _passwordController;  // 비밀번호 Controller
  late TextEditingController _emailController;  // 이메일 Controller

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController.addListener(() {
      setState(() {
      });
    });
    _passwordController.addListener(() {
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _validateProvider = Provider.of<ValidateProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 40.h,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        leadingWidth: 39,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15.0.w, right: 15.w),
        child: Stack(
          children: [
            ListView(
              physics: ScrollPhysics(),
              children: [
                SizedBox(height: 100.h,),
                Center(child: Text('로그인', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: _colorsModel.darkBlack,),textAlign: TextAlign.center,)),
                SizedBox(height: 100.h,),
                Text('아이디', style: TextStyle(
                  fontSize: 14,
                  color: _colorsModel.bl,
                ),),
                const SizedBox(height: 10,),
                textFieldWidget(_emailController, '아이디를 입력해주세요.',),
                Text('비밀번호', style: TextStyle(
                  fontSize: 14,
                  color: _colorsModel.bl,
                ),),
                const SizedBox(height: 10,),
                textFieldWidget(_passwordController, '비밀번호를 입력해주세요.',),
                const SizedBox(height: 10,),
                SizedBox(height: 20.h,),
                GestureDetector(
                  onTap: () async {
                    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                      setState(() {
                        _loading = true;
                      });

                      List authResList = await AuthService().login(email: _emailController.text, password: _passwordController.text);

                      if (authResList.first) {
                        List resList = await UserServices().getUserData(authResList[1].toString());
                        setState(() {
                          _loading = false;
                        });
                        if (resList.first) {
                          Navigator.pushNamed(context, '/');
                        } else {
                          ReturnCupertinoDialog().onlyContentOneActionDialog(context: context, content: '유저정보 로드 오류\n${authResList.last}', firstText: '확인');
                        }
                      } else {
                        setState(() {
                          _loading = false;
                        });
                        ReturnCupertinoDialog().onlyContentOneActionDialog(context: context, content: '로그인 오류\n${authResList.last}', firstText: '확인');
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _colorsModel.main,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 49.h,
                    child: Center(
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h,),
                Center(child: Text('계정이 아직 없으신가요?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _colorsModel.darkBlack),)),
                SizedBox(height: 5.h,),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/UserRegiPage');
                  },
                  child: Column(
                    children: [
                      Text('회원가입', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _colorsModel.main), textAlign: TextAlign.center,),
                      Container(height: 1.h, color: _colorsModel.main, width: 80.w,),
                    ],
                  ),
                ),
                SizedBox(height: 200.h,),
              ],
            ),
            _loading ? Center(child: CircularProgressIndicator(color: _colorsModel.main,),) : Container(),
          ],
        ),
      ),
    );
  }

  Widget textFieldWidget(
      TextEditingController textEditingController,
      String hintText,
      ) {

    bool _isPassword = false;
    bool _isEye = false;
    bool _isRed = false;
    String _helperText = '';
    if (textEditingController == _passwordController) {
      _isPassword = true;
    }

    if (textEditingController == _passwordController && _isPasswordShow) {
      _isEye = true;
    }

    if (!_validateProvider.passwordValidate && _passwordController.text.isNotEmpty) {
      _isRed = true;
      _helperText = '비밀번호 형식이 맞지 않습니다.(12자/영어 소문자,특수문자 포함)';
    }

    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          textDirection: TextDirection.ltr,
          cursorColor: _colorsModel.main,
          controller: textEditingController,
          obscureText: _isPassword && !_isEye ? true : false,
          onChanged: (text) {
            var inputValue = text;
            if (text.contains(' ')) {
              inputValue = text.replaceAll(' ', '');
            }

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                _validateProvider.updatePasswordValidate(CheckValidate().validatePassword(
                    FocusNode(), inputValue).isEmpty);  //비밀번호 형식 점검
              });
            });
          },
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: _colorsModel.bl,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            helperText: _isRed ? _helperText : '',
            label: _isRed ? SizedBox(
              width: 24,
              height: 24,
              child: Image.asset("assets/icons/warning.png"),
            ) : Container(width: 0, height: 0,),
            counterText: '',
            contentPadding: _isPassword ? EdgeInsets.only(right: 50, left: 15) :EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            filled: true,
            fillColor: Colors.transparent,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 16, color: _colorsModel.deepGrey),
            helperStyle: TextStyle(
                fontSize: 11,
                color: _isRed ? _colorsModel.red : _colorsModel.lightGrey),
            border: InputBorder.none,
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isRed ? _colorsModel.red : _colorsModel.lightGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(36),
            ),
            focusedErrorBorder: OutlineInputBorder(
              // borderSide: BorderSide.none,
              borderSide: BorderSide(
                color: _isRed ? _colorsModel.red : _colorsModel.lightGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(36),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isRed ? _colorsModel.red : _colorsModel.main,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(36),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isRed ? _colorsModel.red : _colorsModel.lightGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(36),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isRed ? _colorsModel.red : _colorsModel.lightGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(36),
            ),
          ),
        ),
        _isPassword ? GestureDetector(
          onTap: () {
            if (textEditingController == _passwordController) {
              setState(() {
                _isPasswordShow = !_isPasswordShow;
              });
            }

          },
          child: Padding(
            padding: EdgeInsets.only(right: 15.0, bottom: 27),
            child: SizedBox(
              width: 24,
              height: 24,
              child: _isEye ? Image.asset("assets/icons/eye.png") : Image.asset("assets/icons/eyeSlash.png"),
            ),
          ),
        ) : Container(),
      ],
    );
  }
}
