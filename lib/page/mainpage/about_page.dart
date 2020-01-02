import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 375, height: 667)..init(context);
    // TODO: implement build
    return Scaffold(
        body: Container(
            color: AppColor.BGColor,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 30,
                  ),
                  Container(
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: (){
                            //清空输入值
                            // Navigator.pop(context);
                            Navigator.of(context).pop();
                          },
                          icon: Image(
                            image: AssetImage("images/icon_arrow_back_black.png"),
                          ),
                          iconSize: 48,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 550,
                      child:Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image(
                                width: ScreenUtil.instance.setWidth(110),
                                height: ScreenUtil.instance.setHeight(110),
                                image: AssetImage("images/logo.png"),
                              ),
                              Container(
                                height: 10,
                              ),
                              Text(
                                '版本号 1.0.0',
                                style: TextStyle(color: AppColor.privacyText1Color, fontSize: 18),
                              )
                            ],
                          )
                      )
                  )
                ],
              )
    ));
  }
}
