import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';

class PaySuccessDialog extends Dialog {

  final String atTime;


  PaySuccessDialog(this.atTime);

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new SizedBox(
          width: 284.0,
          height: 259.0,
          child: new Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Image.asset(
                    "images/pic_payment_successful.png",
                    height: 125,
                    width: 125,
                  ),
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "支付成功！",
                        style: TextStyle(
                            color: AppColor.darkGray,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 25, right: 25, top: 12),
                        child: Text(
                          "会员有效期至$atTime",
                          style: TextStyle(
                            color: AppColor.darkGray,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 0.0, top: 12.0),
                          padding: EdgeInsets.only(
                              left: 18.0, right: 18.0, top: 5.0, bottom: 5.0),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: AppColor.vipSuccessGradient,
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                              borderRadius: BorderRadius.circular(16)),
                          child: Text(
                            "好的",
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
