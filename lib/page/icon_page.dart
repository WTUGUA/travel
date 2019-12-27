
import 'package:traveltranslation/ocr/components/app/app_component.dart';
import 'package:traveltranslation/ocr/components/home/home_component.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/page/asr_page.dart';
import 'package:traveltranslation/page/dialogue.dart';
import 'package:flutter/material.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          onTap: () {
            //跳转到相机界面
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new HomeComponent()));
          },
          child: Row(
            children: <Widget>[
              Image.asset('images/translate_icon_camera.png'),
              Text(
                "相机",
                style: TextStyle(
                    color: AppColor.privacyText1Color, fontSize: 13.0),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {
            //跳转到对话界面
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new Dialogue()));
          },
          child: Row(
            children: <Widget>[
              Image.asset('images/translate_icon_dialog.png'),
              Text(
                "对话",
                style: TextStyle(
                    color: AppColor.privacyText1Color, fontSize: 13.0),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {
            ShowArsDialog();
          },
          child: Row(
            children: <Widget>[
              Image.asset('images/translate_icon_voice.png'),
              Text(
                "语音",
                style: TextStyle(
                    color: AppColor.privacyText1Color, fontSize: 13.0),
              )
            ],
          ),
        ),
      ],
    );
  }
  void ShowArsDialog(){
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
        }
        );
  }
}
