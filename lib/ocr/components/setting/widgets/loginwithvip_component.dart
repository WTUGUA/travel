import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/ocr/components/setting/widgets/setting_functions_component.dart';

import 'package:traveltranslation/ocr/components/setting/widgets/avatar_view.dart';
import 'package:traveltranslation/ocr/components/setting/widgets/logout_bottom.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/entity/user_info_entity.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';
import 'package:traveltranslation/ocr/util/time_util.dart';
import 'package:traveltranslation/page/mainpage/user_list_page.dart';

class LoginWithVipPage extends StatefulWidget {
  @override
  _LoginWithVipPageState createState() => _LoginWithVipPageState();
}

class _LoginWithVipPageState extends State<LoginWithVipPage> {
  UserEntityInfo userEntityInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  Future getUser() async {
    userEntityInfo = await SpUtils.getUserMap();
    if(mounted){
      setState(() {

      });
    }
  }

  @override
  void deactivate() {
    print("刷新结果");
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    return Scaffold(
      body:
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
              top: 100,
              right: 245,
              child: Container(
                height: ScreenUtil.instance.setHeight(186),
                width: ScreenUtil.instance.setWidth(375),
                color: AppColor.white,
              ),
            ),
            Positioned(
              top: 100,
              left: 100,
              child: Container(
                height: ScreenUtil.instance.setHeight(186),
                width: ScreenUtil.instance.setWidth(280),
                color: AppColor.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Text(
                      userEntityInfo == null
                          ? ""
                          : userEntityInfo.tel.toString(),
                      style:
                      TextStyle(color: AppColor.privacyText1Color, fontSize: 18.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image(
                          image: AssetImage("images/mine_icon_vip.png"),
                        ),
                        Text(
                            userEntityInfo == null||userEntityInfo.viptime==null
                                ? ""
                                : TimeUtils.transUnixTime(
                                userEntityInfo.viptime.toInt()),
                            style: TextStyle(fontSize: 13.0, color: AppColor.privacyTextColor)),
                        Text(
                          "到期",
                          style: TextStyle(
                              fontSize: 13, color: AppColor.privacyTextColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 15,
              top: 70,
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
                          image: AssetImage("images/meizi.png"),
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
