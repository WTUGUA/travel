import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/entity/ocr_result.dart';
import 'package:traveltranslation/ocr/util/check_service_utils.dart';
import 'package:traveltranslation/ocr/util/constans.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';
import 'package:traveltranslation/ocr/widget/dialog/lead_login_dialog.dart';
import 'package:traveltranslation/ocr/widget/dialog/lead_vip_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ocr_plugin/ocr_plugin.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:traveltranslation/ocr/components/ocr/ocr_result_page.dart';

class ShowPicturePage extends StatefulWidget {
  final String imagePath;

  ShowPicturePage({@required String imagePath}) : this.imagePath = imagePath;

  @override
  _ShowPicturePageState createState() => _ShowPicturePageState();
}

class _ShowPicturePageState extends State<ShowPicturePage> {
  var value = "中英文混合";

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

  //裁剪图片
  Future _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: this.widget.imagePath,
//      ratioX: 1.0,
//      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );

    if (croppedFile != null) {
      setState(() {
        print("刷新Image");
        _image = croppedFile;
      });
    }
  }

  Future<void> initOcrSdk() async {
    print("initOcrSDK");
    String result =
        await OcrPlugin.initOcrSdk(Constants.ocr_key, Constants.ocr_secret);
    print("traveltranslation/ocr_token=$result");
  }

  ProgressDialog pr;

  @override
  void initState() {
    EventUtil.beginPageView("show_pic_page");
    _image = File(this.widget.imagePath);
    initOcrSdk();
    super.initState();
  }

  @override
  void dispose() {
    EventUtil.endPageView("show_pic_page");
    super.dispose();
  }

  initProgressDialog() {
    pr = new ProgressDialog(context);
  }

  void recognize() async {
    EventUtil.onEvent(EventUtil.aSureOcrClick);
    if (pr == null) {
      initProgressDialog();
    }
    pr.show();
    _reco();
  }

  var ocrResultMsg;

  Future _reco() async {
    print("开始识别${new DateTime.now().millisecondsSinceEpoch}");
    print("弹窗${new DateTime.now().millisecondsSinceEpoch}");
    if (LanguageUtil.languageMap.containsKey(value)) {
      //文件地址，语言
      String result = await OcrPlugin.recognize(
          _image.absolute.path, LanguageUtil.languageMap[value]);
      print("$result");
      //获取返回值信息
      var decode = json.decode(result);
      RecoResult ocrResult = RecoResult.fromJson(decode);
      if (ocrResult.returnCode == 0) {
        ocrResultMsg = ocrResult.returnMsg;
      }
    }
    pr.hide();
    //跳转到识别结果界面
    if (ocrResultMsg != null) {
      List<String> images = List();
      images.add(_image.absolute.path);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OcrResultPage(images, ocrResultMsg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: DropdownButton(
            items: getListData(),
            elevation: 0,
            underline: null,
            hint: new Text(
              '识别为$value',
              style: TextStyle(color: AppColor.textBlue, fontSize: 16.0),
            ),
            onChanged: (T) {
              //下拉菜单item点击之后的回调
              setState(() {
                value = T;
              });
            },
          ),
        ),
        body: Container(
          color: AppColor.bgColor,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Image.file(_image),
                ),
                flex: 1,
              ),
              Container(
                width: 250,
                height: 74,
                padding: EdgeInsets.only(bottom: 34),
                child: FlatButton(
                  onPressed: recognize,
                  child: Text('识别',
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
        ),
      ),
    );
  }
}
