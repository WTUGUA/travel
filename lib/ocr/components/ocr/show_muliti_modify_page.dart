import 'dart:io';

import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/components/ocr/show_muliti_pic_page.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/util/constans.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';

class ModifyPicturePage extends StatefulWidget {
  final MultiImage multiImage;

  ModifyPicturePage(this.multiImage);

  @override
  _ModifyPicturePageState createState() => _ModifyPicturePageState();
}

class _ModifyPicturePageState extends State<ModifyPicturePage> {
  var value;

  List<DropdownMenuItem> getListData() {
    List<DropdownMenuItem> items = new List();
    LanguageUtil.languageMap.forEach((name, value) {
      var dropdownMenuItem = new DropdownMenuItem(
        child: new Text(name),
        value: name,
      );
      items.add(dropdownMenuItem);
    });
    return items;
  }

  File _image;

  @override
  void initState() {

    super.initState();
    EventUtil.beginPageView("muli_modify_page");
    _image = File(this.widget.multiImage.imagePath);
    value = this.widget.multiImage.defaultTransTo;
  }

  @override
  void dispose() {
    super.dispose();
    EventUtil.endPageView("muli_modify_page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: DropdownButton(
          items: getListData(),
          elevation: 0,
          underline: null,
          hint: new Text(
            '单张识别为$value',
            style: TextStyle(color: AppColor.darkGray, fontSize: 16.0),
          ),
          onChanged: (T) {
            //下拉菜单item点击之后的回调
            setState(() {
              value = T;
            });
          },
        ),
        actions: <Widget>[complete()],
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(left: 35.0, right: 35.0),
          child: Hero(
              tag: this.widget.multiImage.imagePath, child: Image.file(_image)),
        ),
      ),
    );
  }

  Widget complete() {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).pop(value);
      },
      child: Text(
        "完成",
        style: TextStyle(fontSize: 14.0, color: AppColor.textBlue),
      ),
    );
  }
}
