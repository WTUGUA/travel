import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/page/mainpage/from_page.dart';
import 'package:traveltranslation/page/mainpage/to_page.dart';
import 'package:traveltranslation/utils/event_bus.dart';
import 'package:traveltranslation/utils/travelsp.dart';

Color primaryColor = Colors.blue[600];

class IndexBody extends StatefulWidget {
  IndexBody({Key key}) : super(key: key);

  @override
  _IndexBodyState createState() => _IndexBodyState();
}

class _IndexBodyState extends State<IndexBody> {
  String _firstLanguage = '英语';
  String _sencondLanguage = '中文';
  String _FromValue;
  String _ToValue;
  var _eventBusOn;

  @override
  void initState() {
    getlanguage();
    this._eventBusOn = eventBus.on<LanguageEvent>().listen((event){
      print(event);
      getlanguage();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    if(_ToValue==null){
      getlanguage();
    }
    return Container(
      height: ScreenUtil.instance.setHeight(44.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: ScreenUtil.instance.setWidth(0.5),
              color: Colors.grey[200],
            ),
          )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  //跳转到源语言选择界面
                  //跳转到相机界面
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => new FromPage()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      //获取sp的值
                      this._firstLanguage,
                      style: TextStyle(color: AppColor.privacyText1Color,fontSize: 16.0),
                    ),
                    Image.asset(
                        'images/icon_arrow_down_gray.png'
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width:ScreenUtil.instance.setWidth(10),
          ),
          Material(
            color: Colors.white,
          child: InkWell(
          onTap: () {
            //交换sp的值 修改组件状态
            setState(() {
              String temp="";
              temp=_sencondLanguage;
              _sencondLanguage=_firstLanguage;
              _firstLanguage=temp;
            });
          },
            child: ImageIcon(
              AssetImage('images/translate_icon_change_gray.png'),
            ),
          ),
          ),
          Container(
            width: ScreenUtil.instance.setWidth(10),
          ),
          Expanded(
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  //跳转到目标语言选择界面
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => new ToPage()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      this._sencondLanguage,
                      style: TextStyle(color: AppColor.privacyText1Color,fontSize: 16.0),
                    ),
                    Image.asset(
                        'images/icon_arrow_down_gray.png'
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void getlanguage() async {
    String fromValue="";
    String toValue="";
    String from="";
    String to="";
    fromValue=await TravelSP.getFromValue();
    toValue=await TravelSP.getToValue();
    from=await TravelSP.getFrom();
    to=await TravelSP.getTo();
    setState(() {
      _FromValue=fromValue;
      _ToValue=toValue;
      _firstLanguage=from;
      _sencondLanguage=to;
      print(_FromValue);
      print(_ToValue);
      print(_firstLanguage);
      print( _sencondLanguage);
      print("获取sp值成功");
    });
  }
  @override
  void dispose() {
    this._eventBusOn.cancel();//取消事件监听
    super.dispose();
  }
}


