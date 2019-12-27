import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/config/application.dart';
import 'package:traveltranslation/ocr/config/routes.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';

// ignore: must_be_immutable
class LeadVipDialog extends Dialog {

  final num PaddingContent = 6.0;

  final int ocrNum;

  final int transNum;

  final int batchNum;

  LeadVipDialog(this.ocrNum, this.transNum, this.batchNum);

  @override
  Widget build(BuildContext context) {
    EventUtil.onEvent(EventUtil.vipPopPageView);
    return Theme(
        data: ThemeData(textTheme: TextTheme(body1: TextStyle(fontSize: 13))),
        child: new Material(
          //创建透明层
          type: MaterialType.transparency, //透明类型
          child: new Center(
              //保证控件居中效果
              child: Stack(
            children: <Widget>[
              new SizedBox(
                width: 240,
                height: 370,
                child: new Container(
                  decoration: ShapeDecoration(
                    color: Color(0xFFFFFEF8),
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
                            child: Image.asset(
                              "images/icon_vip2.png",
                              height: 125,
                              width: 125,
                            ),
                          ),
                          GestureDetector(
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
                            Text(
                              "今日免费次数已用完",
                              style: TextStyle(
                                  color: AppColor.leadVipDialogColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFFAED),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0)),
                                  border: Border.all(
                                      color: AppColor.leadVipBorderColor)),
                              child: Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FixedColumnWidth(110.0),
                                  1: FixedColumnWidth(100.0),
                                },
                                border: TableBorder(
                                    verticalInside: BorderSide(
                                        color: AppColor.leadVipBorderColor)),
                                children: <TableRow>[
                                  TableRow(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(PaddingContent),
                                        child: Text('普通用户每天：',
                                            style: TextStyle(
                                                color:
                                                    AppColor.leadVipTextColor,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(PaddingContent),
                                        child: Text('$transNum次翻译机会'),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(PaddingContent),
                                        child: Text(''),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(PaddingContent),
                                        child: Text('$ocrNum次拍照识字'),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      Text(''),
                                      Container(
                                        margin: EdgeInsets.all(PaddingContent),
                                        child: Text('$batchNum次批量识字'),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            color: AppColor.leadVipBorderColor),
                                      ),
                                    ),
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(PaddingContent),
                                        child: Text(
                                          'VIP会员每天：',
                                          style: TextStyle(
                                              color: AppColor.leadVipTextColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(PaddingContent),
                                        child: Text('无次数限制'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "点击成为会员查看更多会员权限",
                                  style: TextStyle(
                                      color: Color(0xFF654920), fontSize: 13),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                EventUtil.onEvent(EventUtil.vipPopOkClick);
                                Application.router
                                    .navigateTo(context, Routes.vip)
                                    .then((value) {
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 17.0,
                                    right: 17.0,
                                    top: 5.0,
                                    bottom: 5.0),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: AppColor.vipButtonGradient,
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  "成为会员",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ));
  }
}
