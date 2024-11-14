import 'package:devjang_class_market/models/colors_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogClass {
  ColorsModel _colors = ColorsModel();

  oneButtonDialog({required content, required btnText, required context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _colors.white,
          contentPadding: EdgeInsets.only(top: 45, bottom: 30,left: 15, right: 15),
          actionsPadding: EdgeInsets.only(bottom: 15),
          content: Text(
            "${content}",
            style: TextStyle(color: _colors.white, fontWeight: FontWeight.w500, fontSize: 15, height: 1.5),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              child: Text(
                '${btnText}',
                style: TextStyle(color: _colors.main, fontWeight: FontWeight.w500, fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  twoButtonOnlyContentDialog({required context,required title, required content,required firstText, required secondText, required firstAction, required secondAction}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _colors.white,
          contentPadding: EdgeInsets.only(top: 45, bottom: 30),
          actionsPadding: EdgeInsets.only(bottom: 15),
          title: Text(
            "${title}",
            style: TextStyle(color: _colors.darkBlack, fontWeight: FontWeight.w500, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "${content}",
            style: TextStyle(color: _colors.darkBlack, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                firstAction;
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _colors.main, width: 1),
                ),
                child: Text(
                  '${firstText}',
                  style: TextStyle(color: _colors.main,  fontSize: 16),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                firstAction;
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _colors.main,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _colors.main, width: 1),
                ),
                child: Text(
                  '${firstText}',
                  style: TextStyle(color: _colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  getCareersMailDialog({required content, required btnText, required context}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: Border(
          top: BorderSide.none,
          bottom: BorderSide.none,
        ),
        insetPadding: EdgeInsets.only(top: 280.h, bottom: 300.h, left: 25.w, right: 25.w),
        backgroundColor: _colors.white,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              content,
              style: TextStyle(
                color: _colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            TextButton(
              child: Text(
                btnText,
                style: TextStyle(color: _colors.main, fontSize: 15, fontWeight: FontWeight.w400),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
