import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:traveltranslation/page/mainlist_page.dart';

import './body_page.dart';
import './textfield_page.dart';
import './recording_page.dart';


class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    //  CheckListView();
    return Container(
      child: Scaffold(
        body: Column(
          //可以通过_widgetOptions设置不同页面
          children: <Widget>[
            Container(
              height: ScreenUtil.instance.setHeight(20),
            ),
            IndexBody(),
            TextFieldDemo(),
            Container(
              height: ScreenUtil.instance.setHeight(10),
            ),
            Expanded(child: MainList()),
          ],
        ),
        resizeToAvoidBottomPadding: false,
      ),
    );
  }
}
