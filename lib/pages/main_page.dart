
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../dialogs/cupertino_dialog.dart';
import '../models/colors_model.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../services/user_services.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  UserClass _userClass = UserClass();
  User? _user = FirebaseAuth.instance.currentUser;
  bool _loading = false;
  UserProvider _userProvider = UserProvider();
  ColorsModel _colorsModel = ColorsModel();

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    setState(() {
      _loading = true;
    });
    List resList = await UserServices().getUserData(_user?.uid ?? "");

    if (resList.first) {
      UserClass userClass = resList.last;
      setState(() {
        _userClass = userClass;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      ReturnCupertinoDialog().onlyContentOneActionDialog(context: context, content: "${resList.last}", firstText: '확인');
    }
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context, listen: true);

    if (_userProvider.isUpdate) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _userProvider.updateIsUpdate(false);
        initData();
      });
    }

    return WillPopScope(
      onWillPop: () {
        //쓸어서 뒤로가기 방지, 막지 않으면 유저가 채팅방에 없다는 것을 서버에 업데이트할 수 없다
        return Future(() => false);
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: 40.h,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.white,
            leadingWidth: 80.w,
            leading: GestureDetector(
              onTap: () async {
              },
              child: Padding(
                padding: EdgeInsets.only(left: 15.0.w, top: 9.h),
                child: Text('SHOPPING', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: _colorsModel.darkBlack),),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  if (_userClass.uid == null) {
                    Navigator.pushNamed(context, '/LoginPage');
                  } else {
                    Navigator.pushNamed(context, '/ProfilePage',);
                  }
                },
                child: SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: Image.asset('assets/icons/user.png', color: _colorsModel.darkBlack,),
                ),
              ),
              SizedBox(width: 15.w,),
              GestureDetector(
                onTap: () {
                  if (_userClass.uid == null) {
                    Navigator.pushNamed(context, '/LoginPage');
                  } else {
                    Navigator.pushNamed(context, '/CartPage');
                  }
                },
                child: SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: Image.asset('assets/icons/tote.png'),
                ),
              ),
              SizedBox(width: 15.w,),
            ],
          ),
          body: Stack(
            children: [
              ListView(
                physics: ScrollPhysics(),
                children: [
                  SizedBox(height: 30.h,),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0.w, right: 15.w),
                    child:
                    _userClass.nickName == null ?
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/LoginPage');
                      },
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width - 60.w,
                          child: Text("로그인하기", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: _colorsModel.darkBlack),)),
                    )
                        :
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 60.w,
                        child: Text("${_userClass.nickName}님의\n잔액을 확인하세요", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: _colorsModel.darkBlack),)),
                  ),
                  SizedBox(height: 15.h,),
                ],
              ),
              _loading ? Center(child: CircularProgressIndicator(color: _colorsModel.main,),) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
