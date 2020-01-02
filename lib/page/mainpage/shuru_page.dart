import 'dart:convert';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/db/database_history.dart';
import 'package:traveltranslation/model/history.dart';
import 'package:traveltranslation/model/transresult.dart';
import 'package:traveltranslation/model/word.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';
import 'package:traveltranslation/ocr/widget/dialog/lead_login_dialog.dart';
import 'package:traveltranslation/page/body_page.dart';
import 'package:traveltranslation/page/toast.dart';
import 'package:traveltranslation/utils/event_bus.dart';
import 'package:traveltranslation/utils/md5.dart';
import 'package:flutter/material.dart';
import 'package:traveltranslation/utils/travelsp.dart';
import 'package:traveltranslation/page/recording_page.dart';
import '../detail_page.dart';
import '../icon_page.dart';

class ShuRuPage extends StatefulWidget {
  @override
  _ShuRuPageState createState() => _ShuRuPageState();
}

//输入事件
class _ShuRuPageState extends State<ShuRuPage> {
  FocusNode focusNode = new FocusNode();
  bool istrue = false;
  String text1 = "";
  double height1=117;
  String From="";
  String To="";
 // GlobalKey<RecordingPageState> ListKey = GlobalKey();
  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {
        getValue();
        istrue = false;
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
  }

  void getValue() async{
    From=await TravelSP.getFromValue();
    To=await TravelSP.getToValue();
  }

  void _onchange(bool newValue) {
    setState(() {
      istrue = newValue;
    });
  }

  String get _appid => "20190809000325332";

  String get _securityKey => "luTbBoWAQY3uGV8rtxog";
  DatabaseHelper_history databaseHelper = DatabaseHelper_history();
  static final String appid = "20190809000325332";
  static final String securityKey = "luTbBoWAQY3uGV8rtxog";
  final TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    controller.addListener(() {
      text1 = '${controller.text}';
      print(text1);
    });
    return Scaffold(
       body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: ScreenUtil.instance.setHeight(20),
                ),
                IndexBody(),
                Container(
                    height: ScreenUtil.instance.setHeight(175),
                    padding: EdgeInsets.only(left: ScreenUtil.instance.setWidth(15.0),top: ScreenUtil.instance.setHeight(5.0)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: Colors.grey[200],
                          ),
                        )),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child:TextField(
                              focusNode: focusNode,
                              controller: controller,
                              autofocus: true,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: "请输入文字",hintStyle: (TextStyle(color: AppColor.LoginTextColor,fontSize: 20))),
                              style: TextStyle(color: AppColor.privacyText1Color, fontSize: 20.0),
                              maxLines: 999,
                              cursorColor: Colors.blue[500],
                              cursorWidth: 2.0,
                              onSubmitted: (text) {
                              },
                              onChanged: (value){
                                text1=value;
                              },
                              onTap: () {
                              },
                            ),
                          ),
                          Offstage(
                            offstage: istrue,
                            child:IconButton(
                              // padding: EdgeInsets.only(left: 5.0),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Image(
                                image: AssetImage("images/icon_close_gray.png"),
                              ),
                            ),
                          )
                        ]
                    )
                ),
                        Container(
                          height: ScreenUtil.instance.setHeight(70),
                        ),
                            Row(
                                children: <Widget>[
                                  Container(
                                    width: ScreenUtil.instance.setWidth(80),
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      //清空输入值
                                     // Navigator.pop(context);
                                      controller.clear();
                                    },
                                    icon: Image(
                                      image: AssetImage("images/translate_icon_back.png"),
                                    ),
                                    iconSize: 48,
                                  ),
                                  Container(
                                    width: ScreenUtil.instance.setWidth(69),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      //翻译内容 并跳转到翻译详情页
                                      //翻译并跳转
                                      int time1=await TravelSP.getTRTime();
                                      if(UserDelegate.userStatus==UserStatus.GUEST&&time1>=15){
                                        showDialog<Null>(
                                            context: context, //BuildContext对象
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return new LeadLoginDialog();
                                            }).then((value) {});
                                      }else {
                                        EventUtil.onEvent(
                                            EventUtil.translateClick);
                                        String url = getTransResult(
                                            text1, From, To);
                                        History word = await getresult(url);
                                        eventBus.fire(ListEvent("change"));
                                        if (word != null) {
                                          int time = time1 + 1;
                                          TravelSP.saveTRTime(time);
                                          //ListKey.currentState.updateListView();
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                  new DetailPage(
                                                    word: word,
                                                  )));
                                        }
                                      }
                                    },
                                    icon: Image(
                                      image: AssetImage("images/translate_icon_translate.png"),
                                    ),
                                    iconSize: 48,
                                  ),
                                  Container(
                                    width: ScreenUtil.instance.setWidth(80),
                                  ),
                                ]
                            )
              ],
            ))
    );

  }

  String getTransResult(String query, String from, String to) {
    //拼接字符串appID+query+salt+securityKey
    String data = _appid + query + "1435660288" + _securityKey;
    String sign = generateMd5(data);
    //HTTP请求
    var url =
        'https://fanyi-api.baidu.com/api/trans/vip/translate' +
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
      if(result!=null) {
        Map<String, dynamic> map = json.decode(result);
        TransResult transResult = TransResult.fromJson(map);
        print("文本翻译测试翻译结果：$result");
        print("文本翻译测试翻译结果："+transResult.word[0].targetWord);
        History word = new History(
            transResult.word[0].sourceWord, transResult.word[0].targetWord, 0);
        databaseHelper.insertHistory(word);
        httpClient.close();
        return word;
      }else{
        print("result等于null");
        httpClient.close();
        return null;
      }
    } catch (e) {
      print("请求失败:$e");
    } finally {}
  }
}