import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final Color cursorColor;
  final Color borderColor;
  final Color fillColor;
  final Color hintColor;
  final String hintText;
  final TextStyle textStyle;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final int maxLines;

  const TextFieldWidget({
    Key? key,
    required this.controller,
    required this.cursorColor,
    required this.borderColor,
    required this.fillColor,
    required this.hintColor,
    required this.hintText,
    required this.textStyle,
    this.onSubmitted,
    this.onChanged,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      smartDashesType: SmartDashesType.enabled,
      maxLines: maxLines,
      controller: controller,
      cursorColor: cursorColor,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      style: textStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: hintColor),
        helperText: '',
        helperStyle: TextStyle(color: hintColor),
        border: InputBorder.none,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 1, color: Colors.transparent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: controller.text.isNotEmpty ? Colors.transparent : borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 1, color: controller.text.isEmpty ? Colors.transparent : borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 1, color: controller.text.isEmpty ? Colors.transparent : borderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent, width: 1),
        ),
      ),
    );
  }
}
