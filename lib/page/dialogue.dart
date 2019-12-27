import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/anim/waveanim.dart';
import 'package:traveltranslation/db/database_history.dart';
import 'package:traveltranslation/model/history.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traveltranslation/utils/event_bus.dart';
import 'package:traveltranslation/utils/travelsp.dart';

class Dialogue extends StatefulWidget {
  @override
  _DialogueState createState() => _DialogueState();
}

class _DialogueState extends State<Dialogue> {
  static const platform = const MethodChannel('samples.flutter.io/asr');
  MethodChannel _methodChannel = MethodChannel("MethodChannelPlugin");
  DatabaseHelper_history databaseHelper = DatabaseHelper_history();
  FocusNode EnfocusNode = new FocusNode();
  FocusNode ZhfocusNode = new FocusNode();
  String traveltranslation = "没有翻译结果";
  String from = "zh";
  String to = "en";
  String From="中文";
  String To="英语";
  String TextFrom="请开始说话";
  String TextTo="you can speak now";
  int reversal = 0;
  bool cancel = true;
  bool retract = false;
  bool start = false;
  bool startFrom = false;
  bool startTo = false;
  double textheight = 250;
  //默认初始值为0.0
  double waterHeight=0.0;
  WaterController waterController=WaterController();
  final TextEditingController Encontroller = TextEditingController();
  final TextEditingController Zhcontroller = TextEditingController();

  //获取android传递来的值
  @override
  void initState() {
    getdata();
    //获取参数
    _methodChannel.setMethodCallHandler((handler) =>
        Future<Null>(() {
          //监听native发送的方法名及参数
          switch (handler.method) {
            case "result":
              print("_methodChannel：${handler}");
              print("_methodChannel：$handler");
              _send(handler.arguments); //handler.arguments表示native传递的方法参数
              break;
          }
        }));
    //动画控制器
    WidgetsBinding widgetsBinding=WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback){
      //这里写你想要显示的百分比
      waterController.changeProgressRate(0.00);
     // waterController.setStop();
    });
    super.initState();
  }

  //设置值改变
  void _send(arg) {
    print("测试类$arg");
    var map = arg;
    print("测试" + TextFrom);
    print("测试" + TextTo );
    setState(() {
      //设置结果值
      TextFrom = map["resultFrom"];
      TextTo = map["resultTo"];
      SaveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    Encontroller.addListener(() {});
    Zhcontroller.addListener(() {});
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              color: AppColor.dialogueColor,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      padding: EdgeInsets.only(top: 30.0),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon:Image(
                        image: AssetImage(
                            "images/icon_arrow_back_white.png"),
                      )
                  ),
                  IconButton(
                      padding: EdgeInsets.only(right: 5.0,top: 30.0),
                      onPressed: () {
                        if (reversal == 0) {
                          setState(() {
                            reversal = 2;
                            cancel = false;
                            //  istrue=false;
                          });
                        } else {
                          setState(() {
                            reversal = 0;
                            cancel = true;
                            //  istrue=false;
                          });
                        }
                      },
                      icon:cancel?Image(
                        image: AssetImage(
                            "images/dialog_icon_roate_1.png"),
                      ):Image(
                        image: AssetImage(
                            "images/dialog_icon_roate_2.png"),
                      )
                  ),
                ],
              ),
            ),
            RotatedBox(
              quarterTurns: reversal,
              child: Column(
                children: <Widget>[
                  Container(
                    color: AppColor.dialogueColor,
                      height: ScreenUtil.instance.setHeight(textheight),
                      padding: EdgeInsets.only(left: 15.0, top: 5.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                focusNode: EnfocusNode,
                                controller: Encontroller,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: TextTo),
                                style: TextStyle(
                                    color: AppColor.LoginTextColor, fontSize: 25.0),
                                maxLines: 999,
                                cursorColor: Colors.blue[500],
                                cursorWidth: 2.0,
                                onSubmitted: (text) {},
                                onTap: () {
                                  setState(() {
                                    textheight = 250;
                                    //  istrue=false;
                                  });
                                },
                              ),
                            ),
                          ])),
                ],
              ),
            ),
            //贝塞尔曲线动画
            RotatedBox(
           quarterTurns: 2,
           child: Container(
              height: ScreenUtil.instance.setHeight(60),
              color: AppColor.white,
             padding: EdgeInsets.only(top: 20),
              child:WaveProgressBar(
                flowSpeed: 0.5,
                waveDistance:45.0,
                waterColor: AppColor.dialogueColor,
                //strokeCircleColor: Color(0x50e16009),
                progressController: waterController,
                percentage: waterHeight,
                size: new Size (400,30), textStyle: null,
              ),
             // child: Divider(height: 1.0, indent: 0.0, color: Colors.black54),
            ),
            ),
            Container(
                height: ScreenUtil.instance.setHeight(220),
                padding: EdgeInsets.only(left: 15.0, top: 5.0),
                color: AppColor.white,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          focusNode: ZhfocusNode,
                          controller: Zhcontroller,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: TextFrom),
                          style: TextStyle(color: AppColor.privacyText1Color, fontSize: 18.0),
                          maxLines: 999,
                          cursorColor: Colors.blue[500],
                          cursorWidth: 2.0,
                          onSubmitted: (text) {},
                          onTap: () {
                            setState(() {
                              textheight = 150;
                            });
                          },
                        ),
                      ),
                      Offstage(
                        offstage: false,
                        child: IconButton(
                          // padding: EdgeInsets.only(left: 5.0),
                          onPressed: () {
                           // Navigator.of(context).pop();
                            Zhcontroller.clear();
                          },
                          icon: Image(
                            image: AssetImage(
                                "images/icon_close_gray.png"),
                          )
                        ),
                      )
                    ])),

            Expanded(
                child: Container(
                    color: AppColor.white,
                  padding: EdgeInsets.only(top: 5),
                    child: Stack(children: <Widget>[
                      Positioned(
                        top: 20,
                        left: 30,
                        child: Container(
                          height: ScreenUtil.instance.setHeight(44),
                          width: ScreenUtil.instance.setWidth(134),
                          child: FlatButton(
                            onPressed: () {
                              //启动语音翻译
                              if (start == false) {
                                _setstart(from,to);
                                waterController.setStart();
                                setState(() {
                                  start = true;
                                  startFrom = true;
                                });
                              } else {
                                _setstop();
                                waterController.setStop();
                                setState(() {
                                  start = false;
                                  startFrom = false;
                                });
                              }
                            },
                            child: Text(
                              From,
                              style: TextStyle(color: AppColor.white),
                            ),
                            color: startFrom
                                ? AppColor.privacyColor
                                : AppColor.LoginTextColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    bottomLeft: Radius.circular(25))),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 30,
                        top: 20,
                        child: Container(
                          height: ScreenUtil.instance.setHeight(44),
                          width: ScreenUtil.instance.setWidth(134),
                          child: FlatButton(
                            onPressed: () {
                              if (start == false) {
                                //启动翻译英语到中文
                                _setstart(to,from);
                                setState(() {
                                  start = true;
                                  startTo = true;
                                });
                              } else {
                                _setstop();
                                setState(() {
                                  start = false;
                                  startTo = false;
                                });
                              }
                            },
                            child: Text(To,
                                style: TextStyle(color: AppColor.white)),
                            color: startTo
                                ? AppColor.privacyColor
                                : AppColor.LoginTextColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25),
                                    bottomRight: Radius.circular(25))),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 145,
                        left: 145,
                        child: Container(
                            height: ScreenUtil.instance.setHeight(80),
                            width: ScreenUtil.instance.setWidth(80),
                            decoration:BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.white
                            ),
                            child: Center(
                                child: FlatButton(
                                  onPressed: () {
                                    //启动语音翻译
                                  },
                                  color: start
                                      ? AppColor.privacyColor
                                      : AppColor.BGColor,
                                  shape: CircleBorder(),
                                  child: IconButton(
                                    onPressed: () {
                                      //启动语音翻译
                                      // 延时10s执行翻转
                                      Future.delayed(Duration(seconds: 2), () {
                                        setState(() {
                                          reversal = 2;
                                          //  istrue=false;
                                        });
//                              Navigator.of(context).pop();
////                              print('延时1s执行');
                                      });
                                    },
                                    icon: start
                                        ? Image(
                                      image: AssetImage(
                                          "images/dialog_icon_voice_white.png"),
                                    )
                                        : Image(
                                      image: AssetImage(
                                          "images/dialog_icon_voice_gray.png"),
                                    ),
                                  ),
                                ),
                            )
                        ),
                      )
                    ]))),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  //传值开启语音输入
  Future<Null> _setstart(String From,String To) async {
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
      print(result2);
    }
    setState(() {
      traveltranslation = result2;
    });
  }

//结束语音识别
  Future<Null> _setstop() async {
    String result1;
    try {
      //Toast.toast(context,msg: "请求访问失败",position: ToastPostion.bottom);
      final String result = await platform.invokeMethod('stop');
      result1 = result;
      print(result);
    } on PlatformException catch (e) {
      result1 = "Failed to get battery level: '${e.message}'.";
    }
    setState(() {
      traveltranslation = result1;
    });
  }
  void getdata() async {
    String fromValue = await TravelSP.getFromValue();
    String toValue = await TravelSP.getToValue();
    String From1 = await TravelSP.getFrom();
    String To1 = await TravelSP.getTo();
    setState(() {
      from = fromValue;
      to = toValue;
      From=From1;
      To=To1;
    });
  }
  void SaveData(){
    History history=new History(TextFrom, TextTo, 0);
    databaseHelper.insertHistory(history);
    eventBus.fire(ListEvent("change"));
  }
}
