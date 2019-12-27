import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class VipBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapDelegate,
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil.instance.width,
        height: ScreenUtil.instance.setHeight(108),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: AppColor.vipGradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Text(
          "立即开通",
          style: TextStyle(color: AppColor.vipText, fontSize: 17.0),
        ),
      ),
    );
  }

  Function onTapDelegate;

  VipBottomWidget({this.onTapDelegate});
}
