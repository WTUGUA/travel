import 'dart:convert';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/db/database_history.dart';
import 'package:traveltranslation/model/history.dart';
import 'package:traveltranslation/model/transresult.dart';
import 'package:traveltranslation/model/word.dart';
import 'package:traveltranslation/page/mainpage/shuru_page.dart';
import 'package:traveltranslation/page/toast.dart';
import 'package:traveltranslation/utils/md5.dart';
import 'package:flutter/material.dart';
import './icon_page.dart';
import 'detail_page.dart';

class TextFieldDemo extends StatefulWidget {
  @override
  _TextFieldDemoState createState() => _TextFieldDemoState();
}

//输入事件
class _TextFieldDemoState extends State<TextFieldDemo> {
  FocusNode focusNode1 = new FocusNode();
  bool istrue = true;
  String text1 = "";

  @override
  void initState() {
    focusNode1.addListener(() {
      setState(() {
        istrue = false;
      });
    });
  }

  void _onchange(bool newValue) {
    setState(() {
      istrue = newValue;
    });
  }
  DatabaseHelper_history databaseHelper = DatabaseHelper_history();
  static final String appid = "20191128000361129";
  static final String securityKey = "vfgIbXmgf4cs1jP8lhrq";
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    controller.addListener(() {
      text1 = '${controller.text}';
      print(text1);
    });
    return Container(
        child: Card(
      elevation: 0,
      margin: EdgeInsets.all(0.0),
      child: Container(
        height: ScreenUtil.instance.setHeight(208.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                height: ScreenUtil.instance.setHeight(160.0),
                padding: EdgeInsets.only(
                    left: ScreenUtil.instance.setWidth(15.0), right: ScreenUtil.instance.setWidth(15.0), bottom: ScreenUtil.instance.setHeight(15.0),),
                child: TextField(
                  focusNode: focusNode1,
                  controller: controller,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: '输入文字'),
                  style: TextStyle(color: Colors.black, fontSize: 25.0),
                  maxLines: 999,
                  //keyboardType: ,
                  cursorColor: Colors.blue[500],
                  cursorWidth: 2.0,
                  onSubmitted: (text) {
                    // getTransResult(text,"zh","en");
                  },
                  onTap: () {
                    focusNode1.unfocus();
                    //跳转到输入翻译界面
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => new ShuRuPage()));
                  },
                ),
              ),
            ),
            IconDemo(),
          ],
        ),
      ),
    ));
  }

  void _change() {
    setState(() {});
  }
}

class CheckDemo extends StatefulWidget {
  CheckDemo({Key key, this.active, @required this.onChanged, this.text})
      : super(key: key);
  final String text;
  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  _CheckDemoState createState() => _CheckDemoState();
}

class _CheckDemoState extends State<CheckDemo> {
  String get _appid => "20191128000361129";

  String get _securityKey => "vfgIbXmgf4cs1jP8lhrq";
  DatabaseHelper_history databaseHelper = DatabaseHelper_history();
  static final String appid = "20191128000361129";
  static final String securityKey = "vfgIbXmgf4cs1jP8lhrq";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.only(top: 30.0),
                onPressed: () {
                  //清空输入框
                  widget.onChanged(!widget.active);
                },
                icon: Icon(
                  Icons.close,
                  color: Color(0xff3f51b5),
                ),
              ),
              Text(
                "取消",
                style: TextStyle(color: Colors.blue, fontSize: 17.0),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.only(top: 30.0),
                onPressed: () async {
                  //翻译并跳转
                  String url = getTransResult(widget.text, "zh", "en");
                  History word = await getresult(url);
                  if (word != null) {
                  } else {
                    Toast.toast(context,
                        msg: "请求访问失败", position: ToastPostion.bottom);
                  }
                  widget.onChanged(!widget.active);
                },
                icon: Icon(
                  Icons.check,
                  color: Color(0xff3f51b5),
                ),
              ),
              Text(
                "翻译",
                style: TextStyle(color: Colors.blue, fontSize: 17.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getTransResult(String query, String from, String to) {
    //拼接字符串appID+query+salt+securityKey
    String data = _appid + query + "1435660288" + _securityKey;
    String sign = generateMd5(data);
    //HTTP请求
    var url =
        'https://traveltranslation-api.baidu.com/api/trans/vip/translate' +
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
    getresult(url);
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
      Map<String, dynamic> map = json.decode(result);
      TransResult transResult = TransResult.fromJson(map);
      print(result);
      print(transResult.word[0].targetWord);
      History word = new History(
          transResult.word[0].sourceWord, transResult.word[0].targetWord, 0);
      databaseHelper.insertHistory(word);
      httpClient.close();
      return word;
    } catch (e) {
      print("请求失败:$e");
    } finally {}
  }
}
