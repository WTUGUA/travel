import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/config/application.dart';
import 'package:traveltranslation/ocr/config/routes.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';
import 'package:traveltranslation/page/toast.dart';

class FeedbackDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new SizedBox(
          width: 240.0,
          height: 250.0,
          child: new Container(
            decoration: ShapeDecoration(
              color: AppColor.white,
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
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        '反馈意见',
                        style: TextStyle(
                          color: AppColor.darkGray,
                          fontSize: 20,
                        ),
                      )
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
                Container(
                  height: 20,
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "请添加我们的在线客服：",
                        style: TextStyle(
                            color: AppColor.darkGray,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 25, right: 25, top: 9),
                        child: Text(
                          "QQ:3607799199",
                          style: TextStyle(
                            color: AppColor.darkGray,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                      ),
                      Container(
                        width: 180,
                        height: 74,
                        padding: EdgeInsets.only(bottom: 34),
                        child: FlatButton(
                          onPressed: (){
                            Clipboard.setData(new ClipboardData(text: "3607799199"));
                            Toast.toast(context,msg: "已复制到剪辑板",position: ToastPostion.bottom);
                          },
                          child: Text('复制QQ号',
                              style: TextStyle(color: AppColor.white, fontSize: 16)),
                          color: AppColor.privacyColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              )),
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
