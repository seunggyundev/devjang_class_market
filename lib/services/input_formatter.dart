import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// 통화 입력 포맷터
class CurrencyInputFormatter extends TextInputFormatter {

  // 입력 값이 변경될 때마다 호출되는 메서드
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    // 만약 입력값이 비어있다면 (기본 위치가 0일 경우)
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue; // 그대로 반환
    }

    // 기존에 입력된 쉼표를 제거한 후, 숫자로 변환
    var value = double.parse(newValue.text.replaceAll(',', ''));

    // 세 자리마다 쉼표를 넣기 위한 포맷터 생성
    final formatter = NumberFormat('####,###,###');

    // 포맷터를 사용하여 변환된 숫자를 쉼표로 구분된 문자열로 변환
    var newText = '${formatter.format(value)}';

    // 포맷팅된 새 문자열로 TextEditingValue 반환
    return newValue.copyWith(
      text: newText,
      selection: new TextSelection.collapsed(offset: newText.length),
    );
  }
}

// 전화번호 입력 포맷터
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {

    final int newTextLength = newValue.text.length; // 입력된 문자열의 길이
    int selectionIndex = newValue.selection.end; // 커서 위치 설정
    int usedSubstringIndex = 0; // 문자열 구분을 위한 인덱스 초기화
    final StringBuffer newText = new StringBuffer(); // 최종 결과를 저장할 버퍼

    // 문자열이 4자리 이상일 때 첫 번째 하이픈 추가
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + '-');
      if (newValue.selection.end >= 3)
        selectionIndex += 2; // 커서 위치 조정
    }

    // 문자열이 7자리 이상일 때 두 번째 하이픈 추가
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6)
        selectionIndex++;
    }

    // 문자열이 11자리 이상일 때 마지막 부분 추가
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10));
      if (newValue.selection.end >= 10)
        selectionIndex++;
    }

    // 남아있는 문자열을 추가
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));

    // 포맷팅된 새 문자열과 업데이트된 커서 위치를 반환
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: newText.length),
    );
  }
}
