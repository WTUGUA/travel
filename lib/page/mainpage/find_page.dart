import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/model/select.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/page/mainpage/main_page.dart';
import 'package:traveltranslation/utils/event_bus.dart';
import 'package:traveltranslation/utils/language.dart';
import 'package:traveltranslation/utils/travelsp.dart';

class FindPage extends StatefulWidget {
  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  final TextEditingController controller = TextEditingController();
  FocusNode focusNode1 = new FocusNode();
  bool showBt=true;
  bool check=true;
  String FindText="";
  List<Select> items;
  Select select;
  List<Select> getListData() {
    List<Select> item=new List();
    Language.FromMap.forEach((name, value) {
      Select select1=new Select(name, value);
      item.add(select1);
    });
    return item;
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    items=getListData();
    controller.addListener((){
      //查询显示到结果
     for(int i=0;i<items.length;i++){
       if(items[i].sourceSelect==controller.text){
         print("查询成功");
         //显示搜索结果
         select=new Select(items[i].sourceSelect,items[i].targetSelect);
         setState(() {
           FindText=items[i].sourceSelect;
           check=false;
         });
       }
     }
    });
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
                '源语言',
                style: TextStyle(
                    color: AppColor.privacyText1Color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                width: ScreenUtil.instance.setWidth(100),
              ),
              IconButton(
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
          Row(
            children: <Widget>[
              Container(
                width: ScreenUtil.instance.setWidth(16),
                ),
              Container(
                  height: ScreenUtil.instance.setHeight(36),
                  width: ScreenUtil.instance.setWidth(297),
                  decoration: BoxDecoration(
                      color: AppColor.BGColor,
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child:TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '搜索',
                              hintStyle: TextStyle(color: AppColor.LoginTextColor, fontSize: 16.0),
                              prefixIcon: Image(
                                  image: AssetImage("images/translate_icon_search.png"),)
                          ),
                          controller: controller,
                          style: TextStyle(color: AppColor.privacyText1Color, fontSize: 16.0),
                          autofocus: true,
                          onTap: (){
                            setState(() {
                              showBt=false;
                            });
                          },
                          onChanged: (value){

                          },
                        ),
                      ),
                      Offstage(
                        offstage: showBt,
                        child: IconButton(
                          // padding: EdgeInsets.only(left: 5.0),
                          onPressed: () {
                            //清除搜索框
                            controller.clear();
                          },
                          icon: Image(
                            image: AssetImage("images/translate_icon_cancel.png"),
                          ),
                        ),
                      )
                    ],
                  )),
              Container(
                width: ScreenUtil.instance.setWidth(10),
              ),
              GestureDetector(
                onTap: (){
                  print("取消");
                  Navigator.of(context).pop();
                },
                child: Text(
                  '取消',
                    style: TextStyle(color: AppColor.privacyText1Color, fontSize: 16.0)
                ),
              )
            ],
          ),
          Container(
            height: ScreenUtil.instance.setHeight(15)
          ),
          Container(
            child: Divider(height:1,indent:0,color:AppColor.LoginTextColor),
          ),
          Offstage(
            offstage: check,
            child: GestureDetector(
              onTap: (){
                //跳转回主界面修改主界面的值保存到sp中
                TravelSP.saveFrom(select.sourceSelect);
                TravelSP.saveFromValue(select.targetSelect);
                print("操作成功");
                eventBus.fire(LanguageEvent("change"));
                Navigator.of(context).pop();
//                Navigator.push(context, new MaterialPageRoute(
//                    builder: (context) => new MainPage()));
              },
              child: Container(
                height: ScreenUtil.instance.setHeight(54),
                width: ScreenUtil.instance.setWidth(375),
                padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(15),left: ScreenUtil.instance.setWidth(16)),
                decoration: BoxDecoration(
                    color: AppColor.white,
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: Colors.grey[500],
                      ),
                    )),
                child: Text(
                  FindText,
                  style: TextStyle(color: AppColor.privacyText1Color, fontSize: 16.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
