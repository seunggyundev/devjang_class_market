import 'package:devjang_class_market/firebase_options.dart';
import 'package:devjang_class_market/home.dart';
import 'package:devjang_class_market/pages/find_id_page.dart';
import 'package:devjang_class_market/pages/find_password_page.dart';
import 'package:devjang_class_market/pages/login_page.dart';
import 'package:devjang_class_market/pages/profile_page.dart';
import 'package:devjang_class_market/pages/user_registration_page.dart';
import 'package:devjang_class_market/providers/login_provider.dart';
import 'package:devjang_class_market/providers/product_provider.dart';
import 'package:devjang_class_market/providers/registration_provider.dart';
import 'package:devjang_class_market/providers/user_provider.dart';
import 'package:devjang_class_market/services/validate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'models/colors_model.dart';
import 'providers/validate_provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => UserProvider()),
        ChangeNotifierProvider(create: (BuildContext context) => ProductProvider()),
      ],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: Size(390.0, 844.0),  //기준 기기가 아이폰 12프로이며 해당 기기의 사이즈, 이 값을 기준으로 반응형 사이즈가 적용됨
      builder: (BuildContext context, child) =>
          MaterialApp(
            builder: (context, child) {
              return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!);
            },
            title: 'Flutter Demo',
            theme: ThemeData(
              fontFamily: 'Spoqa-Regular',
              primarySwatch: Colors.blue,
            ),
            supportedLocales: const [
              Locale('ko', 'KR'),
            ],
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            initialRoute: '/',
            routes: {
              '/': (context) {
                return MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (BuildContext context) => RegistrationProvider()),
                    ],
                    child: Home());
              },
              '/UserRegiPage': (context) {
                return MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (BuildContext context) => RegistrationProvider()),
                      ChangeNotifierProvider(create: (BuildContext context) => ValidateProvider()),
                    ],
                    child: UserRegiPage());
              },
              '/LoginPage': (context) {
                return MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (BuildContext context) => RegistrationProvider()),
                      ChangeNotifierProvider(create: (BuildContext context) => ValidateProvider()),
                    ],
                    child: LoginPage());
              },
              '/FindPasswordPage': (context) {
                return MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (BuildContext context) => RegistrationProvider()),
                      ChangeNotifierProvider(create: (BuildContext context) => ValidateProvider()),
                    ],
                    child: FindPasswordPage());
              },
              '/FindIdPage': (context) {
                return MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (BuildContext context) => RegistrationProvider()),
                      ChangeNotifierProvider(create: (BuildContext context) => ValidateProvider()),
                    ],
                    child: FindIdPage());
              },
              '/ProfilePage': (context) {
                return ProfilePage();
              },

            },
          ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FocusNode _emailFocus = FocusNode();
  String _emailValidate = '';  //이메일 점검을 위한 변수
  Color emailCheckColor = Color(0xff959595);
  ColorsModel _colorsModel = ColorsModel();
  EmailInputProvider _emailInputProvider = EmailInputProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                expands: false,
                maxLines: 1,
                minLines: 1,
                autovalidateMode: AutovalidateMode.always,
                focusNode: _emailFocus,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  if (_emailValidate == '이메일 형식을 올바르게 입력해주세요.') {
                    //이메일 형식 오류
                    setState(() {
                      _emailValidate;
                      emailCheckColor = _colorsModel.orangeColor;
                    });
                  } else {
                    setState(() {
                      _emailValidate;
                      emailCheckColor = _colorsModel.main;
                      _emailInputProvider.updateEmail(value.toString());
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value == '') {
                    return '';
                  } else {
                    _emailValidate = CheckValidate().validateEmail(_emailFocus, value);  //이메일 형식 점검
                  }
                },
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'example@email.com',
                  helperText: '${_emailValidate}',
                  hintStyle: TextStyle(fontSize: 14),
                  helperStyle: TextStyle(color: _colorsModel.orangeColor),
                  border: InputBorder.none,
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(width: 1, color: _colorsModel.deepGrey,),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(
                          color: emailCheckColor == _colorsModel.main ? _colorsModel.main : _colorsModel.orangeColor
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(width: 1, color: emailCheckColor,),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(width: 1, color: emailCheckColor == _colorsModel.main ? _colorsModel.main : _colorsModel.orangeColor),
                  ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(
                        color: _colorsModel.deepGrey,
                        width: 1,
                      )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
