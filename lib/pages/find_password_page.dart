import 'package:devjang_class_market/dialogs/cupertino_dialog.dart';
import 'package:devjang_class_market/models/user_model.dart';
import 'package:devjang_class_market/providers/registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../models/colors_model.dart';
import '../providers/validate_provider.dart';
import '../services/auth_service.dart';
import '../services/validate_phone_service.dart';

class FindPasswordPage extends StatefulWidget {
  const FindPasswordPage({Key? key}) : super(key: key);

  @override
  State<FindPasswordPage> createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {

  RegistrationProvider _registrationProvider = RegistrationProvider();
  UserClass userClass = UserClass();
  ColorsModel _colorsModel = ColorsModel();
  TextEditingController _idController = TextEditingController();
  TextEditingController _phoneNumController = TextEditingController();
  TextEditingController _authCodeController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _loading = false;
  FocusNode _resizeFocusNode = FocusNode();
  bool _isResizeBtm = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _phoneNumController = TextEditingController();
    _authCodeController = TextEditingController();

    _idController.addListener(() {
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
    _resizeFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _idController.dispose();
    _phoneNumController.dispose();
    _authCodeController.dispose();
    _resizeFocusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (_resizeFocusNode.hasFocus) {
      setState(() {
        _isResizeBtm = true;
      });
    } else {
      setState(() {
        _isResizeBtm = false;
      });
    }
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
          resizeToAvoidBottomInset: _isResizeBtm,
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
            title: Text('비밀번호 찾기', style: TextStyle(fontSize: 16.sp,
                color: _colorsModel.bl),),
            leadingWidth: 40,
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: ListView(
                  controller: _scrollController,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15,),
                        Text('아이디', style: TextStyle(
                          fontSize: 14.sp,
                          color: _colorsModel.bl,
                        ),),
                        const SizedBox(height: 10,),
                        textFieldWidget(_idController, '아이디를 입력해주세요.'),
                        phoneAuthWidget(screenWidth),
                        SizedBox(height: 200 + MediaQuery.of(context).viewInsets.bottom,),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: btmBtn(screenWidth)),
              _loading ? Center(child: CircularProgressIndicator(color: _colorsModel.main,),) : Container(),
            ],
          ),
        ));
  }

  Widget btmBtn(screenWidth) {
    bool _isPass = false;


    if (
    _idController.text.isNotEmpty &&
        _phoneNumController.text.isNotEmpty &&
    _authCodeController.text.isNotEmpty
    ) {
      _isPass = true;
    } else {
      _isPass = false;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0, left: 15, right: 15),
      child: GestureDetector(
        onTap: () async {
          if (!_loading) {
            setState(() {
              _loading = true;
            });
            List resList = await AuthService().sendResetPasswordEmail(_idController.text);
            if (resList.first) {
              setState(() {
                _loading = false;
              });
              ReturnCupertinoDialog().onlyContentOneActionDialog(context: context, content: '비밀번호 재설정 메일을 전송하였습니다.', firstText: '확인');
            } else {
              setState(() {
                _loading = false;
              });
              ReturnCupertinoDialog().onlyContentOneActionDialog(context: context, content: '${resList.last}', firstText: '확인');
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: _isPass ? _colorsModel.main : _colorsModel.main.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          width: screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  '비밀번호 재설정 메일 전송',
                  style: TextStyle(
                    color: _colorsModel.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget phoneAuthWidget(screenWidth) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
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
                child: Center(child: Text('인증번호', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: _phoneNumController.text.isEmpty ? _colorsModel.lightGrey : _colorsModel.white),)),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    _loading = true;
                  });

                  await ValidatePhoneService().checkAuthCode(context: context, verificationCode: _authCodeController.text.toString(), registrationProvider: _registrationProvider, isAlertShow: true);

                  setState(() {
                    _loading = false;
                  });
                },
                child: Container(
                  width: 120.w,
                  height: 42.h,
                  decoration: BoxDecoration(
                    color: _authCodeController.text.isEmpty ? _colorsModel.loginContanierColor : _colorsModel.main,
                    border: Border.all(color: _authCodeController.text.isEmpty ? _colorsModel.lightGrey : _colorsModel.main),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text('확인', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: _authCodeController.text.isEmpty ? _colorsModel.lightGrey : _colorsModel.white),)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10,),
      ],
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

