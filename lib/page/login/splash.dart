import 'package:flutter/material.dart';
//import 'package:flutter_ads/ads_splashview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/ocr/config/application.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 375, height: 667)..init(context);
    // TODO: implement build
    return Scaffold(
        body: Container(
      child: Column(children: <Widget>[
        Container(
          //广告容器
          height: ScreenUtil.instance.setHeight(567),
          color: Colors.grey,
//          child:  AdsSplashView(
//            asdIsFinish: () {
//              Application.router.navigateTo(context, "/mainview", clearStack: true);
//            },
//          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 20, left: 110, right: 81),
          child: Row(
            //ICon和APPname
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: ScreenUtil.instance.setHeight(60),
                width: ScreenUtil.instance.setWidth(60),
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(14.0),
                    child: Image(
                        width: ScreenUtil.instance.setWidth(60),
                        height: ScreenUtil.instance.setHeight(60),
                        image: AssetImage("images/meizi.png"),
                        fit: BoxFit.cover),
                  )
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  '旅游翻译软件',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ]),
    ));
  }
}
