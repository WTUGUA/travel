import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/config/application.dart';
import 'package:traveltranslation/ocr/config/routes.dart';
import 'package:traveltranslation/ocr/helpers/service_helpers.dart';
import 'package:traveltranslation/ocr/util/constans.dart';
import 'package:traveltranslation/ocr/util/fluro_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PayChoose extends StatefulWidget {
  final Function onPay;

  PayChoose({this.onPay});

  @override
  _PayChooseState createState() => _PayChooseState();
}

class _PayChooseState extends State<PayChoose> {
  bool chooseWechat = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ListTile(
          trailing: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.clear,
              size: 20.0,
            ),
          ),
          title: Text("选择支付方式"),
        ),
        InkWell(
          onTap: () {
            if (!chooseWechat) {
              print("选择了微信");
              chooseWechat = !chooseWechat;
              setState(() {

              });
            }
          },
          child: ListTile(
            trailing: chooseWechat
                ? Image.asset(
                    "images/icon_vip_select.png",
                    width: 22,
                    height: 22,
                  )
                : Image.asset(
                    "images/icon_vip_unselected.png",
                    width: 22,
                    height: 22,
                  ),
            title: Text("微信"),
            leading: Image.asset(
              "images/icon_wechat.png",
              width: 42,
              height: 42,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (chooseWechat) {
              print("选择了支付宝");
              chooseWechat = !chooseWechat;
              setState(() {});
            }
          },
          child: ListTile(
            trailing: chooseWechat
                ? Image.asset(
                    "images/icon_vip_unselected.png",
                    width: 22,
                    height: 22,
                  )
                : Image.asset(
                    "images/icon_vip_select.png",
                    width: 22,
                    height: 22,
                  ),
            title: Text("支付宝"),
            leading: Image.asset(
              "images/icon_zhifubao.png",
              width: 42,
              height: 42,
            ),
          ),
        ),
        Expanded(
          child: Container(),
          flex: 1,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
            if (chooseWechat) {
              this.widget.onPay(WechatPay);
            } else {
              this.widget.onPay(AliPay);
            }
          },
          child: Container(
            alignment: Alignment.center,
            width: ScreenUtil.instance.setWidth(670),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                    colors: AppColor.vipGradient,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            height: 45,
            child: Text(
              "立即支付",
              style: TextStyle(fontSize: 17, color: Color(0xFF5F4F4F)),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "支付即代表同意",
              style: TextStyle(fontSize: 12),
            ),
            InkWell(
              onTap: (){
                String params = FluroConvertUtils.fluroCnParamsEncode(ServiceApi.vipProtocolUrl);
                Application.router.navigateTo(context,  Routes.webView + "?url=$params");
              },
              child: Text(
                "VIP服务协议",
                style: TextStyle(fontSize: 12, color: Color(0xFFFF3800)),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
