

import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';

class OfflineDialog extends Dialog {

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new SizedBox(
          width: 250.0,
          height: 250.0,
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
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 25, right: 25, top: 9),
                        child: Text(
                          "离线翻译服务暂时还未开通，后台正在努力中~",
                          style: TextStyle(
                            color: AppColor.darkGray,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                            Navigator.of(context).pop();
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
                            "确认",
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
