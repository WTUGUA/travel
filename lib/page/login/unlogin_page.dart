import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';

class UnloginPage extends StatefulWidget {
  @override
  _UnloginPageState createState() => _UnloginPageState();
}

class _UnloginPageState extends State<UnloginPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: AppColor.white,
        child: Column(children: <Widget>[
          Stack(children: <Widget>[
            Positioned(
              child: Container(
                height: 186,
                width: 375,
                color: AppColor.dialogueColor,
              ),
            ),
            Positioned(
              top: 100,
              right: 245,
              child: Container(
                height: 186,
                width: 375,
                color: AppColor.white,
              ),
            ),
            Positioned(
              top: 100,
              left: 110,
              child: Container(
                height: 86,
                width: 280,
                color: AppColor.white,
                child: GestureDetector(
                  onTap: (){
                    //跳转到登录界面

                  },
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('未登录',
                          style: TextStyle(
                              fontSize: 18, color: AppColor.privacyText1Color)),
                      Row(
                        children: <Widget>[
//                          Image(
//                            image: AssetImage("images/mine_icon_vip.png"),
//                          ),
                          Text('登录可以享受更多特权哦~',
                              style: TextStyle(
                                  fontSize: 13, color: AppColor.privacyTextColor))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 15,
              top: 80,
              child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppColor.white),
                  child: Center(
                    child: ClipOval(
                      child: Image(
                          width: 75,
                          height: 75,
                          image: AssetImage("images/meizi.png"),
                          fit: BoxFit.cover),
                    ),
                  )),
            )
          ]),
          Row(
            children: <Widget>[
              Container(
                width: 15,
                height: 60,
              ),
              Image(
                height: 24,
                width: 24,
                image: AssetImage("images/mine_icon_record.png"),
              ),
              Container(
                width: 14,
              ),
              Expanded(
                child:Text('反馈',style: TextStyle(
                    fontSize: 16, color: AppColor.privacyText1Color)),
              ),
              IconButton(
                onPressed: () {},
                icon: Image(
                  height: 24,
                  width: 24,
                  image: AssetImage("images/icon_chevron_right.png"),
                ),
              ),
              Container(
                width: 15,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: 15,
                height: 60,
              ),
              Image(
                height: 24,
                width: 24,
                image: AssetImage("images/mine_icon_help.png"),
              ),
              Container(
                width: 14,
              ),
              Expanded(
                child:Text('帮助',style: TextStyle(
                    fontSize: 16, color: AppColor.privacyText1Color)),
              ),
              IconButton(
                onPressed: () {},
                icon: Image(
                  height: 24,
                  width: 24,
                  image: AssetImage("images/icon_chevron_right.png"),
                ),
              ),
              Container(
                width: 15,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: 15,
                height: 60,
              ),
              Image(
                height: 24,
                width: 24,
                image: AssetImage("images/mine_icon_about.png"),
              ),
              Container(
                width: 14,
              ),
              Expanded(
                child:Text('关于',style: TextStyle(
                    fontSize: 16, color: AppColor.privacyText1Color)),
              ),
              IconButton(
                onPressed: () {},
                icon: Image(
                  height: 24,
                  width: 24,
                  image: AssetImage("images/icon_chevron_right.png"),
                ),
              ),
              Container(
                width: 15,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: 15,
                height: 60,
              ),
              Image(
                height: 24,
                width: 24,
                image: AssetImage("images/mine_icon_offline.png"),
              ),
              Container(
                width: 14,
              ),
              Expanded(
                child:Text('离线翻译',style: TextStyle(
                    fontSize: 16, color: AppColor.privacyText1Color)),
              ),
              IconButton(
                onPressed: () {},
                icon: Image(
                  height: 24,
                  width: 24,
                  image: AssetImage("images/icon_chevron_right.png"),
                ),
              ),
              Container(
                width: 15,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: 15,
                height: 60,
              ),
              Image(
                height: 24,
                width: 24,
                image: AssetImage("images/mine_icon_clear.png"),
              ),
              Container(
                width: 14,
              ),
              Expanded(
                child:Text('清空翻译历史',style: TextStyle(
                    fontSize: 16, color: AppColor.privacyText1Color)),
              ),
              GestureDetector(
                child: Text('清除',style: TextStyle(
                    fontSize: 16, color: AppColor.red)),
              ),
              Container(
                width: 15,
              ),
            ],
          )
        ]),
      ),
    );
  }
}