import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/db/database_history.dart';
import 'package:traveltranslation/ocr/bloc/login/login_bloc.dart';
import 'package:traveltranslation/ocr/bloc/login/login_event.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/config/application.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';
import 'package:traveltranslation/page/mainpage/user_list_page.dart';

class LoginWithOutVipPage extends StatefulWidget {
  @override
  _LoginWithOutVipPageState createState() => _LoginWithOutVipPageState();
}

class _LoginWithOutVipPageState extends State<LoginWithOutVipPage> {
  String tel="";
  static DatabaseHelper_history databaseHelper = DatabaseHelper_history();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  Future getUser() async {
    var userEntityInfo = await SpUtils.getUserMap();
    //tel = userEntityInfo.tel;
    setState(() {
      tel = userEntityInfo.tel.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    return Scaffold(
      body:
      //增加判断是否登录 或者是否为VIP
      Container(
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
              left: ScreenUtil.instance.setWidth(110),
              child: Container(
                height: ScreenUtil.instance.setHeight(186),
                width: ScreenUtil.instance.setWidth(280),
                color: AppColor.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(tel,
                        style: TextStyle(
                            fontSize: 18, color: AppColor.privacyText1Color)),
                    GestureDetector(
                      onTap: (){
                        Application.router
                            .navigateTo(context, "/vip")
                            .then((value) {
                          if (UserDelegate.userStatus == UserStatus.VIP) {
                            BlocProvider.of<LoginBloc>(context)
                                .dispatch(new LoginVipEvent());
                          } else {
                            BlocProvider.of<LoginBloc>(context)
                                .dispatch(new LoginActionEvent());
                          }
                        });
                      },
                      child:Row(
                        children: <Widget>[
                          Image(
                            image: AssetImage("images/mine_icon_vip.png"),
                          ),
                          Text('开通VIP',
                              style: TextStyle(
                                  fontSize: 13, color: AppColor.privacyTextColor))
                        ],
                      ),
                    )
                  ],
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
                          image: AssetImage("images/mine_icon_head3.png"),
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
