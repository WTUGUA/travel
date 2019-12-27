import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveltranslation/ocr/bloc/login/login_bloc.dart';
import 'package:traveltranslation/ocr/bloc/login/login_event.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';

class LogoutBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          gradient: LinearGradient(
              colors: [Color(0xFF0056FF), Color(0xFF008FFF)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter)),
      margin: EdgeInsets.only(bottom: 50.0),
      child: FlatButton(
          onPressed: () {
            clearCache().then((value) {
              BlocProvider.of<LoginBloc>(context).dispatch(LogoutActionEvent());
            });
          },
          child: Text(
            "退出当前账户",
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          )),
    );
  }

  Future clearCache() async {
    //删除缓存
    await SpUtils.saveUserToken("");
    //重制用户状态
    UserDelegate.userStatus = UserStatus.GUEST;
  }
}
