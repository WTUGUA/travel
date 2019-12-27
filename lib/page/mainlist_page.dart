
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/db/database_history.dart';

import 'package:traveltranslation/ocr/config/app_color.dart';

import 'package:traveltranslation/page/recording_page.dart';

class MainList extends StatefulWidget {
  @override
  _MainListState createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  static DatabaseHelper_history databaseHelper = DatabaseHelper_history();
  GlobalKey<RecordingPageState> ListKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    // TODO: implement build
    return Container(
        height: ScreenUtil.instance.setHeight(341),
        child: Column(
          children: <Widget>[
            Container(
                height: ScreenUtil.instance.setHeight(40),
                padding: EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '翻译历史',
                      style: TextStyle(
                          color: AppColor.privacyText1Color, fontSize: 20),
                    ),
                    InkWell(
                      onTap: () {
                        //清空翻译历史
                        //刷新主界面
                        setState(() {
                          databaseHelper.clear();
                          ListKey.currentState.updateListView();
                        });
                        print('清空翻译历史');
                      },
                      child: Text(
                        '清空全部历史',
                        style: TextStyle(
                            color: AppColor.LoginTextColor, fontSize: 12),
                      ),
                    )
                  ],
                )),
            RecordingPage(ListKey),
          ],
        ));
  }
}
