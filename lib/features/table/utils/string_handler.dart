class StringHanler {
  static String cutString(
      {required String txt, required bool isName, required String pattern}) {
    if (!isName) {
      if (txt.contains(pattern)) {
        return txt.substring(0, txt.indexOf(pattern)).trim();
      }
    } else {
      if (txt.contains(pattern)) {
        return txt.substring(txt.indexOf(pattern)).trim();
      }
    }
    return txt;
  }
}
