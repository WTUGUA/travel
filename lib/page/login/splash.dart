import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_splashview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/ocr/config/application.dart';
import 'package:traveltranslation/ocr/util/navo_kv_utils.dart';
import 'package:traveltranslation/page/login/privacy.dart';
import 'package:traveltranslation/utils/travel_kv_utils.dart';
import 'package:traveltranslation/utils/travelsp.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool sp = false;

  @override
  void initState() {
    TravelOnlineConfigUtils.getInstance().init();
    getPrivacy();
    super.initState();
  }

  void getPrivacy() async {
    bool privacy = await TravelSP.getPrivacy();
    if (privacy == false) {
      setState(() {
        sp = false;
      });
    } else {
      setState(() {
        sp = true;
      });
    }
//    //获取KV键值对
//    String ys=await OnlineConfigUtils.getInstance().getConfigParams("ocr_num");
//    int private=int.parse(ys);
//    print("测试类"+ys);
//    int code=await TravelSP.getCode();
//    if(code<private){
//      setState(() {
//        sp=false;
//      });
//      TravelSP.saveCode(private);
//    }

  }

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
          child: AdsSplashView(
            //appid:"com.appvvv.ocr",
            //IOS端需要配置广告ID android端不需要
            asdIsFinish: () {
              //  跳转到隐私或者主界面
              if (sp) {
                Application.router
                    .navigateTo(context, "/mainview", clearStack: true);
              } else {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new Privacy()));
              }
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              top: ScreenUtil.instance.setHeight(20),
              left: ScreenUtil.instance.setWidth(110),
              right: ScreenUtil.instance.setWidth(81)),
          child: Row(
            //ICon和APPname
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: ScreenUtil.instance.setHeight(60),
                width: ScreenUtil.instance.setWidth(60),
                child: Image(
                    width: ScreenUtil.instance.setWidth(60),
                    height: ScreenUtil.instance.setHeight(60),
                    image: AssetImage("images/splash_logo.png"),
                    ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: ScreenUtil.instance.setWidth(15)),
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
