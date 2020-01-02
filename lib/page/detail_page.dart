import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:share_extend/share_extend.dart';
import 'package:traveltranslation/db/database_history.dart';
import 'package:traveltranslation/db/database_word.dart';
import 'package:traveltranslation/model/history.dart';
import 'package:traveltranslation/model/transresult.dart';
import 'package:traveltranslation/model/word.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';

import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';
import 'package:traveltranslation/ocr/widget/dialog/lead_login_dialog.dart';
import 'package:traveltranslation/page/mainpage/from_page.dart';
import 'package:traveltranslation/page/mainpage/to_page.dart';
import 'package:traveltranslation/page/toast.dart';
import 'package:traveltranslation/utils/md5.dart';

import 'package:traveltranslation/utils/travelsp.dart';
import './body_page.dart';
import './textfield_page.dart';
import 'mainpage/full_page.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
  final History word;

  DetailPage({Key key, @required this.word}) : super(key: key);
}

Color primaryColor = Colors.blue[600];

class _DetailPageState extends State<DetailPage> {
  DatabaseHelper_history databaseHelper = DatabaseHelper_history();
  DatabaseHelper_word databaseHelper_word = DatabaseHelper_word();
  static final String _appid = "20190809000325332";
  static final String _securityKey = "luTbBoWAQY3uGV8rtxog";
  String _firstLanguage = '英语';
  String _sencondLanguage = '中文';
  String fromValue = "";
  String toValue = "";
  String url = "";
  static String text1 = "";
  static String ToText = "";
  FocusNode focusNode = new FocusNode();
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //友盟
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 375, height: 667)..init(context);
    return Container(
      child: Scaffold(
        body: Column(
          //可以通过_widgetOptions设置不同页面
          children: <Widget>[
            Container(
              height: ScreenUtil.instance.setHeight(20),
            ),
            Container(
              height: ScreenUtil.instance.setHeight(44.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: Colors.grey[200],
                    ),
                  )),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      //回到翻译界面或者回到主界面
                      Navigator.pop(context);
                    },
                    icon: Image(
                      image: AssetImage("images/icon_arrow_back_black.png"),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          //跳转到源语言选择界面
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new FromPage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              //获取sp的值
                              this._firstLanguage,
                              style: TextStyle(
                                  color: AppColor.privacyText1Color,
                                  fontSize: 16.0),
                            ),
                            Image.asset('images/icon_arrow_down_gray.png'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenUtil.instance.setWidth(20),
                  ),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        //交换sp的值 修改组件状态
                        setState(() {
                          String temp = "";
                          temp = _sencondLanguage;
                          _sencondLanguage = _firstLanguage;
                          _firstLanguage = temp;
                        });
                      },
                      child: ImageIcon(
                        AssetImage('images/translate_icon_change_gray.png'),
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenUtil.instance.setWidth(20),
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          //跳转到目标语言选择界面
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new ToPage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              this._sencondLanguage,
                              style: TextStyle(
                                  color: AppColor.privacyText1Color,
                                  fontSize: 16.0),
                            ),
                            Image.asset('images/icon_arrow_down_gray.png'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenUtil.instance.setWidth(20),
                  )
                ],
              ),
            ),
            Container(
                height: ScreenUtil.instance.setHeight(165),
                padding: EdgeInsets.only(
                    left: ScreenUtil.instance.setWidth(15.0),
                    top: ScreenUtil.instance.setHeight(5.0)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: Colors.grey[200],
                      ),
                    )),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          controller: controller,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: text1,
                              hintStyle: (TextStyle(
                                  color: AppColor.privacyText1Color,
                                  fontSize: 20))),
                          style: TextStyle(
                              color: AppColor.privacyText1Color,
                              fontSize: 20.0),
                          maxLines: 999,
                          cursorColor: Colors.blue[500],
                          cursorWidth: 2.0,
                          onSubmitted: (text) async {
                            //再次调用文本翻译功能修改结果
                            text1 = text;
                            //再次调用文本翻译功能修改结果
                            int time1 = await TravelSP.getTRTime();
                            url = getTransResult(text1, fromValue, toValue);
                            History history = await getresult(url);
                            if (UserDelegate.userStatus == UserStatus.GUEST &&
                                time1 >= 15) {
                              showDialog<Null>(
                                  context: context, //BuildContext对象
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return new LeadLoginDialog();
                                  }).then((value) {});
                            } else {
                              int time = time1 + 1;
                              TravelSP.saveTRTime(time);
                              setState(() {
                                ToText = history.hisTar;
                              });
                            }
                          },
                          onChanged: (value) async {
                            text1 = value;
                            //再次调用文本翻译功能修改结果
                            int time1 = await TravelSP.getTRTime();
                            if (UserDelegate.userStatus == UserStatus.GUEST &&
                                time1 >= 15) {
                              showDialog<Null>(
                                  context: context, //BuildContext对象
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return new LeadLoginDialog();
                                  }).then((value) {});
                            } else {
                              int time = time1 + 1;
                              TravelSP.saveTRTime(time);
                              url = getTransResult(text1, fromValue, toValue);
                              History history = await getresult(url);
                              setState(() {
                                ToText = history.hisTar;
                              });
                            }
                          },
                          onTap: () {},
                        ),
                      ),
                      Offstage(
                        offstage: false,
                        child: IconButton(
                          // padding: EdgeInsets.only(left: 5.0),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Image(
                            image: AssetImage("images/icon_close_gray.png"),
                          ),
                        ),
                      )
                    ])),
            Container(
                padding: EdgeInsets.only(
                    left: ScreenUtil.instance.setWidth(15),
                    top: ScreenUtil.instance.setHeight(5.0)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: Colors.grey[200],
                      ),
                    )),
                height: ScreenUtil.instance.setHeight(145),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: AutoSizeText(
                      ToText,
                      style: TextStyle(
                          color: AppColor.privacyText1Color, fontSize: 20),
                    ))
                  ],
                )),
            Container(
              height: ScreenUtil.instance.setHeight(50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      //是否加入收藏
                      Word word=new Word(text1, ToText);
                      databaseHelper_word.insertWord(word);
                      Toast.toast(context,msg: "已添加到收藏",position: ToastPostion.bottom);
                    },
                    icon: Image.asset('images/translate_icon_save.png'),
                    //iconSize: 10,
                  ),
                  IconButton(
                    // padding: EdgeInsets.only(left: 5.0),
                    onPressed: () {
                      Share.share("原文：" + text1 + "  " + "译文：" + ToText);
                    },
                    icon: Image(
                      image: AssetImage("images/translate_icon_share.png"),
                    ),
                  ),
                  IconButton(
                    // padding: EdgeInsets.only(left: 5.0),
                    onPressed: () {
                      //全屏按钮
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  new FullPage(text: ToText)));
                    },
                    icon: Image(
                      image: AssetImage("images/translate_icon_full.png"),
                    ),
                    iconSize: 24,
                  ),
                  IconButton(
                    // padding: EdgeInsets.only(left: 5.0),
                    onPressed: () {
                      //复制剪辑版
                      Clipboard.setData(new ClipboardData(text: ToText));
                      Toast.toast(context,
                          msg: "已复制到剪辑板", position: ToastPostion.bottom);
                    },
                    icon: Image(
                      image: AssetImage("images/translate_icon_copy.png"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        resizeToAvoidBottomPadding: false,
      ),
    );
  }

  void getdata() async {
    String from = await TravelSP.getFrom();
    String to = await TravelSP.getTo();
    String fromvalue = await TravelSP.getFromValue();
    String tovalue = await TravelSP.getToValue();
    setState(() {
      _firstLanguage = from;
      _sencondLanguage = to;
      fromValue = fromvalue;
      toValue = tovalue;
      text1 = widget.word.hisSource;
      ToText = widget.word.hisTar;
    });
  }

  String getTransResult(String query, String from, String to) {
    //拼接字符串appID+query+salt+securityKey
    String data = _appid + query + "1435660288" + _securityKey;
    String sign = generateMd5(data);
    //HTTP请求
    var url = 'https://fanyi-api.baidu.com/api/trans/vip/translate' +
        '?q=' +
        query +
        '&from=' +
        from +
        '&to=' +
        to +
        '&appid=' +
        _appid +
        '&salt=1435660288&sign=' +
        sign +
        '';
    print(url);
    // getresult(url);
    return url;
  }

  //获取HTTPclient请求
  Future<History> getresult(String url) async {
    try {
      //实例化一个HttpClient对象
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      var result = await response.transform(utf8.decoder).join();
      //将结果转义并存入数据库，可移除独立
      if (result != null) {
        print("文本翻译测试翻译结果：$result");
        Map<String, dynamic> map = json.decode(result);
        TransResult transResult = TransResult.fromJson(map);
        print("文本翻译测试翻译结果：" + transResult.word[0].targetWord);
        History word = new History(
            transResult.word[0].sourceWord, transResult.word[0].targetWord, 0);
        databaseHelper.insertHistory(word);
        httpClient.close();
        return word;
      } else {
        print("result等于null");
        httpClient.close();
        return null;
      }
    } catch (e) {
      print("请求失败:$e");
    } finally {}
  }
}
