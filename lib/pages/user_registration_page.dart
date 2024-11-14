import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devjang_class_market/providers/validate_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../dialogs/cupertino_dialog.dart';
import '../models/colors_model.dart';
import '../providers/registration_provider.dart';
import '../services/auth_service.dart';
import '../services/user_services.dart';
import '../services/validate.dart';
import '../services/validate_phone_service.dart';

class UserRegiPage extends StatefulWidget {
  const UserRegiPage({Key? key}) : super(key: key);

  @override
  State<UserRegiPage> createState() => _UserRegiPageState();
}

class _UserRegiPageState extends State<UserRegiPage> {
  ColorsModel _colorsModel = ColorsModel();
  FocusNode _phoneNumFocus = FocusNode();
  FocusNode _phoneNumCheckFocus = FocusNode();
  FocusNode _nickNameCheckFocus = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  late TextEditingController _phoneNumController;  // 전화번호 Controller
  late TextEditingController _smsVeriCodeController;  // 인증번호 Controller
  late TextEditingController _nickNameController;  // 이름 Controller
  late TextEditingController _passwordController;  // 비밀번호 Controller
  late TextEditingController _passwordConfirmController;  // 비밀번호 확인 Controller
  late TextEditingController _emailController;  // 이메일 Controller


  bool _isPasswordShow = false;  // 비밀번호 노출 여부
  bool _isPasswordConfirmShow = false;  // 비밀번호 확인 노출 여부

  FocusNode _emailFocus = FocusNode();  // 이메일 입력필드로 Focus를 주기위해 생성
  FocusNode _passwordFocus = FocusNode();  // 비밀번호 입력필드로 Focus를 주기위해 생성
  bool _loading = false;

  ValidateProvider _validateProvider = ValidateProvider();  // 형식 점검을 위한 Provider
  RegistrationProvider _registrationProvider = RegistrationProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumController = TextEditingController();
    _smsVeriCodeController = TextEditingController();
    _nickNameController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _emailController.dispose();
    _phoneNumController.dispose();
    _smsVeriCodeController.dispose();
    _nickNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _validateProvider = Provider.of<ValidateProvider>(context, listen: true);
    _registrationProvider = Provider.of<RegistrationProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 40.h,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        leadingWidth: 39,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: SizedBox(
                width: 24,
                height: 24,
                child: Image.asset("assets/icons/arrowLeft.png")),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15.0.w, right: 15.w),
        child: Stack(
          children: [
            ListView(
              children: [
                SizedBox(height: 30.h,),
                Text('새로운 계정', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: _colorsModel.darkBlack),),
                SizedBox(height: 5.h,),
                Text('만들기', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: _colorsModel.darkBlack),),
                SizedBox(height: 30.h,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('전화번호', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),),
                SizedBox(height: 10.h,),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 170.w,
                      child: textFieldWidget(_phoneNumController, '숫자만 입력해주세요.'),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GestureDetector(
                            onTap: () {
                              ValidatePhoneService().verificationPhoneNumber(context: context, phoneNumber: _phoneNumController.text, registrationProvider: _registrationProvider,);
                            },
                            child: Container(
                              width: 120.w,
                              height: 42.h,
                              color: _colorsModel.main,
                              child: Center(child: Text('인증하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: _colorsModel.white),)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h,),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('인증번호', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),),
                SizedBox(height: 10.h,),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: textFieldWidget(_smsVeriCodeController, '인증번호를 입력해주세요.'),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('닉네임', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),),
                SizedBox(height: 10.h,),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: textFieldWidget(_nickNameController, '닉네임을 입력해주세요.'),
                ),
                Text('이메일', style: TextStyle(
                  fontSize: 14,
                  color: _colorsModel.bl,
                ),),
                const SizedBox(height: 10,),
                textFieldWidget(_emailController, '이메일을 입력해주세요.'),
                const SizedBox(height: 10,),
                Text('비밀번호', style: TextStyle(
                  fontSize: 14,
                  color: _colorsModel.bl,
                ),),
                const SizedBox(height: 10,),
                textFieldWidget(_passwordController, '비밀번호를 입력해주세요.'),
                Text('비밀번호 확인', style: TextStyle(
                  fontSize: 14,
                  color: _colorsModel.bl,
                ),),
                const SizedBox(height: 10,),
                textFieldWidget(_passwordConfirmController, '비밀번호를 다시 입력해주세요.'),
                GestureDetector(
                  onTap: () async {
                    if (
                    _phoneNumController.text.isNotEmpty &&
                        _smsVeriCodeController.text.isNotEmpty &&
                        _nickNameController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty &&
                        _passwordConfirmController.text.isNotEmpty
                    ) {
                      setState(() {
                        _loading = true;
                      });

                      var res = await ValidatePhoneService().checkAuthCode(context: context, verificationCode: _smsVeriCodeController.text, registrationProvider: _registrationProvider, isAlertShow: true);

                      if (res) {
                        List authResList = await AuthService().signUpWithEmail(email: _emailController.text, password: _passwordController.text, context: context);

                        if (authResList.first) {
                          List resList = await UserServices().registUser(
                              phoneNumber: _phoneNumController.text,
                              nickName: _nickNameController.text,
                              email: _emailController.text,
                              pw: _passwordController.text
                          );
                          setState(() {
                            _loading = false;
                          });
                          if (resList.first) {
                            Navigator.pushNamed(context, '/');
                          } else {
                            ReturnCupertinoDialog().onlyContentOneActionDialog(context: context, content: '유저 등록 실패\n${resList.last}', firstText: '확인');
                          }
                        } else {
                          setState(() {
                            _loading = false;
                          });
                          ReturnCupertinoDialog().onlyContentOneActionDialog(context: context, content: '회원가입 실패\n${authResList.last}', firstText: '확인');
                        }
                      } else {
                        ReturnCupertinoDialog().onlyContentOneActionDialog(context: context, content: '전화번호 인증실패', firstText: '확인');
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
                    child: const Center(
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
    String _helperText = "";
    int _inputMenu = 0; // 1 : 비밀번호, 2 : 비밀번호 확인

    if (textEditingController == _passwordController || textEditingController == _passwordConfirmController) {
      _isPassword = true;
    }

    if (textEditingController == _passwordConfirmController && _isPasswordConfirmShow) {
      _isEye = true;
    }

    if (textEditingController == _passwordController && _isPasswordShow) {
      _isEye = true;
    }

    if (textEditingController == _passwordController) {
      _inputMenu = 1;
    } else if (textEditingController == _passwordConfirmController) {
      _inputMenu = 2;
    }

    if (textEditingController == _emailController) {
      // or : ||, and : &&
      if (textEditingController.text.isNotEmpty && !_validateProvider.emailValidate) {
        _isRed = true;
        _helperText = '이메일 형식이 맞지않습니다.';
      }

      if (!_validateProvider.isCanUseEmail) {
        _isRed = true;
        _helperText = '이미 존재하는 이메일 입니다.';
      }

      return TextFormField(
        focusNode: _emailFocus,
        textDirection: TextDirection.ltr,
        cursorColor: _colorsModel.main,
        controller: textEditingController,
        onChanged: (text) {
          if (text.isNotEmpty) {
            var inputValue = text.trim();
            var validate = CheckValidate().validateEmail(_emailFocus, inputValue);

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              _validateProvider.updateEmailValidate(validate.isEmpty);  //이메일 형식 점검
            });
          }
          setState(() {

          });
        },
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        style: TextStyle(
          color: _colorsModel.bl,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: _isPassword ? EdgeInsets.only(right: 50, left: 15) :EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          filled: true,
          fillColor: _colorsModel.loginContanierColor,
          hintText: hintText,
          helperText: _isRed ? _helperText  : '',
          hintStyle: TextStyle(fontSize: 16, color: _colorsModel.deepGrey),
          helperStyle: TextStyle(fontSize: 11, color: _isRed ? _colorsModel.red : _colorsModel.lightGrey),
          border: InputBorder.none,
          label: _isRed ? SizedBox(
            width: 24,
            height: 24,
            child: Image.asset("assets/icons/warning.png"),
          ) : Container(width: 0, height: 0,),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _isRed ? _colorsModel.red : _colorsModel.lightGrey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            // borderSide: BorderSide.none,
            borderSide: BorderSide(
              color: _isRed ? _colorsModel.red : _colorsModel.lightGrey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _isRed ? _colorsModel.red : _colorsModel.main,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _isRed ? _colorsModel.red : _colorsModel.lightGrey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _isRed ? _colorsModel.red : _colorsModel.lightGrey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }

    if (_inputMenu == 1 && !_validateProvider.passwordValidate && _passwordController.text.isNotEmpty) {
      _isRed = true;
      _helperText = '비밀번호 형식이 맞지 않습니다.(12자/영어 소문자,특수문자 포함)';
    } else if (_inputMenu == 2 && !_validateProvider.passwordConfirmVali && _passwordConfirmController.text.isNotEmpty) {
      _isRed = true;
      _helperText = '비밀번호가 일치하지 않습니다.다시 한번 확인해주세요.';
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
            if (_inputMenu == 1 && text.isNotEmpty) {
              var inputValue = text.trim();
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                setState(() {
                  _validateProvider.updatePasswordValidate(CheckValidate().validatePassword(
                      _passwordFocus, inputValue).isEmpty);  //비밀번호 형식 점검
                });
              });
            }
            if (_inputMenu == 2) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                setState(() {
                  if (_passwordController.text != text) {
                    _validateProvider.updatePasswordConfirmVali(false);
                  } else {
                    _validateProvider.updatePasswordConfirmVali(true);
                  }
                });
              });
            }
            setState(() {

            });
          },
          textInputAction: TextInputAction.next,
          keyboardType:  TextInputType.text,
          style: TextStyle(
            color: _colorsModel.bl,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            helperText: _isRed ? _helperText : '',
            counterText: '',
            contentPadding: _isPassword ? EdgeInsets.only(right: 50, left: 15) :EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            filled: true,
            fillColor: _colorsModel.loginContanierColor,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 16, color: _colorsModel.deepGrey),
            helperStyle: TextStyle(fontSize: 11, color: _isRed ? _colorsModel.red : _colorsModel.lightGrey),
            border: InputBorder.none,
            label: _isRed ? SizedBox(
              width: 24,
              height: 24,
              child: Image.asset("assets/icons/warning.png"),
            ) : Container(width: 0, height: 0,),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isRed ? _colorsModel.red : _colorsModel.lightGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              // borderSide: BorderSide.none,
              borderSide: BorderSide(
                color: _isRed ? _colorsModel.red : _colorsModel.lightGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isRed ? _colorsModel.red : _colorsModel.main,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isRed ? _colorsModel.red : _colorsModel.lightGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isRed ? _colorsModel.red : _colorsModel.lightGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
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
            if (textEditingController == _passwordConfirmController) {
              setState(() {
                _isPasswordConfirmShow = !_isPasswordConfirmShow;
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
  //
  // TextFormField(
  //                   focusNode: _nickNameCheckFocus,
  //                   cursorColor: _colorsModel.main,
  //                   textInputAction: TextInputAction.done,
  //                   onChanged: (value) {
  //                     _registrationProvider.updateNickName(value);
  //                   },
  //                   keyboardType: TextInputType.text,
  //                   style: TextStyle(
  //                     color: _colorsModel.deepGreen,
  //                     fontSize: 16,
  //                   ),
  //                   decoration: InputDecoration(
  //                     contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
  //                     filled: true,
  //                     fillColor: _colorsModel.loginContanierColor,
  //                     hintText: ,
  //                     helperText: '',
  //                     hintStyle: TextStyle(fontSize: 14),
  //                     helperStyle: TextStyle(color: _colorsModel.orangeColor),
  //                     border: InputBorder.none,
  //                     disabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                       borderSide: BorderSide(width: 1, color: Colors.transparent,),
  //                     ),
  //                     focusedErrorBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                       borderSide: BorderSide(
  //                         color: _registrationProvider.nickName.isNotEmpty ? Colors.transparent : _colorsModel.main,
  //                       ),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                       borderSide: BorderSide(width: 1, color: _registrationProvider.nickName.isEmpty ? Colors.transparent : _colorsModel.main),  //선택 됐을 때 색
  //                     ),
  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                       borderSide: BorderSide(width: 1, color: _registrationProvider.nickName.isEmpty ? Colors.transparent : _colorsModel.main),  //선택 안됐을 때 색상
  //                     ),
  //                     errorBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(10),
  //                         borderSide: const BorderSide(
  //                           color: Colors.transparent,
  //                           width: 1,
  //                         )
  //                     ),
  //                   ),
  //                 )
}
