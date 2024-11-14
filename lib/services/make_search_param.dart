class MakeSearchParam {
  List<String> setSearchParam(String text) {
    List<String> caseSearchList = [];

    for (int i = 0; i < text.length; i++) {
      String removeText = text.replaceRange(0, (i + 1) > text.length ? text.length : i + 1, '');
      String temp = "";

      for (int i = 0; i < removeText.length; i++) {
        temp = temp + removeText[i];
        caseSearchList.add(temp);
      }
    }

    String temp = "";

    for (int i = 0; i < text.length; i++) {
      temp = temp + text[i];
      caseSearchList.add(temp);
    }

    caseSearchList.addAll(text.split(' '));

    caseSearchList.addAll(text.split(" "));



    return caseSearchList;
  }
}