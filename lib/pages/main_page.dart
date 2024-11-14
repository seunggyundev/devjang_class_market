
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../dialogs/cupertino_dialog.dart';
import '../models/colors_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../providers/product_provider.dart';
import '../providers/user_provider.dart';
import '../services/product_service.dart';
import '../services/user_services.dart';
import '../widgets/textfield_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  UserClass _userClass = UserClass();
  User? _user = FirebaseAuth.instance.currentUser;
  bool _loading = false;
  bool _isInit = false;
  UserProvider _userProvider = UserProvider();
  ProductProvider _productProvider = ProductProvider();
  ColorsModel _colorsModel = ColorsModel();
  TextEditingController _searchController = TextEditingController();
  bool _loadingFirestore = false;
  ValueNotifier<List<ProductClass>>  _productList = ValueNotifier<List<ProductClass>>([]); // ValueNotifier 변수 선언

  ScrollController scrollController = ScrollController();
  Fluttertoast flutterToast = Fluttertoast();
  FToast fToast = FToast();

  @override
  void initState() {
    super.initState();
    initData();
    fToast.init(context);
  }

  initData() async {
    setState(() {
      _loading = true;
    });
    _productProvider.updateSearchText(null);
    _productProvider.updateSelectMenu(0);
    _productProvider.updateLastDocsnap(null);

    List resList = await UserServices().getUserData(_user?.uid ?? "");

    if (resList.first) {
      UserClass userClass = resList.last;
      setState(() {
        _userClass = userClass;
        _loading = false;
        _isInit = true;
      });
      _userProvider.updateUser(userClass);
    } else {
      setState(() {
        _loading = false;
      });
      ReturnCupertinoDialog().onlyContentOneActionDialog(context: context, content: "${resList.last}", firstText: '확인');
    }
    firstDataAlign();
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context, listen: true);
    _productProvider = Provider.of<ProductProvider>(context, listen: true);

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
                setState(() {
                  initData();
                });
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
          body: _isInit ? Stack(
            children: [
              ListView(
                controller: scrollController,
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
                  Padding(
                    padding: EdgeInsets.only(left: 15.0.w, right: 15.w),
                    child: Row(
                      children: [
                        Text('${_userClass.point == null ? 0 : addComma(value: _userClass.point.toString())}₩', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: _colorsModel.main),),
                        SizedBox(width: 15.w,),
                        GestureDetector(
                          onTap: () {
                            if (_userClass.uid == null) {
                              Navigator.pushNamed(context, '/LoginPage');
                            } else {
                              Navigator.pushNamed(context, '/PointAddPage');
                            }
                          },
                          child: SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: Image.asset('assets/icons/plusCircle.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                        padding: EdgeInsets.only(left: 15.0.w, right: 15.w),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFieldWidget(
                                    controller: _searchController,
                                    cursorColor: _colorsModel.main,
                                    borderColor: _colorsModel.main,
                                    fillColor: _colorsModel.loginContanierColor,
                                    hintColor: _colorsModel.orangeColor,
                                    hintText: '검색어를 입력하세요',
                                    textStyle: TextStyle(
                                      color: _colorsModel.deepGreen,
                                      fontSize: 16,
                                    ),
                                    onSubmitted: (value) {
                                      if (value.isEmpty) {
                                        _productProvider.updateSelectMenu(0);
                                        _productProvider.updateSearchText(null);
                                        _searchController.clear();
                                        firstDataAlign();
                                      } else {
                                        _productProvider.updateLastDocsnap(null);
                                        _productProvider.updateSearchText(value);
                                        firstDataAlign();
                                      }
                                    },
                                    onChanged: (value) {
                                      // 추가 로직 필요 시 작성
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 12.0.h, right: 15.w),
                              child: GestureDetector(
                                onTap: () {
                                  if (_searchController.text.isEmpty) {
                                    _productProvider.updateSelectMenu(0);
                                    _productProvider.updateSearchText(null);
                                    setState(() {
                                      _searchController.clear();
                                      firstDataAlign();
                                    });
                                  } else {
                                    _productProvider.updateSearchText(_searchController.text);
                                    _productProvider.updateLastDocsnap(null);
                                    firstDataAlign();
                                  }
                                },
                                child: SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: Image.asset('assets/icons/search.png',),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 60.h,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0.w),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_productProvider.selectMenu == 1) {
                                  _productProvider.updateSelectMenu(0);
                                  setState(() {
                                    firstDataAlign();
                                  });
                                  return;
                                } else {
                                  _productProvider.updateSelectMenu(1);
                                  setState(() {
                                    firstDataAlign();
                                  });
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: _productProvider.selectMenu == 1 ? _colorsModel.main : _colorsModel.loginContanierColor,
                                radius: 40.r,
                                child: SizedBox(
                                  width: 40.w,
                                  height: 40.h,
                                  child: Image.asset('assets/icons/meat.png', color:  _productProvider.selectMenu == 1 ? _colorsModel.white : _colorsModel.main,),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_productProvider.selectMenu == 2) {
                                  _productProvider.updateSelectMenu(0);
                                  setState(() {
                                    firstDataAlign();
                                  });
                                  return;
                                } else {
                                  _productProvider.updateSelectMenu(2);
                                  setState(() {
                                    firstDataAlign();
                                  });
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: _productProvider.selectMenu == 2 ? _colorsModel.main : _colorsModel.loginContanierColor,
                                radius: 40.r,
                                child: SizedBox(
                                  width: 40.w,
                                  height: 40.h,
                                  child: Image.asset('assets/icons/vegetable.png', color:  _productProvider.selectMenu == 2 ? _colorsModel.white : _colorsModel.main,),
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                if (_productProvider.selectMenu == 3) {
                                  _productProvider.updateSelectMenu(0);
                                  setState(() {
                                    firstDataAlign();
                                  });
                                  return;
                                } else {
                                  _productProvider.updateSelectMenu(3);
                                  setState(() {
                                    firstDataAlign();
                                  });
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: _productProvider.selectMenu == 3 ? _colorsModel.main : _colorsModel.loginContanierColor,
                                radius: 40.r,
                                child: SizedBox(
                                  width: 40.w,
                                  height: 40.h,
                                  child: Image.asset('assets/icons/peanutCan.png', color:  _productProvider.selectMenu == 3 ? _colorsModel.white : _colorsModel.main,),
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                if (_productProvider.selectMenu == 4) {
                                  _productProvider.updateSelectMenu(0);
                                  setState(() {
                                    firstDataAlign();
                                  });
                                  return;
                                } else {
                                  _productProvider.updateSelectMenu(4);
                                  setState(() {
                                    firstDataAlign();
                                  });
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: _productProvider.selectMenu == 4 ? _colorsModel.main : _colorsModel.loginContanierColor,
                                radius: 40.r,
                                child: SizedBox(
                                  width: 40.w,
                                  height: 40.h,
                                  child: Image.asset('assets/icons/cookie.png', color:  _productProvider.selectMenu == 4 ? _colorsModel.white : _colorsModel.main,),
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                if (_productProvider.selectMenu == 5) {
                                  _productProvider.updateSelectMenu(0);
                                  setState(() {
                                    firstDataAlign();
                                  });
                                  return;
                                } else {
                                  _productProvider.updateSelectMenu(5);
                                  setState(() {
                                    firstDataAlign();
                                  });
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: _productProvider.selectMenu == 5 ? _colorsModel.main : _colorsModel.loginContanierColor,
                                radius: 40.r,
                                child: SizedBox(
                                  width: 40.w,
                                  height: 40.h,
                                  child: Image.asset('assets/icons/bean.png', color:  _productProvider.selectMenu == 5 ? _colorsModel.white : _colorsModel.main,),
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                if (_productProvider.selectMenu == 6) {
                                  _productProvider.updateSelectMenu(0);
                                  setState(() {
                                    firstDataAlign();
                                  });
                                  return;
                                } else {
                                  _productProvider.updateSelectMenu(6);
                                  setState(() {
                                    firstDataAlign();
                                  });
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: _productProvider.selectMenu == 6 ? _colorsModel.main : _colorsModel.loginContanierColor,
                                radius: 40.r,
                                child: SizedBox(
                                  width: 40.w,
                                  height: 40.h,
                                  child: Image.asset('assets/icons/wine.png', color:  _productProvider.selectMenu == 6 ? _colorsModel.white : _colorsModel.main,),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w,),
                          ],
                        ),
                      )),
                  SizedBox(height: 30.h,),
                  dataValueNotiBuilder(),
                  SizedBox(height: 30.h,),
                ],
              ),
              _loading ? Center(child: CircularProgressIndicator(color: _colorsModel.main,),) : Container(),
            ],
          ) : Center(child: CircularProgressIndicator(color: _colorsModel.main,),),
        ),
      ),
    );
  }

  dataValueNotiBuilder() {

    return ValueListenableBuilder(
      valueListenable: _productList,
      builder: (BuildContext context, List value, Widget? child) {

        return Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          child: _productList.value.isEmpty ? Center(child: Text('상품이 없습니다'),) :
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _productList.value.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
              childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
              mainAxisSpacing: 30, //수평 Padding
              crossAxisSpacing: 30, //수직 Padding
            ),
            itemBuilder: (BuildContext context, int index) {
              ProductClass _product = _productList.value[index];

              return GestureDetector(
                onTap: () async {
                  if (_loading) {
                    return;
                  }

                  setState(() {
                    _loading = true;
                  });

                  List resList = await ProductService().insertToCart(productId: _product.docId, uid: _userClass.uid);
                  setState(() {
                    _loading = false;
                  });

                  if (resList.first) {
                    _showToast();
                  } else {
                    ReturnCupertinoDialog().onlyContentOneActionDialog(context: context, content: '${resList.last}', firstText: '확인');
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _colorsModel.productBackColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: _product.downloadUrl.toString().isEmpty ? Container() : ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Center(child: Image.network(
                              '${_product.downloadUrl}',
                              height: (MediaQuery.of(context).size.width),
                             // cacheHeight: (MediaQuery.of(context).size.width).toInt(),
                              width: (MediaQuery.of(context).size.width),
                             // cacheWidth: (MediaQuery.of(context).size.width).toInt(),
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {

                                return Container();
                              },
                            ))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color(0x80020f0f),
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height: 58.h,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.w, top: 5.h,),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('${_product.title}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _colorsModel.white),),
                              Text('₩${addComma(value: '${_product.amount}')}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _colorsModel.white),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
        ;
      },
    );
  }

  void  _scrollListenerForData() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      if (_loading == true) {
        // 첫 데이터 때는 통과
        nextDataAlign();
      } else {
        if (_loadingFirestore == false) {
          setState(() {
            _loadingFirestore = true;
          });
          nextDataAlign();
        }
      }
    } else {
      if (scrollController.offset < scrollController.position.maxScrollExtent) {
        //print('scrollController!.offset < scrollController!.position.maxScrollExtent');
      }
    }
  }

  nextDataAlign() async {
    try {

      List resList = await ProductService().getProductList(productProvider: _productProvider);

      if (resList.first) {
        setState(() {
          _productList.value.addAll(resList.last);
          _loadingFirestore = false;
        });
      } else {
        setState(() {
          _loadingFirestore = false;
        });
        ReturnCupertinoDialog().onlyContentOneActionDialog(context: context, content: '오류발생\n${resList.last}', firstText: '확인');
      }
    } catch(e) {
      setState(() {
        _loadingFirestore = false;
      });
    }
  }

  firstDataAlign() async {
    if (_loadingFirestore == false) {
      try {
        setState(() {
          _loading = true;
          _loadingFirestore = true;
        });

        List resList = await ProductService().getProductList(productProvider: _productProvider);

        if (resList.first) {
          setState(() {
            _isInit = true;
            _productList.value = resList.last;
          });
        } else {
          setState(() {
            _isInit = true;
          });
          ReturnCupertinoDialog().onlyContentOneActionDialog(context: context, content: '오류발생\n${resList.last}', firstText: '확인');
        }

        scrollController.addListener(_scrollListenerForData);
        setState(() {
          _loading = false;
          _loadingFirestore = false;
        });
      } catch(e) {
        setState(() {
          _loading = false;
          _loadingFirestore = false;
        });
        print('error firstDataAlign:${e}');
      }
    } else {
      print('_loadingFirestore true');
    }
  }

  _showToast() {
    // this will be our toast UI
    Widget toast = Center(child: CircleAvatar(
      radius: 36,
      backgroundColor: _colorsModel.main,
      child: SizedBox(
          width: 30.w,
          height: 30.h,
          child: Image.asset('assets/icons/tote.png', color: _colorsModel.white,)),
    ),);


    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 1),
    );
  }

  addComma({required String value}) {
    // print('value $value');
    try {
      if (value == 'null') {
        return '';
      }
      if (value.isEmpty) {
        return '';
      }

      bool isPoint = false;

      if (value.contains('.')) {
        String pointValue = value.split('.')[1];
        if (pointValue.isEmpty || pointValue != '0') {
          isPoint = true;
        }
      }

      if (isPoint) {
        String _pointValue = '';
        String _noPointValue = '';
        if (value.contains('.')) {
          _noPointValue = value.split('.')[0].replaceAll(',', '');
          _pointValue = value.split('.')[1];
        } else {
          _noPointValue = value.replaceAll(',', '');
        }

        var convertValue = double.parse(_noPointValue.replaceAll(',', '').replaceAll('.', ''));
        final formatter = NumberFormat('####,###,###');
        var newText = '${formatter.format(convertValue)}';

        return _pointValue.isEmpty ? newText : newText + '.' + _pointValue;
      } else {
        var convertValue = double.parse(value.replaceAll(',', ''));
        final formatter = NumberFormat('####,###,###');
        var newText = '${formatter.format(convertValue)}';

        return newText;
      }
    } catch(e) {
      //     print('error addComma ${e} ${value}');
      return value;
    }
  }
}
