//import 'package:flutter/material.dart';
//import 'package:traveltranslation/ocr/config/app_color.dart';
//import 'package:traveltranslation/ocr/config/application.dart';
//import 'package:traveltranslation/ocr/util/ipa_utils.dart';
//import 'package:traveltranslation/ocr/util/navo_kv_utils.dart';
//import 'package:traveltranslation/ocr/util/umeng_event_util.dart';
//import 'package:traveltranslation/ocr/util/user_utils.dart';
//
//class AppComponent extends StatefulWidget {
//  @override
//  _AppComponentState createState() => _AppComponentState();
//}
//
//class _AppComponentState extends State<AppComponent> {
//  @override
//  void initState() {
//    super.initState();
//    UserDelegate.getUserInfo();
//    //初始化线上配置
//    OnlineConfigUtils.getInstance().init();
//    //初始化umeng
//    EventUtil.init();
//    //初始化商品列表
//    //IpaUtils.initStoreInfo();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final app = MaterialApp(
//      title: '旅行翻译器',
//      debugShowCheckedModeBanner: false,
//      theme: ThemeData(
//        primaryColor: Colors.white,
//        dividerColor: AppColor.divider,
//        scaffoldBackgroundColor: AppColor.paper,
//        textTheme: TextTheme(body1: TextStyle(color: AppColor.darkGray)),
//      ),
//      onGenerateRoute: Application.router.generator,
//    );
//    return app;
//  }
//}
