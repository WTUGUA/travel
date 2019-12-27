//import 'package:flutter/material.dart';
//import 'package:traveltranslation/db/database_history.dart';
//import 'package:traveltranslation/ocr/config/app_color.dart';
//import 'package:traveltranslation/page/login/unlogin_page.dart';
//
//class UserPage extends StatefulWidget {
//  @override
//  _UserPageState createState() => _UserPageState();
//}
//
//class _UserPageState extends State<UserPage> {
//  static DatabaseHelper_history databaseHelper = DatabaseHelper_history();
//  bool Login=false;
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Scaffold(
//      body:
//      //增加判断是否登录 或者是否为VIP
//      Container(
//        color: AppColor.white,
//        child: Column(children: <Widget>[
//          Stack(children: <Widget>[
//            Positioned(
//              child: Container(
//                height: 186,
//                width: 375,
//                color: AppColor.dialogueColor,
//              ),
//            ),
//            Positioned(
//              top: 100,
//              right: 245,
//              child: Container(
//                height: 186,
//                width: 375,
//                color: AppColor.white,
//              ),
//            ),
//            Positioned(
//              top: 100,
//              left: 110,
//              child: Container(
//                height: 86,
//                width: 280,
//                color: AppColor.white,
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text('用户名',
//                        style: TextStyle(
//                            fontSize: 18, color: AppColor.privacyText1Color)),
//                    Row(
//                      children: <Widget>[
//                        Image(
//                          image: AssetImage("images/mine_icon_vip.png"),
//                        ),
//                        Text('2020/01/10到期',
//                            style: TextStyle(
//                                fontSize: 13, color: AppColor.privacyTextColor))
//                      ],
//                    )
//                  ],
//                ),
//              ),
//            ),
//            Positioned(
//              left: 15,
//              top: 80,
//              child: Container(
//                  height: 80,
//                  width: 80,
//                  decoration: BoxDecoration(
//                      shape: BoxShape.circle, color: AppColor.white),
//                  child: Center(
//                    child: ClipOval(
//                      child: Image(
//                        width: 75,
//                        height: 75,
//                        image: AssetImage("images/meizi.png"),
//                          fit: BoxFit.cover),
//                    ),
//                  )),
//            )
//          ]),
//          Row(
//            children: <Widget>[
//              Container(
//                width: 15,
//                height: 60,
//              ),
//              Image(
//                height: 24,
//                width: 24,
//                image: AssetImage("images/mine_icon_record.png"),
//              ),
//              Container(
//                width: 14,
//              ),
//              Expanded(
//                child:Text('反馈',style: TextStyle(
//                    fontSize: 16, color: AppColor.privacyText1Color)),
//              ),
//              IconButton(
//                onPressed: () {
//                  //跳转到反馈界面
//
//
//                },
//                icon: Image(
//                  height: 24,
//                  width: 24,
//                  image: AssetImage("images/icon_chevron_right.png"),
//                ),
//              ),
//              Container(
//                width: 15,
//              ),
//            ],
//          ),
//          Row(
//            children: <Widget>[
//              Container(
//                width: 15,
//                height: 60,
//              ),
//              Image(
//                height: 24,
//                width: 24,
//                image: AssetImage("images/mine_icon_help.png"),
//              ),
//              Container(
//                width: 14,
//              ),
//              Expanded(
//                child:Text('帮助',style: TextStyle(
//                    fontSize: 16, color: AppColor.privacyText1Color)),
//              ),
//              IconButton(
//                onPressed: () {
//                  //跳转到帮助界面
//
//                },
//                icon: Image(
//                  height: 24,
//                  width: 24,
//                  image: AssetImage("images/icon_chevron_right.png"),
//                ),
//              ),
//              Container(
//                width: 15,
//              ),
//            ],
//          ),
//          Row(
//            children: <Widget>[
//              Container(
//                width: 15,
//                height: 60,
//              ),
//              Image(
//                height: 24,
//                width: 24,
//                image: AssetImage("images/mine_icon_about.png"),
//              ),
//              Container(
//                width: 14,
//              ),
//              Expanded(
//                child:Text('关于',style: TextStyle(
//                    fontSize: 16, color: AppColor.privacyText1Color)),
//              ),
//              IconButton(
//                onPressed: () {
//                  //跳转到关于界面
//
//
//                },
//                icon: Image(
//                  height: 24,
//                  width: 24,
//                  image: AssetImage("images/icon_chevron_right.png"),
//                ),
//              ),
//              Container(
//                width: 15,
//              ),
//            ],
//          ),
//          Row(
//            children: <Widget>[
//              Container(
//                width: 15,
//                height: 60,
//              ),
//              Image(
//                height: 24,
//                width: 24,
//                image: AssetImage("images/mine_icon_offline.png"),
//              ),
//              Container(
//                width: 14,
//              ),
//              Expanded(
//              child:Text('离线翻译',style: TextStyle(
//                  fontSize: 16, color: AppColor.privacyText1Color)),
//              ),
//              IconButton(
//                onPressed: () {
//                  //跳转离线翻译
//
//                },
//                icon: Image(
//                  height: 24,
//                  width: 24,
//                  image: AssetImage("images/icon_chevron_right.png"),
//                ),
//              ),
//              Container(
//                width: 15,
//              ),
//            ],
//          ),
//          Row(
//            children: <Widget>[
//              Container(
//                width: 15,
//                height: 60,
//              ),
//              Image(
//                height: 24,
//                width: 24,
//                image: AssetImage("images/mine_icon_clear.png"),
//              ),
//              Container(
//                width: 14,
//              ),
//              Expanded(
//                child:Text('清空翻译历史',style: TextStyle(
//                    fontSize: 16, color: AppColor.privacyText1Color)),
//              ),
//              GestureDetector(
//                onTap: (){
//                  databaseHelper.clear();
//                },
//                child: Text('清除',style: TextStyle(
//                    fontSize: 16, color: AppColor.red)),
//              ),
//              Container(
//                width: 15,
//              ),
//            ],
//          )
//        ]),
//      ),
//    );
//  }
//}
