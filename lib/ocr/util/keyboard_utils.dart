import 'package:flutter/material.dart';

class KeyBoardUtils {
  static void closeKeyBoard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
