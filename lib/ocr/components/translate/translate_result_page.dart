import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traveltranslation/ocr/components/database/trans_database.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/helpers/service_helpers.dart';
import 'package:traveltranslation/ocr/util/check_service_utils.dart';
import 'package:traveltranslation/ocr/util/common_util.dart';
import 'package:traveltranslation/ocr/util/constans.dart';
import 'package:traveltranslation/ocr/entity/trans_entity.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';
import 'package:share_extend/share_extend.dart';
import 'package:toast/toast.dart';
import 'package:oktoast/oktoast.dart';

class TranslatePage extends StatefulWidget {
  final List<String> images;
  final String ocrResult;
  final String transResult;
  final int id;

  TranslatePage(this.images, this.ocrResult, {this.transResult, this.id});

  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class CustomPopupMenu {
  String title;
  String image;

  CustomPopupMenu({this.title, this.image});
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: '返回首页', image: "images/icon_backtohome.png"),
  CustomPopupMenu(title: '分享文本', image: "images/icon_sharetext.png"),
];

class _TranslatePageState extends State<TranslatePage> {
  var value = "英语";
  static String text = "";
  final TextEditingController controller =
      new TextEditingController(text: text);
  final TextEditingController controller2 =
      new TextEditingController(text: text);

  //数据库操作类
  TransEntityProvider dp;
  TransDatabase transEntity;

  List<DropdownMenuItem> getListData() {
    List<DropdownMenuItem> items = new List();
    LanguageUtil.translateMap.forEach((name, value) {
      var dropdownMenuItem = new DropdownMenuItem(
        child: Container(
          child: new Text(name),
        ),
        value: name,
      );
      items.add(dropdownMenuItem);
    });
    return items;
  }

  Future _translate() async {

    EventUtil.onEvent(EventUtil.transButtonClick);
    EventUtil.onEvent(EventUtil.transLanguageClick,label: value);
//    bool checkResult = await CheckServiceDelegate.checkService(
//        CheckServiceDelegate.translateNum);
//    if (checkResult) {
      var text = controller.text.toString();
      print(text.length);
      var translateMap = LanguageUtil.translateMap[value];
      print(translateMap);
      TransEntity transResultText = await ServiceApi.getTransResultText(
          text, LanguageUtil.translateMap[value]);
      print("打印翻译结果对象");
      print(transResultText);

      if (transResultText.error_code == null) {
        StringBuffer buffer = new StringBuffer();
        for (int i = 0; i < transResultText.trans_result.length; i++) {
          buffer.writeln(transResultText.trans_result[i].dst);
        }
        setState(() {
          controller2.text = buffer.toString();
        });
      }else{
        showToast(transResultText.error_msg,position: ToastPosition.center);
      }
      //保存翻译结果
      var images = this.widget.images;
      text = this.widget.ocrResult;
      //构建数据库对象
      if (transEntity == null && this.widget.id == null) {
        TransDatabase data = new TransDatabase();
        data.changeTime = new DateTime.now().toString();
        data.images = json.encode(images);
        data.title = controller.text.length > 10
            ? controller.text.substring(0, 9)
            : controller.text;
        data.content = controller.text;
        data.transcontent = controller2.text;
        transEntity = await dp.insert(data);
      } else {
        transEntity.id = this.widget.id;
        transEntity.changeTime = new DateTime.now().toString();
        transEntity.images = json.encode(images);
        transEntity.title = controller.text.length > 10
            ? controller.text.substring(0, 9)
            : controller.text;
        transEntity.content = controller.text;
        transEntity.transcontent = controller2.text;
        await dp.update(transEntity);
      }
  }

  @override
  void dispose() {
    super.dispose();
    EventUtil.endPageView("translate");
  }

  @override
  void initState() {
    intDatabaseAndSave();
    super.initState();

    EventUtil.beginPageView("translate");
    controller.text = this.widget.ocrResult;
    if (this.widget.transResult != null) {
      controller2.text = this.widget.transResult;
    }
  }

  Future intDatabaseAndSave() async {
    //打开数据库
    dp = new TransEntityProvider();
    await dp.open();
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
              backgroundColor: AppColor.textBlue,
              mini: true,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              onPressed: () {
                Toast.show("翻译", context);
                _translate();
              },
              child: Container(
                child: Text("翻译"),
              )),
        ],
      ),
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        centerTitle: true,
        title: DropdownButton(
          isExpanded: false,
          items: getListData(),
          elevation: 0,
          underline: null,
          hint: new Text(
            '识别为$value',
            style: TextStyle(color: Color(0xFF333333), fontSize: 16.0),
          ),
          onChanged: (T) {
            //下拉菜单item点击之后的回调
            setState(() {
              value = T;
            });
          },
        ),
        actions: <Widget>[
          PopupMenuButton<CustomPopupMenu>(
            elevation: 3.2,
            onCanceled: () {
              print('You have not chossed anything');
            },
            tooltip: 'This is tooltip',
            onSelected: null,
            itemBuilder: (BuildContext context) {
              return choices.map((CustomPopupMenu choice) {
                return PopupMenuItem<CustomPopupMenu>(
                  value: choice,
                  child: FlatButton.icon(
                      onPressed: () {
                        if (choice.title == "返回首页") {
                          print("返回首页");

                          CommonUtil.backHome(context);
                        } else if (choice.title == "分享文本") {
                          print("分享文本");
                          EventUtil.onEvent(EventUtil.transShareClick);
                          //分享文本
                          ShareExtend.share(controller2.text, "text");
                        }
                      },
                      icon: Image.asset(
                        choice.image,
                        width: 15.0,
                        height: 15.0,
                      ),
                      label: Text(choice.title)),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              flex: 4,
              child: Container(
                  padding: EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 0.0, bottom: 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(left: 17.0, top: 10.0, right: 17.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 10.0, bottom: 0.0),
                            fillColor: Colors.white,
                            border: InputBorder.none,
                          ),
                          minLines: 10,
                          controller: controller,
                          maxLines: null,
                        ),
                        flex: 1,
                      ),
                      GestureDetector(
                        onTap: () {
                          EventUtil.onEvent(EventUtil.transCopyOriClick);
                          Clipboard.setData(
                              new ClipboardData(text: controller.text));
                          showToast("原文已复制到剪切板");
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 2.0, bottom: 2.0),
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              "images/icon_copy_open.png",
                              width: 25.0,
                              height: 25.0,
                            )),
                      )
                    ],
                  ))),
          Expanded(
              flex: 5,
              child: Container(
                  padding: EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 0.0, bottom: 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(
                      left: 17.0, top: 10.0, right: 17.0, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 0.0,
                                  right: 0.0,
                                  top: 10.0,
                                  bottom: 0.0),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              hintText: "等待翻译…"),
                          minLines: 10,
                          controller: controller2,
                          maxLines: null,
                        ),
                        flex: 1,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (controller2.text != null) {
                            EventUtil.onEvent(EventUtil.transCopyClick);
                            Clipboard.setData(
                                new ClipboardData(text: controller2.text));
                            showToast("翻译结果已复制到剪切板");
                          }
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 2.0, bottom: 2.0),
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              "images/icon_copy_open.png",
                              width: 25.0,
                              height: 25.0,
                            )),
                      )
                    ],
                  ))),
        ],
      ),
    ));
  }
}
