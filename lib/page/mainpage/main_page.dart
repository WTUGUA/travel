import 'package:traveltranslation/db/database_history.dart';
import 'package:traveltranslation/ocr/components/setting/setting_component.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:traveltranslation/page/mainpage/save_page.dart';
import 'package:traveltranslation/page/mainpage/user_page.dart';
import 'package:traveltranslation/page/toast.dart';

import '../index_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    pagelist
    ..add(IndexPage())
    ..add(SavePage())
    ..add(SettingComponent());
    super.initState();

  }

  static DatabaseHelper_history databaseHelper = DatabaseHelper_history();
  int _selectedIndex = 0;
  bool showhis=false;
  List<Widget> pagelist = List();


  @override
  Widget build(BuildContext context) {
    DateTime _lastPressedAt;
    return WillPopScope(
        onWillPop: () async {
          Toast.toast(context,msg: "再按一次退出程序",position: ToastPostion.bottom);
      if (_lastPressedAt == null ||
          (DateTime.now().difference(_lastPressedAt) >
              Duration(seconds: 1))) {
        //两次点击间隔超过1秒，重新计时
        _lastPressedAt = DateTime.now();
        print(_lastPressedAt);
        return false;
      }
      return true;
    }, child:Container(
      child: Scaffold(
        body:pagelist[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: _selectedIndex == 0
                    ? Image.asset('images/tab_icon_translate_s.png')
                    : Image.asset('images/tab_icon_translate_n.png'),
                title: Text('翻译')),
            BottomNavigationBarItem(
                icon: _selectedIndex == 1
                    ? new Image.asset('images/tab_icon_save_s.png')
                    : new Image.asset('images/tab_icon_save_n.png'),
                title: Text('已保存')),
            BottomNavigationBarItem(
                icon: _selectedIndex == 2
                    ? new Image.asset('images/tab_icon_mine_s.png')
                    : new Image.asset('images/tab_icon_mine_n.png'),
                title: Text('我的'))
          ],
          currentIndex: _selectedIndex,
          fixedColor: AppColor.privacyColor,
          onTap: _onItemTapped,
        ),
        resizeToAvoidBottomPadding: false,
      ),
    )
    );

  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
