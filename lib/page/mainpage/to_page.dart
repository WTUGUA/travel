import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/model/select.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/page/mainpage/find_to_page.dart';
import 'package:traveltranslation/utils/event_bus.dart';
import 'package:traveltranslation/utils/language.dart';
import 'package:traveltranslation/utils/travelsp.dart';

class ToPage extends StatefulWidget {
  @override
  _ToPageState createState() => _ToPageState();
}

class _ToPageState extends State<ToPage> {
  final TextEditingController controller = TextEditingController();
  FocusNode focusNode1 = new FocusNode();
  bool showBt = true;
  bool showlog = true;
  bool showend=false;
  List<Select> items;
  int selectposition = -1;
  double height=60;
  var _eventBusOn;

  @override
  void initState() {
    setState(() {
      getposition();
    });
    this._eventBusOn = eventBus.on<LanguageEvent>().listen((event){
      print(event);
      getposition();
    });
  }

  @override
  void dispose() {
    this._eventBusOn.cancel();//取消事件监听
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    items = getListData();
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: ScreenUtil.instance.setHeight(20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: ScreenUtil.instance.setWidth(155),
              ),
              Text(
                '目标语言',
                style: TextStyle(
                    color: AppColor.privacyText1Color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                height:ScreenUtil.instance.setHeight(45),
                width: ScreenUtil.instance.setWidth(93),
              ),
              showend
                  ? GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  eventBus.fire(LanguageEvent("chance"));
                },
                child: Text('完成',
                    maxLines: 1,
                    style: TextStyle(
                        color: AppColor.privacyText1Color, fontSize: 16)),
              )
                  : IconButton(
                // padding: EdgeInsets.only(left: 5.0),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Image(
                  image: AssetImage("images/icon_close_black.png"),
                ),
              ),
            ],
          ),
          Container(
              height: ScreenUtil.instance.setHeight(36),
              width: ScreenUtil.instance.setWidth(340),
              decoration: BoxDecoration(
                  color: AppColor.BGColor,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '搜索',
                          hintStyle: TextStyle(
                              color: AppColor.LoginTextColor, fontSize: 16.0),
                          prefixIcon: Image(
                              image: AssetImage(
                                  "images/translate_icon_search.png"))),
                      controller: controller,
                      style: TextStyle(
                          color: AppColor.privacyText1Color, fontSize: 16.0),
                      onTap: () {
                        //跳转到搜索界面
                        Navigator.of(context).pop();
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => new FindToPage()));
                      },
                    ),
                  ),
                  Offstage(
                    offstage: showBt,
                    child: IconButton(
                      // padding: EdgeInsets.only(left: 5.0),
                      onPressed: () {
                        //清除搜索框
                      },
                      icon: Image(
                        image: AssetImage("images/translate_icon_cancel.png"),
                      ),
                    ),
                  )
                ],
              )),
          Container(
            height: ScreenUtil.instance.setHeight(15),
          ),
          Container(
              padding: EdgeInsets.only(left: 15, top: 4, bottom: 3),
              decoration: BoxDecoration(
                color: AppColor.BGColor,
              ),
              height: ScreenUtil.instance.setHeight(24),
              child: Row(
                children: <Widget>[
                  Text(
                    '常用语言',
                    style: TextStyle(
                        color: AppColor.privacyText1Color,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w200),
                  ),
                ],
              )),
          //第一个listview
          Container(
              height: ScreenUtil.instance.setHeight(525),
              child: ListView.builder(
                // itemExtent: height,
                  padding: EdgeInsets.zero,
                  itemCount: 27,
                  itemBuilder: (BuildContext context, int position) {
                    print("输出测试2+$selectposition");
                    if (position == 3) {
                      height=84.0;
                      showlog = false;
                    } else {
                      height=60.0;
                      showlog = true;
                    }
                    if (position == selectposition) {
                      showBt = false;
                    } else {
                      showBt = true;
                    }
                    return GestureDetector(
                        onTap: (){
                          setState(() {
                            showend=true;
                            selectposition=position;
                            TravelSP.saveTo(items[position].sourceSelect);
                            TravelSP.saveToValue(items[position].targetSelect);
                            print("操作成功");
                            print(items[position].sourceSelect);
                            print(items[position].targetSelect);
                          });
                          eventBus.fire(LanguageEvent("change"));
                        },
                        child:Container(
                          height: ScreenUtil.instance.setHeight(height),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Offstage(
                                offstage: showlog,
                                child: Container(
                                    padding: EdgeInsets.only(left: 15, top: 4, bottom: 3),
                                    decoration: BoxDecoration(
                                      color: AppColor.BGColor,
                                    ),
                                    height: ScreenUtil.instance.setHeight(24),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          '所有语言',
                                          style: TextStyle(
                                              color: AppColor.privacyText1Color,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w200),
                                        ),
                                      ],
                                    )),
                              ),
                              Row(
                                children: <Widget>[
                                  //判断是否选中
                                  showBt ?
                                  Container(
                                    height: ScreenUtil.instance.setHeight(60),
                                    width: ScreenUtil.instance.setWidth(50),
                                  ) :
                                  Container(
                                    width: ScreenUtil.instance.setWidth(50),
                                    height: ScreenUtil.instance.setHeight(60),
                                    child:IconButton(
                                      // padding: EdgeInsets.only(left: 5.0),
                                      onPressed: () {},
                                      icon: Image(
                                        image: AssetImage(
                                            "images/translate_icon_selected.png"),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: ScreenUtil.instance.setHeight(60),
                                    width: ScreenUtil.instance.setWidth(310),
                                    decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 0.5,
                                            color: AppColor.LoginTextColor,
                                          ),
                                        )),
                                    // color: Colors.deepPurple,
                                    child:Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          this.items[position].sourceSelect,
                                          style: showBt
                                              ? TextStyle(
                                              color: AppColor.privacyText1Color,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w200)
                                              : TextStyle(
                                              color: AppColor.privacyColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w200),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ) ,
                        )
                    );
                  })),
        ],
      ),
    );
  }

  List<Select> getListData() {
    List<Select> item = new List();
    Language.FromMap.forEach((name, value) {
      Select select1 = new Select(name, value);
      item.add(select1);
    });
    return item;
  }
  Future<int> getposition() async {
    //获取sp设置值
    String To = await TravelSP.getTo();
    String ToValue = await TravelSP.getToValue();
    String From=await TravelSP.getFrom();
    Select select =Select(To, ToValue);
    List<String> itemvalue=new List();
    Language.FromMap.forEach((name, value) {
      itemvalue.add(value);
    });
    int value1=itemvalue.indexOf(select.targetSelect);
    print(value1);
    setState(() {
      selectposition = value1;
    });
    //selectposition = value1;
    return value1;
  }
}
