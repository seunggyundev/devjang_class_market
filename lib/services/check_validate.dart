import 'package:flutter/material.dart';

class CheckValidate {

  // 이메일 형식 점검
  // 사용자가 입력한 이메일(value)이 비어 있거나 형식에 맞지 않으면 에러 메시지를 반환하고 포커스를 설정합니다.
  String validateEmail(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      // 입력 값이 비어 있으면 포커스를 설정하고 에러 메시지 반환
      focusNode.requestFocus();
      return '이메일을 입력하세요.';
    } else {
      // 이메일 형식을 검사하기 위한 정규 표현식 패턴 설정
      var pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      var regExp = RegExp(pattern);

      // 이메일 형식이 맞지 않으면 포커스를 설정하고 에러 메시지 반환
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '이메일 형식을 올바르게 입력해주세요.';
      } else {
        return ''; // 형식이 올바르면 빈 문자열 반환
      }
    }
  }

  // 비밀번호 리셋 페이지용 이메일 형식 점검
  // 이메일 유효성 검사를 하지만, 비밀번호 리셋 페이지에 사용될 수 있도록 별도로 함수 정의
  String validateEmailForReset(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '이메일을 입력하세요.';
    } else {
      var pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      var regExp = RegExp(pattern);

      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '이메일 형식을 올바르게 입력해주세요.';
      } else {
        return '';
      }
    }
  }

  // 비밀번호 형식 점검
  // 비밀번호가 비어 있거나, 특수문자/대소문자/숫자가 포함되지 않은 경우 에러 메시지를 반환하고 포커스를 설정합니다.
  String validatePassword(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      // 비밀번호가 비어 있을 때 에러 메시지 반환
      focusNode.requestFocus();
      return '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내';
    } else {
      // 비밀번호 형식을 검사하기 위한 정규 표현식 패턴 설정
      var pattern = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
      RegExp regExp = RegExp(pattern);

      // 비밀번호 형식이 맞지 않으면 에러 메시지 반환
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내';
      } else {
        return ''; // 형식이 올바르면 빈 문자열 반환
      }
    }
  }

  // 로그인용 비밀번호 형식 점검
  // 로그인 시 입력된 비밀번호의 형식을 점검하기 위해 사용 (validatePassword와 동일한 로직)
  String validatePasswordLogin(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내';
    } else {
      var pattern = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
      RegExp regExp = RegExp(pattern);

      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내';
      } else {
        return '';
      }
    }
  }
}
