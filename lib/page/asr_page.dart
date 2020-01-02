import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/anim/animtest_page.dart';
import 'package:traveltranslation/anim/test.dart';
import 'package:traveltranslation/db/database_history.dart';
import 'package:traveltranslation/model/asr.dart';
import 'package:traveltranslation/model/history.dart';
import 'package:traveltranslation/model/word.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/page/detail_page.dart';
import 'package:traveltranslation/page/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traveltranslation/utils/event_bus.dart';
import 'package:traveltranslation/utils/travelsp.dart';

class AsrTest extends StatefulWidget {
  @override
  _AsrTestState createState() => _AsrTestState();
}

class _AsrTestState extends State<AsrTest> {
  static const platform = const MethodChannel('samples.flutter.io/asr');
  MethodChannel _methodChannel = MethodChannel("MethodChannelPlugin");
  DatabaseHelper_history databaseHelper = DatabaseHelper_history();
  String from = "zh";
  String to = "en";
  String checktext="开始";
  String TextFrom = "请开始说话";
  String TextTo = "you can speak now";
  bool start = false;


  @override
  void initState() {
    getdata();
    _methodChannel.setMethodCallHandler((handler) =>
        Future<Map>(() {
          //监听native发送的方法名及参数
          switch (handler.method) {
            case "result":
            //可获取到值
              print("测试获取值_methodChannel：${handler}");
              _send(handler.arguments); //handler.arguments表示native传递的方法参数
              break;
          }
          return handler.arguments;
        }));
//    super.initState();
  }

  //native调用的flutter方法改变参数
  void _send(arg) {
    print("测试arg的输出值：$arg");
    var map = arg;
    print(map.length);
    String test = map["resultFrom"];
    String text2 = map["resultTo"];
    print(test);
    print(text2);
    setState(() {
      //设置结果值
      TextFrom = map["resultFrom"];
      TextTo = map["resultTo"];
      History history = new History(TextFrom, TextTo, 0);
      databaseHelper.insertHistory(history);
      eventBus.fire(ListEvent("change"));
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) =>
              new DetailPage(
                word: history,
              )));
      //
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    // TODO: implement build
    return Container(
      height: ScreenUtil.instance.setHeight(300),
      decoration: BoxDecoration(
          color: AppColor.BGColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25),),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: ScreenUtil.instance.setHeight(20),
            child:Container(
              height: ScreenUtil.instance.setHeight(280),
              width: ScreenUtil.instance.setWidth(360),
              decoration: BoxDecoration(
                color: AppColor.BGColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25),),
              ),
              child:
              WaveLoadingWidget(
                backgroundColor: AppColor.white,
                foregroundColor: Colors.brown,
                waveColor: Colors.amberAccent,
              ),
            ),
          ),
          Positioned(
            top: ScreenUtil.instance.setHeight(40),
            left: ScreenUtil.instance.setWidth(145),
            child: Text(
              '请讲中文',
              style: TextStyle(
                  color: AppColor.privacyText1Color,
                  fontSize: 20.0),
            ),
          ),
          Positioned(
            top: ScreenUtil.instance.setHeight(210),
            left: ScreenUtil.instance.setWidth(115),
            child: Container(
              height: ScreenUtil.instance.setHeight(44),
              width: ScreenUtil.instance.setWidth(140),
              //color: AppColor.privacyColor,
              child: FlatButton(
                  onPressed: () {
                    if (start == false) {
                      setState(() {
                        _setstart(from, to);
                        start = true;
                        Toast.toast(context,msg: "开始语音识别",position: ToastPostion.center);
                        checktext="完成";
                      });
                    } else {
                      setState(() {
                        _setstop();
                        start = false;
                        checktext="开始";
                      });
                    }
                  },
                  child: Text(checktext,
                      style: TextStyle(color: AppColor.white)),
                  color: start?AppColor.privacyColor:AppColor.privacyTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(25)),
                  )),
            ),
          ),
          Positioned(
            top: ScreenUtil.instance.setHeight(10),
            left: ScreenUtil.instance.setWidth(320),
            child: IconButton(
                padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(20)),
                onPressed: () {
                  //退出界面
                  Navigator.of(context).pop();
                },
                icon: Image(
                  image: AssetImage("images/icon_close_black.png"),
                )),
          ),
        ],
      ),
    );
  }

  //传值开启语音输入
  Future<Null> _setstart(String From, String To) async {
    //添加IOS与android的区分调用
    if(Platform.isAndroid) {
      // ASR asr=new ASR(from,to,"start");
      Map<String, Object> map = {"from": From, "to": To};
      String result2 = "";
      //  Toast.toast(context,msg: "请求访问失败",position: ToastPostion.bottom);
      try {
        //尝试传值测试指定传 实际需要传递map（源语言 目标语言 开始信息）
        final String result = await platform.invokeMethod("start", map);
        result2 = result;
      } on PlatformException catch (e) {
        result2 = "Failed to get battery level: '${e.message}'.";
      }
    }else{
      //iOS端调用语音翻译

    }
  }

//结束语音识别
  Future<Null> _setstop() async {
    //添加IOS与android的区分调用
    if(Platform.isAndroid) {
      String result1;
      try {
        //Toast.toast(context,msg: "请求访问失败",position: ToastPostion.bottom);
        final String result = await platform.invokeMethod('stop');
        result1 = result;
        print(result);
      } on PlatformException catch (e) {
        result1 = "Failed to get battery level: '${e.message}'.";
      }
    }else{
      //IOS调用语音翻译


    }
  }

  void getdata() async {
    String fromValue = await TravelSP.getFromValue();
    String toValue = await TravelSP.getToValue();
    setState(() {
      from = fromValue;
      to = toValue;
    });
  }
}

