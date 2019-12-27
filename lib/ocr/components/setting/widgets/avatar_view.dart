import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginAvatar extends StatelessWidget {
  final String avatarName;
  LoginAvatar({this.avatarName});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        avatarName,
        width: ScreenUtil.instance.setWidth(130),
        height: ScreenUtil.instance.setHeight(130),
      ),
    );
  }
}
