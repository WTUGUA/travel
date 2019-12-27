import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traveltranslation/ocr/components/database/ocr_database.dart';
import 'package:traveltranslation/ocr/components/translate/translate_result_page.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/util/common_util.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';
import 'package:share_extend/share_extend.dart';
import 'package:toast/toast.dart';

class OcrResultPage extends StatefulWidget {
  final List<String> imagePaths;

  final String resultMsg;

  final int id;

  OcrResultPage(this.imagePaths, this.resultMsg, {this.id});

  @override
  _OcrResultPageState createState() => _OcrResultPageState();
}

class CustomPopupMenu {
  String title;
  String image;

  CustomPopupMenu({this.title, this.image});
}

typedef bottomClick = Function();

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: '返回首页', image: "images/icon_backtohome.png"),
  CustomPopupMenu(title: '分享文本', image: "images/icon_sharetext.png"),
];

class _OcrResultPageState extends State<OcrResultPage> {
  CustomPopupMenu _selectedChoices = choices[0];
  static String text = "";
  final TextEditingController controller =
      new TextEditingController(text: text);

  bool _showFlex = true;

// 先创建一个 controller
  var listController = new ScrollController();
  var showImages = <String>[];
  OcrEntityProvider dp;

  @override
  void initState() {
    intDatabaseAndSave();
    super.initState();
    EventUtil.beginPageView("ocr_result");
    var images = this.widget.imagePaths;

    showImages.addAll(images);
    setState(() {
      controller.text = this.widget.resultMsg;
    });
  }


  @override
  void dispose() {
    super.dispose();
    EventUtil.endPageView("ocr_result");
  }

  OcrDatabase saveEntity;

  Future intDatabaseAndSave() async {
    //打开数据库
    dp = new OcrEntityProvider();
    await dp.open();
    var images = this.widget.imagePaths;
    text = this.widget.resultMsg;

    //构建数据库对象
    OcrDatabase data = new OcrDatabase();
    data.changeTime = new DateTime.now().toString();
    data.images = json.encode(images);
    data.title = text.length > 10 ? text.substring(0, 9) : text;
    data.content = text;

    if (this.widget.id != null) {
      data.id = this.widget.id;
      await dp.update(data);
      saveEntity = await dp.getTodo(data.id);
    } else {
      saveEntity = await dp.insert(data);
    }
  }

  void _select(CustomPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
    });
  }

  void _hidePreview() {
    setState(() {
      _showFlex = !_showFlex;
    });
  }

  Future<bool> back() async {
    if (dp != null && saveEntity != null) {
      saveEntity.changeTime = new DateTime.now().toString();
      saveEntity.content = controller.text;
      saveEntity.title = controller.text.length > 10
          ? controller.text.substring(0, 9)
          : controller.text;
      await dp.update(saveEntity);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).accentColor;
    print("接收到的识别结果${this.widget.resultMsg}");
    return WillPopScope(
      onWillPop: back,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("识字结果"),
          actions: <Widget>[
            PopupMenuButton<CustomPopupMenu>(
              elevation: 3.2,
              onCanceled: () {
                print('You have not chossed anything');
              },
              tooltip: 'This is tooltip',
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.map((CustomPopupMenu choice) {
                  return PopupMenuItem<CustomPopupMenu>(
                    value: choice,
                    child: FlatButton.icon(
                        onPressed: () {
                          if (choice.title == "返回首页") {
                            CommonUtil.backHome(context);
                          } else if (choice.title == "分享文本") {
                            EventUtil.onEvent(EventUtil.resultShareClick);
                            ShareExtend.share(controller.text, "text");
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
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: controller,
                    maxLines: null,
                  ),
                )),
            Visibility(
              child: Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(File(showImages[index])),
                        );
                      },
                      itemCount: showImages.length,
                      controller: this.listController,
                    )),
                flex: 1,
              ),
              visible: _showFlex,
            ),
            Container(
              color: AppColor.bgColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButtonColumn(color, "images/icon_translation.png", '翻译',
                      () {
                    EventUtil.onEvent(EventUtil.resultTransClick);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TranslatePage(
                            this.widget.imagePaths, controller.text)));
                  }),
                  _buildButtonColumn(color, "images/icon_copy_open.png", '复制',
                      () {
                    EventUtil.onEvent(EventUtil.resultCopyClick);
                    Clipboard.setData(new ClipboardData(text: controller.text));
                    Toast.show("已复制到剪切板", context);
                  }),
                  _buildButtonColumn(
                      color, "images/icon_proofreading.png", '校对', () {
                    EventUtil.onEvent(EventUtil.resultCheckClick);
                    _hidePreview();
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell _buildButtonColumn(
      Color color, String assetsName, String label, Function function) {
    return InkWell(
        onTap: function,
        child: Padding(
          padding:
              EdgeInsets.only(left: 20.0, top: 2.0, bottom: 2.0, right: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                assetsName,
                width: 27.0,
                height: 27.0,
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
