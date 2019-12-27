import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/components/home/home_component.dart';
import 'package:traveltranslation/page/mainlist_page.dart';
import 'package:traveltranslation/page/mainpage/main_page.dart';

class CommonUtil {
  static backHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => MainPage(
              )),
      (Route<dynamic> route) => false,
    );
  }
}
