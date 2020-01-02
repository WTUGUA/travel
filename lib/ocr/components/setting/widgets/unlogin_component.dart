import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveltranslation/db/database_history.dart';
import 'package:traveltranslation/ocr/bloc/login/login_bloc.dart';
import 'package:traveltranslation/ocr/bloc/login/login_event.dart';
import 'package:traveltranslation/ocr/components/setting/login_component.dart';
import 'package:traveltranslation/ocr/components/setting/widgets/avatar_view.dart';
import 'package:traveltranslation/ocr/components/setting/widgets/setting_functions_component.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/config/application.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';
import 'package:traveltranslation/ocr/widget/right_arrow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/page/mainpage/user_list_page.dart';

class UnLoginPage extends StatefulWidget {
  @override
  _UnLoginPageState createState() => _UnLoginPageState();
}

class _UnLoginPageState extends State<UnLoginPage> {
  static DatabaseHelper_history databaseHelper = DatabaseHelper_history();
  bool ShowBuyVip=true;
  @override
  void initState() {
    super.initState();
    verifyUser();
    if (Platform.isIOS) {
      setState(() {
        ShowBuyVip=false;
      });
    }
  }

  Future verifyUser() async {
    var userState = UserDelegate.getUserState();
    switch (userState) {
      case UserStatus.GUEST:
        break;
      case UserStatus.GENERAL:
        BlocProvider.of<LoginBloc>(context).dispatch(LoginActionEvent());
        break;
      case UserStatus.VIP:
        BlocProvider.of<LoginBloc>(context).dispatch(LoginVipEvent());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    return Scaffold(
      body: Container(
        color: AppColor.white,
        child: Column(children: <Widget>[
          Stack(children: <Widget>[
            Positioned(
              child: Container(
                height: ScreenUtil.instance.setHeight(186),
                width: ScreenUtil.instance.setWidth(375),
                color: AppColor.dialogueColor,
              ),
            ),
            Positioned(
              top: ScreenUtil.instance.setHeight(100),
              right: ScreenUtil.instance.setWidth(245),
              child: Container(
                height: ScreenUtil.instance.setHeight(186),
                width: ScreenUtil.instance.setWidth(375),
                color: AppColor.white,
              ),
            ),
            Positioned(
              top: ScreenUtil.instance.setHeight(100),
              left:ScreenUtil.instance.setWidth(110),
              child: Container(
                height: ScreenUtil.instance.setHeight(95),
                width: ScreenUtil.instance.setWidth(280),
                color: AppColor.white,
                child: GestureDetector(
                  onTap: (){
                    //跳转到登录界面 IOS添加游客购买功能
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => LoginComponent()))
                        .then((value) {
                      print("登录页面结果$value");
                      if (value != null) {
                        switch (value) {
                          case UserStatus.GENERAL:
                            BlocProvider.of<LoginBloc>(context)
                                .dispatch(LoginActionEvent());
                            break;
                          case UserStatus.VIP:
                            BlocProvider.of<LoginBloc>(context).dispatch(LoginVipEvent());
                            break;
                        }
                      }
                    });
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
                          Text('登录可以享受更多特权哦~',
                              style: TextStyle(
                                  fontSize: 13, color: AppColor.privacyTextColor))
                        ],
                      ),
                      Offstage(
                        offstage:  ShowBuyVip,
                        child:GestureDetector(
                          onTap: (){
                            Application.router.navigateTo(context, "/vip").then((value) {
                              if (UserDelegate.userStatus == UserStatus.VIP) {
                                BlocProvider.of<LoginBloc>(context)
                                    .dispatch(new LoginVipEvent());
                              } else {
                                BlocProvider.of<LoginBloc>(context)
                                    .dispatch(new LoginActionEvent());
                              }
                            });
                          },
                          child:Text('游客状态购买VIP',
                              style: TextStyle(
                                  fontSize: 13, color: AppColor.privacyTextColor)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: ScreenUtil.instance.setWidth(15),
              top: ScreenUtil.instance.setHeight(70),
              child: Container(
                  height: ScreenUtil.instance.setHeight(90),
                  width: ScreenUtil.instance.setWidth(90),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppColor.white),
                  child: Center(
                    child: ClipOval(
                      child: Image(
                          width: ScreenUtil.instance.setWidth(80),
                          height: ScreenUtil.instance.setHeight(75),
                          image: AssetImage("images/mine_icon_head.png"),
                          fit: BoxFit.cover),
                    ),
                  )),
            )
          ]),
         UserListPage(),
        ]),
      ),
    );
  }
}
