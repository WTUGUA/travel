import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/components/database/ocr_database.dart';
import 'package:traveltranslation/ocr/components/database/trans_database.dart';
import 'package:traveltranslation/ocr/components/ocr/ocr_result_page.dart';
import 'package:traveltranslation/ocr/components/translate/translate_result_page.dart';
import 'package:traveltranslation/ocr/config/app_string.dart';
import 'package:traveltranslation/ocr/entity/page_history_entity.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';
import 'package:traveltranslation/ocr/widget/mycheckbox.dart';
import 'package:traveltranslation/ocr/widget/radiogroup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageHistory extends StatefulWidget {
  @override
  _PageHistoryState createState() => _PageHistoryState();
}

class _PageHistoryState extends State<PageHistory>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  var listController = new ScrollController();
  var items = <PageHistoryEntity>[];
  OcrEntityProvider dp;
  TransEntityProvider transDp;

  @override
  void initState() {
    super.initState();
    EventUtil.beginPageView("history");
    getOcrDataBase();
  }
  @override
  void dispose(){
    super.initState();
    EventUtil.endPageView("history");
  }

  Future getOcrDataBase() async {
    items.clear();
    //打开数据库
    dp = new OcrEntityProvider();
    await dp.open();
    var ocrData = await dp.getAll();
    ocrData.reversed;
    for (var item in ocrData) {
      var itemId = item[columnId] as int;
      var itemTitle = item[columnTitle] as String;
      var itemCotent = item[columnContent] as String;
      var itemImages = item[columnImages] as String;
      var decode = json.decode(itemImages);
      var pageEntity =
          new PageHistoryEntity(decode, itemTitle, 0, itemId, itemCotent, "");
      items.add(pageEntity);
    }
    setState(() {});
  }

  Future getTransDataBase() async {
    items.clear();
    //打开数据库
    transDp = new TransEntityProvider();
    await transDp.open();
    var transData = await transDp.getAll();
    transData.reversed;
    for (var item in transData) {
      var itemId = item[transcolumnId] as int;
      var itemTitle = item[transcolumnTitle] as String;
      var itemImages = item[transcolumnImages] as String;
      var itemContent = item[transcolumnContent] as String;
      var itemTransContent = item[transcolumnTransContent] as String;
      var decode = json.decode(itemImages);
      var pageEntity = new PageHistoryEntity(
          decode, itemTitle, 1, itemId, itemContent, itemTransContent);
      items.add(pageEntity);
    }
    setState(() {});
  }

  bool isEdit = false;

  Future delete() async {
    if (items.length > 0) {
      var deleteType = items[0].type;
      if (deleteType == 0) {
        for (var item in items) {
          if (item.checked) {
            await dp.delete(item.id);
          }
        }
        getOcrDataBase();
      } else if (deleteType == 1) {
        for (var item in items) {
          if (item.checked) {
            await transDp.delete(item.id);
          }
        }
        getTransDataBase();
      }
    }
  }

  Future refreshData() async {
    if (currentIndex == 0) {
      getOcrDataBase();
    } else if (currentIndex == 1) {
      getTransDataBase();
    }
  }

  static int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(AppString.history),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                for (int i = 0; i < items.length; i++) {
                  items[i].checked = false;
                }
                setState(() {
                  isEdit = !isEdit;
                });
              },
              child: isEdit
                  ? Text(
                      "取消",
                      style: TextStyle(color: Colors.red),
                    )
                  : Text("编辑"),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            RadioGroup(
              index: (index) {
                currentIndex = index;
                if (index == 0) {
                  currentIndex = 0;
                  getOcrDataBase();
                } else if (index == 1) {
                  currentIndex = 1;
                  getTransDataBase();
                }
              },
            ),
            items.length > 0
                ? Expanded(
                    flex: 1,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  child: SizedBox(
                                    width: ScreenUtil.getInstance().width,
                                    child: Container(
                                      color: Colors.white,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Visibility(
                                            child: MyCheckBox(
                                                items[index].checked, () {
                                              setState(() {
                                                items[index].checked =
                                                    !items[index].checked;
                                              });
                                            }),
                                            visible: isEdit,
                                          ),
                                          items != null && items[index] != null
                                              ? Image.file(
                                                  File(items[index].img[0]),
                                                  width: 60.0,
                                                  height: 60.0,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(),
                                          items != null && items[index] != null
                                              ? Container(
                                                  margin:
                                                      EdgeInsets.only(left: 24),
                                                  child:
                                                      Text(items[index].title),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (isEdit) {
                                      setState(() {
                                        items[index].checked =
                                            !items[index].checked;
                                      });
                                    } else {
                                      var item = items[index];

                                      if (item.type == 0) {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    OcrResultPage(
                                                      List.castFrom(item.img),
                                                      item.ocrContent,
                                                      id: item.id,
                                                    )))
                                            .then((t) {
                                          refreshData();
                                        });
                                      } else {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    TranslatePage(
                                                      List.castFrom(item.img),
                                                      item.ocrContent,
                                                      transResult:
                                                          item.transContent,
                                                      id: item.id,
                                                    )))
                                            .then((t) {
                                          refreshData();
                                        });
                                      }
                                    }
                                  },
                                );
                              },
                              itemCount: items != null ? items.length : 0,
                              controller: this.listController,
                            )),
                        Visibility(
                          visible: isEdit,
                          child: Positioned(
                              width: size.width,
                              bottom: 0.0,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xFF1C68FF)),
                                      child: FlatButton(
                                        onPressed: () {
                                          for (int i = 0;
                                              i < items.length;
                                              i++) {
                                            items[i].checked = true;
                                          }
                                          setState(() {});
                                        },
                                        child: Text(
                                          "全选",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xFF73A3FE)),
                                      child: FlatButton(
                                        onPressed: delete,
                                        child: Text(
                                          "删除",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    flex: 1,
                                  ),
                                ],
                              )),
                        )
                      ],
                    ))
                : Container(
                    margin: EdgeInsets.only(top: 50.0),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          "images/icon_empty_history.png",
                          width: 185,
                          height: 185,
                        ),
                        Text(
                          "识别过的记录会存放在这里哦~",
                          style:
                              TextStyle(color: Color(0xFF333333), fontSize: 14),
                        )
                      ],
                    ),
                  )
          ],
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
