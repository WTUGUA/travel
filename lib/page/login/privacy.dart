import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/ocr/config/application.dart';
import 'package:traveltranslation/utils/travelsp.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';

class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    // TODO: implement build
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(60)),
        color: AppColor.white,
        child: Column(
          children: <Widget>[
            //图片容器
            Container(
              height: ScreenUtil.instance.setHeight(116),
              width: ScreenUtil.instance.setWidth(169),
              color: AppColor.white,
              child: Image.asset('images/icon_privacy.png'),
            ),
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(15)),
              child: Text(
                '隐私政策',
                style:
                    TextStyle(fontSize: 24, color: AppColor.privacyText1Color),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(30), left: ScreenUtil.instance.setWidth(30), right:ScreenUtil.instance.setWidth(30)),
              child: RichText(
                text: TextSpan(
                  text: '欢迎使用“旅行翻译”!我们非常重视您的个人信息和隐私保护。在您使用“连续性翻译”服务之前，请仔细阅读并同意',
                  style: TextStyle(fontSize: 15, color: AppColor.privacyText1Color),
                  children: [
                    TextSpan(
                      text: '"服务条款"',
                      style: TextStyle(fontSize: 15, color: AppColor.privacyColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                        //设置页面跳转


                          print('点击了服务条款');
                        },
                    ),
                    TextSpan(
                      text: '和',
                      style: TextStyle(fontSize: 15, color: AppColor.privacyText1Color),
                    ),
                    TextSpan(
                      text: '"隐私政策"',
                      style: TextStyle(fontSize: 15,  color: AppColor.privacyColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                        //设置页面跳转


                          print('点击了隐私政策');
                        },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(30), left: ScreenUtil.instance.setWidth(30), right: ScreenUtil.instance.setWidth(30)),
              child: Text("声明：在使用“旅行翻译”时，我们不会向服务器上传并保存您的输入信息。",
                  style: TextStyle(fontSize: 15, color: AppColor.privacyText1Color)
            ),
            ),
            Container(
              padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(15), left: ScreenUtil.instance.setWidth(30), right: ScreenUtil.instance.setWidth(30)),
              child: Text("如您同意此政策，请点击“同意”并开始使用我们的产品和服务，我们尽全力保护您的个人信息安全。",
                  style: TextStyle(fontSize: 13, color: AppColor.privacyTextColor)
              ),
            ),
        Container(
          height: ScreenUtil.instance.setHeight(126),
          width: ScreenUtil.instance.setWidth(375),
           padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(82), left: ScreenUtil.instance.setWidth(30), right: ScreenUtil.instance.setWidth(30)),
               child: FlatButton(
                  onPressed: (){
                    TravelSP.savePrivacy(true);
                    Application.router.navigateTo(
                        context, "/mainview", clearStack: true);
                  },
                  child: Text('同意',
                      style: TextStyle(fontSize: 17, color: AppColor.white)
                  ),
                  color: AppColor.privacyColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                ),
        ),
            Container(
              height: ScreenUtil.instance.setHeight(59),
              width: ScreenUtil.instance.setWidth(375),
              padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(15), left: ScreenUtil.instance.setWidth(30), right: ScreenUtil.instance.setWidth(30)),
              child: FlatButton(
                onPressed: () async {
                  TravelSP.savePrivacy(false);
                  //退出界面
                  await pop();
                },
                child: Text('不同意',
                    style: TextStyle(fontSize: 17, color: AppColor.privacyTextColor)
                ),
                color: AppColor.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

}
