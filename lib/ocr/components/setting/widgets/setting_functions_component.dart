import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveltranslation/ocr/bloc/login/login_bloc.dart';
import 'package:traveltranslation/ocr/bloc/login/login_event.dart';
import 'package:traveltranslation/ocr/config/application.dart';
import 'package:traveltranslation/ocr/config/routes.dart';
import 'package:traveltranslation/ocr/util/free_try_utils.dart';
import 'package:traveltranslation/ocr/util/rate_util.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';
import 'package:traveltranslation/ocr/widget/right_arrow.dart';
import 'package:toast/toast.dart';

class SettingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            //如果用户登录过
            if (UserDelegate.userStatus != UserStatus.GUEST) {
              SpUtils.getUserMap().then((user) {
                if (user.canPay) {
                  Application.router.navigateTo(context, "/vip").then((value) {
                    if (UserDelegate.userStatus == UserStatus.VIP) {
                      BlocProvider.of<LoginBloc>(context)
                          .dispatch(new LoginVipEvent());
                    } else {
                      BlocProvider.of<LoginBloc>(context)
                          .dispatch(new LoginActionEvent());
                    }
                  });
                } else {
                  Toast.show("无法在不同平台续订", context);
                }
              });
            } else {
              //如果用户没有登录过但是用户使用ios设备

              if (Platform.isIOS) {
                Application.router.navigateTo(context, "/vip").then((value) {
                  if (UserDelegate.userStatus == UserStatus.VIP) {
                    BlocProvider.of<LoginBloc>(context)
                        .dispatch(new LoginVipEvent());
                  } else {
                    BlocProvider.of<LoginBloc>(context)
                        .dispatch(new LoginActionEvent());
                  }
                });
              } else {
                Toast.show("请先登录", context);
                Application.router
                    .navigateTo(context, Routes.settingLogin)
                    .then((value) {});
              }
            }
          },
          leading: Image.asset(
            "images/icon_vip.png",
            height: 32.0,
            width: 32.0,
          ),
          title: Text("购买VIP"),
          trailing: DefaultRightArrow(),
        ),
        ListTile(
          onTap: () {
            Application.router.navigateTo(context, Routes.settingHelp);
          },
          leading: Image.asset(
            "images/icon_help.png",
            height: 32.0,
            width: 32.0,
          ),
          title: Text("帮助文档"),
          trailing: DefaultRightArrow(),
        ),
        ListTile(
          onTap: () {
            RateUtils.showRateDialog(context);
          },
          leading: Image.asset(
            "images/icon_help.png",
            height: 32.0,
            width: 32.0,
          ),
          title: Text("给我们评分"),
          trailing: DefaultRightArrow(),
        ),
//        ListTile(
//          onTap: () {
//            TryUtils.clearIosKey();
//            Toast.show("清楚成功", context);
//
//          },
//          leading: Image.asset(
//            "images/icon_help.png",
//            height: 32.0,
//            width: 32.0,
//          ),
//          title: Text("清楚试用次数记录"),
//          trailing: DefaultRightArrow(),
//        ),
      ],
    );
  }
}
