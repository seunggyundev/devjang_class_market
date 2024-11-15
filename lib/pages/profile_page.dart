import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devjang_class_market/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../dialogs/cupertino_dialog.dart';
import '../models/colors_model.dart';
import '../providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ColorsModel _colorsModel = ColorsModel();
  bool _loading = false;
  int _page = 0;

  UserProvider _userProvider = UserProvider();
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    setState(() {
      _loading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _nameController.text = _userProvider.user.nickName;
      });
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 40.h,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        leadingWidth: 39,
        title: Text('프로필 수정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: _colorsModel.darkBlack),),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            if (_page == 0) {
              Navigator.of(context).pop();
            } else {
              setState(() {
                _page = 0;
              });
            }
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
      body: bodyChange(),
    );
  }

  bodyChange() {
    switch(_page) {
      case 0 :
        return _loading ? Center(child: CircularProgressIndicator(color: _colorsModel.main,),) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _page = 1;
                });
              },
              child: Container(
                height: 52.h,
                color: _colorsModel.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('프로필 수정', style: TextStyle(fontSize: 16, color: _colorsModel.deepGreen),),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset("assets/icons/caretRight.png"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                ReturnCupertinoDialog().onlyContentTwoActionsDialog(
                    context: context,
                    content: '로그아웃 하시겠습니까?',
                    firstText: '예',
                    firstPressed: () async {
                      Navigator.of(context).pop();
                      setState(() {
                        _loading = true;
                      });
                      await FirebaseAuth.instance.signOut();
                      setState(() {
                        _loading = false;
                      });
                      Navigator.pushNamed(context, '/');
                    },
                    secText: '아니오',
                    secPressed: () {
                      Navigator.of(context).pop();
                    }
                );
              },
              child: Container(
                height: 52.h,
                color: _colorsModel.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('로그아웃', style: TextStyle(fontSize: 16, color: _colorsModel.deepGreen),),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset("assets/icons/caretRight.png"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                ReturnCupertinoDialog().onlyContentTwoActionsDialog(
                    context: context,
                    content: '탈퇴 하시겠습니까?',
                    firstText: '예',
                    firstPressed: () async {
                      Navigator.of(context).pop();
                      setState(() {
                        _loading = true;
                      });
                      List resList = await AuthService().removeUser();
                      setState(() {
                        _loading = false;
                      });

                      if (resList.first) {
                        Navigator.pushNamed(context, '/');
                      } else {
                        ReturnCupertinoDialog().onlyContentOneActionDialog(context: context, content: '오류\n${resList.last}', firstText: '확인');
                      }
                    },
                    secText: '아니오',
                    secPressed: () {
                      Navigator.of(context).pop();
                    }
                );
              },
              child: Container(
                height: 52.h,
                color: _colorsModel.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('회원탈퇴 sign out', style: TextStyle(fontSize: 16, color: _colorsModel.deepGreen),),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset("assets/icons/caretRight.png"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      case 1 :
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.0.w, right: 15.w, top: 30.h),
              child: ListView(
                physics: ScrollPhysics(),
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text('전화번호', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),),
                  SizedBox(height: 10.h,),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: _colorsModel.main, width: 1),
                      borderRadius: BorderRadius.circular(10),
                      color: _colorsModel.loginContanierColor,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 49.h,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0.w),
                          child: Text('${_userProvider.user.phoneNumber}'),
                        )),
                  ),
                  SizedBox(height: 15.h,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text('닉네임', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),),
                  SizedBox(height: 10.h,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: textFieldWidget(_nameController, '닉네임을 입력해주세요.'),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () async {
                  ReturnCupertinoDialog().onlyContentTwoActionsDialog(
                      context: context,
                      content: '${_nameController.text}로 닉네임을\n변경하시겠습니까?',
                      firstText: '예',
                      firstPressed: () async {
                        Navigator.of(context).pop();
                        if (_nameController.text.isNotEmpty) {
                          if (_loading) {
                            return;
                          }
                          setState(() {
                            _loading = true;
                          });
                          await FirebaseFirestore.instance.collection('userCol').doc('${_userProvider.user.uid}').update({
                            'nickName': _nameController.text,
                          });
                          setState(() {
                            _loading = false;
                          });
                        }
                      },
                      secText: '아니오',
                      secPressed: () {
                        Navigator.of(context).pop();
                      }
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _colorsModel.main,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 80.h,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20.0.h),
                      child: Text(
                        '수정하기',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _loading == true ? Center(child: CircularProgressIndicator(color: _colorsModel.main,),) : Container(),
          ],
        );
    }
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
