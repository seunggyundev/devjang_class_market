import 'package:devjang_class_market/models/colors_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReturnCupertinoDialog {
  ColorsModel _colorsModel = ColorsModel();

  twoActionsDialog({required context,required title, required content,required firstText,required firstPressed,required secText,required secPressed,}) {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('${title}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black),),
            content: Text('${content}', style: TextStyle(fontSize: 14,),),
            actions: [
              CupertinoDialogAction(
                onPressed: firstPressed,
                child: Text('${firstText}', style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: _colorsModel.cupertinoAlertBtnText,
                ),),
              ),
              CupertinoDialogAction(
                onPressed: secPressed,
                child: Text('${secText}', style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: _colorsModel.cupertinoAlertBtnText,
                ),),
              ),
            ],
          );
        });
  }

  oneActionDialog({required context,required title, required content,required firstText,required firstPressed,}) {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('${title}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black),),
            content: Text('${content}', style: TextStyle(fontSize: 13,),),
            actions: [
              CupertinoDialogAction(
                onPressed: firstPressed,
                child: Text('${firstText}', style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: _colorsModel.cupertinoAlertBtnText,
                ),),
              ),
            ],
          );
        });
  }

  onlyContentOneActionDialog({required context,required content,required firstText,}) {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Text('${content}', style: TextStyle(fontSize: 14,),),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('${firstText}', style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: _colorsModel.cupertinoAlertBtnText,
                ),),
              ),
            ],
          );
        });


  }

  onlyContentTwoActionsDialog({required context,required content,required firstText,required firstPressed,required secText,required secPressed,}) {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Text('${content}', style: TextStyle(fontSize: 14,),),
            actions: [
              CupertinoDialogAction(
                onPressed: firstPressed,
                child: Text('${firstText}', style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: _colorsModel.cupertinoAlertBtnText,
                ),),
              ),
              CupertinoDialogAction(
                onPressed: secPressed,
                child: Text('${secText}', style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: _colorsModel.cupertinoAlertBtnText,
                ),),
              ),
            ],
          );
        });
  }

}