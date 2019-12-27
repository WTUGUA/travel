import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveltranslation/ocr/bloc/login/login_bloc.dart';
import 'package:traveltranslation/ocr/bloc/login/login_event.dart';
import 'package:traveltranslation/ocr/bloc/login/login_state.dart';
import 'package:traveltranslation/ocr/components/setting/widgets/loginwithoutvip_component.dart';
import 'package:traveltranslation/ocr/components/setting/widgets/loginwithvip_component.dart';
import 'package:traveltranslation/ocr/components/setting/widgets/unlogin_component.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';

class SettingComponent extends StatefulWidget {
  @override
  _SettingComponentState createState() => _SettingComponentState();
}

class CustomPopupMenu {
  String title;
  IconData icon;

  CustomPopupMenu({this.title, this.icon});
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'auto', icon: Icons.home),
];
CustomPopupMenu _selectedChoices = choices[0];

class _SettingComponentState extends State<SettingComponent> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => LoginBloc(),
      child: SetPage(),
    );
  }
}

class SetPage extends StatefulWidget {
  @override
  _SetPageState createState() => _SetPageState();
}

class _SetPageState extends State<SetPage> {
  @override
  void initState() {
    super.initState();
    EventUtil.beginPageView("setting");
  }


  @override
  void dispose() {
    super.dispose();
    EventUtil.endPageView("setting");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<LoginEvent, LoginState>(
        bloc: BlocProvider.of<LoginBloc>(context),
        builder: (BuildContext context, LoginState state) {
          switch (state.runtimeType) {
            case UnLoginState:
              return UnLoginPage();
            case LoginWithOutVipState:
              return LoginWithOutVipPage();
            case LoginWithVipState:
              return LoginWithVipPage();
          }
          return Text('errorStatu');
        },
      ),
    );
  }
}
