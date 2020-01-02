import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/ocr/components/app/app_component.dart';
import 'package:traveltranslation/ocr/components/home/home_component.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';
import 'package:traveltranslation/ocr/widget/dialog/lead_login_dialog.dart';
import 'package:traveltranslation/page/asr_page.dart';
import 'package:traveltranslation/page/dialogue.dart';
import 'package:flutter/material.dart';
import 'package:traveltranslation/utils/travelsp.dart';

class IconDemo extends StatefulWidget {
  @override
  _IconDemoState createState() => _IconDemoState();
}

//图标点击事件
class _IconDemoState extends State<IconDemo> {
  //获取android传递来的值
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 375, height: 667)..init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: ScreenUtil.instance.setHeight(48.0),
          width: ScreenUtil.instance.setWidth(125.0),
          child: InkWell(
            onTap: () {
              EventUtil.onEvent(EventUtil.camearClick);
              if(UserDelegate.userStatus==UserStatus.GUEST){
              showDialog<Null>(
              context: context, //BuildContext对象
              barrierDismissible: false,
              builder: (BuildContext context) {
              return new LeadLoginDialog();
              }).then((value) {});
              }else {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new HomeComponent()));
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('images/translate_icon_camera.png'),
                Container(
                  width:ScreenUtil.instance.setWidth(9),
                ),
                Text(
                  "相机",
                  style: TextStyle(
                      color: AppColor.privacyText1Color, fontSize: 13.0),
                )
              ],
            ),
          ),
        ),
        Container(
          height: ScreenUtil.instance.setHeight(48.0),
          width: ScreenUtil.instance.setWidth(125.0),
          child: InkWell(
            onTap: () {
              if(UserDelegate.userStatus==UserStatus.GUEST){
                showDialog<Null>(
                    context: context, //BuildContext对象
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new LeadLoginDialog();
                    }).then((value) {});

              }else{
                //跳转到对话界面
                EventUtil.onEvent(EventUtil.dialogueClick);
                Navigator.push(context,
                    new MaterialPageRoute(
                        builder: (context) => new Dialogue()));
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('images/translate_icon_dialog.png'),
                Container(
                  width:ScreenUtil.instance.setWidth(9),
                ),
                Text(
                  "对话",
                  style: TextStyle(
                      color: AppColor.privacyText1Color, fontSize: 13.0),
                )
              ],
            ),
          ),
        ),
        Container(
          height: ScreenUtil.instance.setHeight(48.0),
          width: ScreenUtil.instance.setWidth(125.0),
          child: InkWell(
            onTap: () {
              EventUtil.onEvent(EventUtil.sayClick);
              if(UserDelegate.userStatus==UserStatus.GUEST){
              showDialog<Null>(
              context: context, //BuildContext对象
              barrierDismissible: false,
              builder: (BuildContext context) {
              return new LeadLoginDialog();
              }).then((value) {});
              }else {
                ShowArsDialog();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('images/translate_icon_voice.png'),
                Container(
                  width:ScreenUtil.instance.setWidth(9),
                ),
                Text(
                  "语音",
                  style: TextStyle(
                      color: AppColor.privacyText1Color, fontSize: 13.0),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
void updateTime() async{
  String time=await TravelSP.getTime();
  DateTime now = DateTime.now();
  print("时间"+now.toString());
  if(time!=null){
    //进行计算判断差值
    differenceTime(DateTime.parse(time),now);
  }
  TravelSP.saveTime(now.toString());
  print("时间+$time");
}
void differenceTime(DateTime time1,DateTime time2){
  Duration duration = time2.difference(time1);
  print(duration.inDays.toString());
  int day=duration.inDays;
  if(day>0){
    TravelSP.saveOcrTime(0);
  }
}
  void ShowArsDialog() {
    //跳转到语音界面
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return AsrTest();
        });
  }
}
