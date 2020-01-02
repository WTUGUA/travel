import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:traveltranslation/ocr/components/ocr/ocr_result_page.dart';
import 'package:traveltranslation/ocr/components/ocr/show_muliti_modify_page.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/entity/ocr_result.dart';
import 'package:traveltranslation/ocr/util/check_service_utils.dart';
import 'package:traveltranslation/ocr/util/constans.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';
import 'package:traveltranslation/ocr/widget/dialog/lead_login_dialog.dart';
import 'package:traveltranslation/ocr/widget/dialog/lead_vip_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocr_plugin/ocr_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ShowMultiPicturePage extends StatefulWidget {
  final List<String> imagePaths;

  static String initTransTo = "中英文混合";

  ShowMultiPicturePage({this.imagePaths});

  @override
  _ShowMultiPicturePageState createState() => _ShowMultiPicturePageState();
}

class MultiImage {
  String imagePath;
  String defaultTransTo = ShowMultiPicturePage.initTransTo;

  MultiImage({this.imagePath});
}

class _ShowMultiPicturePageState extends State<ShowMultiPicturePage> with AutomaticKeepAliveClientMixin{
  var value = "中英文混合";

  bool showDelete = false;

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

  Future<void> initOcrSdk() async {
    print("initOcrSDK");
    String result =
        await OcrPlugin.initOcrSdk(Constants.ocr_key, Constants.ocr_secret);
    print("traveltranslation/ocr_token=$result");
  }

  ProgressDialog pr;

  List<MultiImage> showImages = new List();

  @override
  void initState() {

    EventUtil.beginPageView("show_muliti_pic_page");
    initOcrSdk();
    if (this.widget.imagePaths.length > 0) {
      for (int i = 0; i < widget.imagePaths.length; i++) {
        showImages.add(MultiImage(imagePath: widget.imagePaths[i]));
      }
    }
    setState(() {});
    print(showImages);
    super.initState();
  }

  @override
  void dispose() {
    EventUtil.endPageView("show_muliti_pic_page");
    super.dispose();
    if (tempPath != null) {
      deleteFile();
    }
  }
  initProgressDialog() {
    pr = new ProgressDialog(context);
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
    );
    print(file.lengthSync());
    print(result.lengthSync());
    return result;
  }

  var tempPath;

  //压缩图片再识别
  Future recognize() async {
    EventUtil.onEvent(EventUtil.aSureOcrClick);
//    bool checkResult =
//        await CheckServiceDelegate.checkService(CheckServiceDelegate.batchNum);
//    if (checkResult) {
      Directory tempDir = await getTemporaryDirectory();
      tempPath = tempDir.path;
      if (pr == null) {
        initProgressDialog();
      }
      pr.show();
      List<String> images = List();
      StringBuffer buffer = new StringBuffer();
      for (var item in showImages) {
        DateTime now = new DateTime.now();
        images.add(item.imagePath);
        File a = await testCompressAndGetFile(
            File(item.imagePath), "$tempPath+{$now.millisecondsSinceEpoch}");
        item.imagePath = a.absolute.path;
        String result = await OcrPlugin.recognize(
            item.imagePath, LanguageUtil.languageMap[item.defaultTransTo]);
        var decode = json.decode(result);
        RecoResult ocrResult = RecoResult.fromJson(decode);
        if (ocrResult.returnCode == 0) {
          buffer.writeln(ocrResult.returnMsg);
        } else {
          print("翻译失败");
        }
      }
      pr.hide();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OcrResultPage(images, buffer.toString())));
//    } else {
//      //引导用户登录
//      if (UserDelegate.getUserState() == UserStatus.GUEST) {
//        EventUtil.onEvent(EventUtil.aSurePopLoginPageView);
//        showDialog<Null>(
//            context: context, //BuildContext对象
//            barrierDismissible: false,
//            builder: (BuildContext context) {
//              return new LeadLoginDialog();
//            });
//      } else if (UserDelegate.getUserState() == UserStatus.GENERAL) {
//        SpUtils.getUserMap().then((value) {
//          var ocrNum = value.analysis.ocrMaxNum;
//          var transNum = value.analysis.translateMaxNum;
//          var batchNum = value.analysis.batchMaxNum;
//          //提示用户升级未VIP
//          showDialog<Null>(
//              context: context, //BuildContext对象
//              barrierDismissible: false,
//              builder: (BuildContext context) {
//                return new LeadVipDialog(ocrNum, transNum, batchNum);
//              });
//        });
//      }
//    }
  }


  Future deleteFile() async {
    await new File(tempPath).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: DropdownButton(
          items: getListData(),
          elevation: 0,
          underline: null,
          hint: new Text(
            '批量识别为$value',
            style: TextStyle(color: AppColor.darkGray, fontSize: 16.0),
          ),
          onChanged: (T) {
            //下拉菜单item点击之后的回调
            setState(() {
              value = T;
              showImages.forEach((data) {
                data.defaultTransTo = value;
              });
            });
          },
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: showDelete
                ? () {
                    setState(() {
                      showDelete = false;
                    });
                  }
                : recognize,
            child: showDelete
                ? Text("取消",
                    style: TextStyle(fontSize: 14.0, color: Color(0xFF1C68FF)))
                : Text(
                    "识别",
                    style: TextStyle(fontSize: 14.0, color: Color(0xFF1C68FF)),
                  ),
          )
        ],
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 15.0, top: 14.0),
            alignment: Alignment.centerLeft,
            child: Text("提示：点击图片可进入详情页切换识别语言"),
          ),
          Expanded(
            child: GridView.builder(
                padding: EdgeInsets.all(12.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 12.0),
                itemCount: showImages.length,
                itemBuilder: (context, index) {
                  return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  color: Color(0xFFD8D8D8),
                                ),
                                Positioned(
                                    child: GestureDetector(
                                        onLongPress: () {
                                          setState(() {
                                            showDelete = true;
                                          });
                                        },
                                        onTap: () {
                                          if (!showDelete) {
                                            print('跳转到编辑页面');
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        ModifyPicturePage(
                                                            showImages[index])))
                                                .then((boo) {
                                              if (boo != null) {
                                                showImages[index]
                                                    .defaultTransTo = boo;
                                                setState(() {});
                                              }
                                            });
                                          }
                                        },
                                        child: Hero(
                                            tag: showImages[index].imagePath,
                                            child: Image.file(
                                              File(showImages[index].imagePath),
                                              fit: BoxFit.fill,
                                              height: ScreenUtil.instance
                                                  .setHeight(130.0),
                                              width: ScreenUtil.instance
                                                  .setWidth(130.0),
                                            )))),
                                Visibility(
                                    visible: showDelete,
                                    child: Positioned(
                                        top: -15.0,
                                        right: -15.0,
                                        child: IconButton(
                                            color: Colors.blue,
                                            icon: Image.asset(
                                              "images/icon_delete_pic.png",
                                              width: 18.0,
                                              height: 18.0,
                                            ),
                                            onPressed: () {
                                              print("删除$index");
                                              showImages.removeAt(index);
                                              setState(() {});
                                            })))
                              ],
                            ),
                          ),
                          Text(showImages[index].defaultTransTo == null
                              ? "英文"
                              : showImages[index].defaultTransTo)
                        ],
                      ));
                }),
            flex: 1,
          )
        ],
      )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
