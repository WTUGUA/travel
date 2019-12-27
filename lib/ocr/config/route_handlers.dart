import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/components/history/history_scene.dart';
import 'package:traveltranslation/ocr/components/home/home_component.dart';
import 'package:traveltranslation/ocr/components/home/splash_component.dart';
import 'package:traveltranslation/ocr/components/ocr/show_pic_page.dart';
import 'package:traveltranslation/ocr/components/setting/help_component.dart';
import 'package:traveltranslation/ocr/components/setting/login_component.dart';
import 'package:traveltranslation/ocr/components/setting/setting_component.dart';
import 'package:traveltranslation/ocr/components/vip/vip_android_component.dart';
import 'package:traveltranslation/ocr/components/webview/web_view_component.dart';
import 'package:traveltranslation/ocr/helpers/intent_data_helpers.dart';
import 'package:traveltranslation/ocr/util/fluro_utils.dart';
import 'package:traveltranslation/page/mainpage/main_page.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      if(Platform.isAndroid){
        return HomeComponent();
      }else{
        return HomeComponent();
      }

});

var homeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return HomeComponent();
});
var showPictureHandler = Handler(
    type: HandlerType.route,
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String value = DataHelper.decodeData(params["imagesPath"].first);
      return ShowPicturePage(
        imagePath: value,
      );
    });

var settingHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SettingComponent();
});

var historyHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return PageHistory();
});

var vipHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  if (Platform.isAndroid) {
    return VipAndroidComponent();
  } else {
    return null;
  }
});

var loginHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginComponent();
});

var helpHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return HelpComponent();
});

var mainHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MainPage();
    });

var webViewHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String url = FluroConvertUtils.fluroCnParamsDecode((params["url"].first));

  print("解析过后的Url=$url");

  return WebViewComponent(url);
});
