import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/db/database_history.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/widget/dialog/offline_dialog.dart';
import 'package:traveltranslation/page/login/unlogin_page.dart';
import 'package:traveltranslation/page/toast.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State< UserListPage> {
  static DatabaseHelper_history databaseHelper = DatabaseHelper_history();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    // TODO: implement build
    return Container(
        color: AppColor.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: ScreenUtil.instance.setWidth(15),
                height: ScreenUtil.instance.setHeight(60),
              ),
              Image(
                height: ScreenUtil.instance.setHeight(24),
                width: ScreenUtil.instance.setWidth(24),
                image: AssetImage("images/mine_icon_record.png"),
              ),
              Container(
                width: ScreenUtil.instance.setWidth(14),
              ),
              Expanded(
                child:Text('反馈',style: TextStyle(
                    fontSize: 16, color: AppColor.privacyText1Color)),
              ),
              IconButton(
                onPressed: () {
                  //跳转到反馈界面



                },
                icon: Image(
                  height: ScreenUtil.instance.setHeight(24),
                  width: ScreenUtil.instance.setWidth(24),
                  image: AssetImage("images/icon_chevron_right.png"),
                ),
              ),
              Container(
                width: ScreenUtil.instance.setWidth(15),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: ScreenUtil.instance.setWidth(15),
                height: ScreenUtil.instance.setHeight(60),
              ),
              Image(
                height: ScreenUtil.instance.setHeight(24),
                width: ScreenUtil.instance.setWidth(24),
                image: AssetImage("images/mine_icon_help.png"),
              ),
              Container(
                width: ScreenUtil.instance.setWidth(14),
              ),
              Expanded(
                child:Text('帮助',style: TextStyle(
                    fontSize: 16, color: AppColor.privacyText1Color)),
              ),
              IconButton(
                onPressed: () {
                  //跳转到帮助界面



                },
                icon: Image(
                  height: ScreenUtil.instance.setHeight(24),
                  width:ScreenUtil.instance.setWidth(24),
                  image: AssetImage("images/icon_chevron_right.png"),
                ),
              ),
              Container(
                width: ScreenUtil.instance.setWidth(15),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: ScreenUtil.instance.setWidth(15),
                height: ScreenUtil.instance.setHeight(60),
              ),
              Image(
                height: ScreenUtil.instance.setHeight(24),
                width: ScreenUtil.instance.setWidth(24),
                image: AssetImage("images/mine_icon_about.png"),
              ),
              Container(
                width: ScreenUtil.instance.setWidth(14),
              ),
              Expanded(
                child:Text('关于',style: TextStyle(
                    fontSize: 16, color: AppColor.privacyText1Color)),
              ),
              IconButton(
                onPressed: () {
                  //跳转到关于界面



                },
                icon: Image(
                  height: ScreenUtil.instance.setHeight(24),
                  width: ScreenUtil.instance.setWidth(24),
                  image: AssetImage("images/icon_chevron_right.png"),
                ),
              ),
              Container(
                width: ScreenUtil.instance.setWidth(15),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: ScreenUtil.instance.setWidth(15),
                height: ScreenUtil.instance.setHeight(60),
              ),
              Image(
                height: ScreenUtil.instance.setHeight(24),
                width: ScreenUtil.instance.setWidth(24),
                image: AssetImage("images/mine_icon_offline.png"),
              ),
              Container(
                width: ScreenUtil.instance.setWidth(14),
              ),
              Expanded(
                child:Text('离线翻译',style: TextStyle(
                    fontSize: 16, color: AppColor.privacyText1Color)),
              ),
              IconButton(
                onPressed: () {
                  //跳转离线翻译
                  showDialog<Null>(
                      context: context, //BuildContext对象
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return new OfflineDialog();
                      }).then((value) {});
                },
                icon: Image(
                  height: ScreenUtil.instance.setHeight(24),
                  width: ScreenUtil.instance.setWidth(24),
                  image: AssetImage("images/icon_chevron_right.png"),
                ),
              ),
              Container(
                width: ScreenUtil.instance.setWidth(15),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width:ScreenUtil.instance.setWidth(15),
                height: ScreenUtil.instance.setHeight(60),
              ),
              Image(
                height: ScreenUtil.instance.setHeight(24),
                width: ScreenUtil.instance.setWidth(24),
                image: AssetImage("images/mine_icon_clear.png"),
              ),
              Container(
                width: ScreenUtil.instance.setWidth(14),
              ),
              Expanded(
                child:Text('清空翻译历史',style: TextStyle(
                    fontSize: 16, color: AppColor.privacyText1Color)),
              ),
              GestureDetector(
                onTap: (){
                  databaseHelper.clear();
                  Toast.toast(context,msg: "清空翻译历史成功",position: ToastPostion.bottom);
                },
                child: Text('清除',style: TextStyle(
                    fontSize: 16, color: AppColor.red)),
              ),
              Container(
                width: ScreenUtil.instance.setWidth(15),
              ),
            ],
          )
        ]),
      );
  }
}
