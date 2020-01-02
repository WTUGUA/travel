import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/config/application.dart';
import 'package:traveltranslation/ocr/config/routes.dart';
import 'package:traveltranslation/ocr/entity/login_entity.dart';
import 'package:traveltranslation/ocr/helpers/service_helpers.dart';
import 'package:traveltranslation/ocr/util/common_util.dart';
import 'package:traveltranslation/ocr/util/fluro_utils.dart';
import 'package:traveltranslation/ocr/util/keyboard_utils.dart';
import 'package:traveltranslation/ocr/util/navo_kv_utils.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:async';

import 'package:traveltranslation/page/mainpage/main_page.dart';

class LoginComponent extends StatefulWidget {
  @override
  _LoginComponentState createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController authController = TextEditingController();
  FocusNode focusNode = new FocusNode();
  FocusNode focusNode1 = new FocusNode();
  Color Btcolor = AppColor.privacyColor;
  bool Btpress = true;
  bool textnull = true;
  bool authBt = true;

  @override
  void initState() {
    super.initState();
    EventUtil.beginPageView("login");
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
    EventUtil.endPageView("login");
  }

  //发送验证码计时
  Timer _timer;
  int _countdownTime = 0;

  _login() async {
    EventUtil.onEvent(EventUtil.loginClick);
    KeyBoardUtils.closeKeyBoard(context);
    if (phoneController.text.isEmpty) {
      showToast("手机号不能为空", position: ToastPosition.center);
      return;
    }
    if (authController.text.isEmpty) {
      showToast("验证码不能为空", position: ToastPosition.center);
      return;
    }
    //调用登录填写电话号码信息和验证码信息
    LoginEntity loginEntity =
        await ServiceApi.login(phoneController.text, authController.text);
    if (loginEntity.code == 0) {
      showToast("登录成功", position: ToastPosition.center);
      bool isvip = loginEntity.res.info.vip;
      if (isvip) {
        //跳转到VIP 登录界面
        //跳转到主界面
        UserDelegate.userStatus = UserStatus.VIP;
        // Navigator.popAndPushNamed(context, '/mainview');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => MainPage()),
            (Route router) => false);
      } else {
        //跳转到普通用户界面
        //跳转到主界面
        UserDelegate.userStatus = UserStatus.GENERAL;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => MainPage()),
            (Route router) => false);
      }
    } else {
      //登录失败
      showToast(loginEntity.msg.toString(), position: ToastPosition.center);
    }
  }

//发送验证码
  _getAuthCode() async {
    EventUtil.onEvent(EventUtil.codeClick);
    if (phoneController.text.isEmpty) {
      showToast("手机号不能为空", position: ToastPosition.center);
      return;
    }
    if (mounted) {
      if (_countdownTime == 0) {
        print("getAuthCode");
        setState(() {
          _countdownTime = 5;
        });
        //开始倒计时
        startCountdownTimer();

        var result = await ServiceApi.sendAuth(phoneController.text);
        if (result) {
          showToast("发送验证码成功", position: ToastPosition.bottom);
        } else {
          showToast("发送验证码失败", position: ToastPosition.bottom);
        }
      }
    }
  }

//开始倒计时
  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
          if (mounted)
            {
              setState(() {
                if (_countdownTime < 1) {
                  _timer.cancel();
                } else {
                  _countdownTime = _countdownTime - 1;
                }
              })
            }
        };

    _timer = Timer.periodic(oneSec, callback);
  }

//界面布局
  @override
  Widget build(BuildContext context) {
    phoneController.addListener(() {
      setState(() {
        if (phoneController.text.isEmpty) {
          authBt = true;
          textnull = true;
        } else {
          authBt = false;
          textnull = false;
        }
      });
    });
    ScreenUtil.instance = ScreenUtil(width: 375, height: 667)..init(context);
    return OKToast(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 40.0),
        color: AppColor.privacyColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: ScreenUtil.instance.setHeight(17),
                  //padding: EdgeInsets.only(right: 10),
                  child: FlatButton(
                    onPressed: () {
                      //设置用户身份为游客 跳转主界面
                      if (UserDelegate.userStatus == UserStatus.GUEST) {
                        UserDelegate.userStatus = UserStatus.GUEST;
                      } else {
                        if (UserDelegate.userStatus == UserStatus.GENERAL) {
                          UserDelegate.userStatus = UserStatus.GENERAL;
                        } else {
                          UserDelegate.userStatus = UserStatus.VIP;
                        }
                      }
                      // Navigator.popAndPushNamed(context, '/mainview');
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => MainPage()),
                          (Route router) => false);
                    },
                    child: Text('跳过',
                        style: TextStyle(fontSize: 12, color: AppColor.white)),
                    color: AppColor.privacyColor,
                  ),
                )
              ],
            ),
            Container(
              height: ScreenUtil.instance.setHeight(42),
              padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(2), left: ScreenUtil.instance.setWidth(30)),
              child: Text('登录',
                  style: TextStyle(fontSize: 28, color: AppColor.white)),
            ),
            SizedBox(height: ScreenUtil.instance.setHeight(40)),
            Container(
                padding: const EdgeInsets.only(left: 35, right: 35),
                decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: Container(
                    width: ScreenUtil.instance.setWidth(375),
                    child: Column(
                      children: <Widget>[
                        Container(
                            height: ScreenUtil.instance.setHeight(90),
                            width: ScreenUtil.instance.setWidth(315),
                            padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(30)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: TextField(
                                    focusNode: focusNode,
                                    controller: phoneController,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      hintText: '请输入手机号',
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColor.LoginLineColor)),
                                    ),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16.0),
                                  ),
                                ),
                                Offstage(
                                    offstage: Btpress,
                                    child: IconButton(
                                      onPressed: () {
                                        phoneController.clear();
                                      },
                                      icon: Image(
                                        image: AssetImage(
                                            "images/translate_icon_cancel.png"),
                                      ),
                                    ))
                              ],
                            )),
                        Container(
                          height: ScreenUtil.instance.setHeight(60),
                          width: ScreenUtil.instance.setWidth(315),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  focusNode: focusNode1,
                                  controller: authController,
                                  maxLines: 1,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                      //  fillColor: Colors.white,
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColor.LoginLineColor)),
                                      hintText: '请输入验证码'),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                                flex: 1,
                              ),
                              Container(
                                height: ScreenUtil.instance.setHeight(26),
                                //padding: EdgeInsets.only(top: 82, left: 30, right: 30),
                                child: FlatButton(
                                  onPressed:
                                      _countdownTime > 0 ? () {} : _getAuthCode,
                                  child: Text(
                                      _countdownTime > 0
                                          ? '$_countdownTime后重新获取'
                                          : '获取验证码',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 12, color: AppColor.white)),
                                  color: authBt
                                      ? AppColor.LoginBT1Color
                                      : AppColor.privacyColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: ScreenUtil.instance.setHeight(84),
                          width: ScreenUtil.instance.setWidth(315),
                          padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(40)),
                          child: FlatButton(
                            onPressed: () {
                              //TravelSP.savePrivacy(true);
                              _login();
                            },
                            child: Text('登录',
                                style: TextStyle(
                                    fontSize: 16, color: AppColor.white)),
                            color: textnull
                                ? AppColor.LoginBT1Color
                                : AppColor.privacyColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxHeight: ScreenUtil.instance.setHeight(115.0)),
                        ),
                        Offstage(
                          offstage: true,
                          child: Column(
                            children: <Widget>[
                              Text(
                                '——  快速登录  ——',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: AppColor.privacyText1Color),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                    maxHeight:
                                        ScreenUtil.instance.setHeight(10.0)),
                              ),
                              Container(
                                height: ScreenUtil.instance.setHeight(80),
                                width: ScreenUtil.instance.setWidth(80),
                                child: IconButton(
                                  onPressed: () {
                                    //接入微信登陆

                                  },
                                  icon: Image(
                                    image: AssetImage(
                                        "images/icon_share_weixin.png"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxHeight: ScreenUtil.instance.setHeight(105.0)),
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxHeight: ScreenUtil.instance.setHeight(76.0)),
                        ),
                      ],
                    )))
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    ));
  }
}
