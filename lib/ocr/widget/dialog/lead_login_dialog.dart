import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/config/application.dart';
import 'package:traveltranslation/ocr/config/routes.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';

class LeadLoginDialog extends Dialog {

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new SizedBox(
          width: 284.0,
          height: 290.0,
          child: new Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 22,
                      width: 22,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Image.asset(
                        "images/icon_pic_login.png",
                        height: 84,
                        width: 99,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 7, right: 7),
                        child: Image.asset(
                          "images/icon_toast_close.png",
                          height: 24,
                          width: 24,
                        ),
                      ),
                    )
                  ],
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "登录领取更多权益",
                        style: TextStyle(
                            color: AppColor.darkGray,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 25, right: 25, top: 9),
                        child: Text(
                          "登录用户可领取更多拍照识字、翻译次数，还有批量识别等权益等着你哦~",
                          style: TextStyle(
                            color: AppColor.darkGray,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 25, right: 25),
                        child: Text(
                          "(提示：登录账号有助于在更换设备、或者更换其他操作系统设备时，同步您的购买状态)",
                          style: TextStyle(
                            color: Color(0xff7A7A7A),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          EventUtil.onEvent(EventUtil.aSurePopLoginClick);
                          Application.router
                              .navigateTo(context, Routes.settingLogin)
                              .then((value) {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15.0, top: 20.0),
                          padding: EdgeInsets.only(
                              left: 18.0, right: 18.0, top: 5.0, bottom: 5.0),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: AppColor.buttonGradient,
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                              borderRadius: BorderRadius.circular(16)),
                          child: Text(
                            "登录",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
