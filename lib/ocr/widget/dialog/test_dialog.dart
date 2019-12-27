import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';
import 'package:traveltranslation/ocr/widget/dialog/lead_login_dialog.dart';
import 'package:traveltranslation/ocr/widget/dialog/lead_vip_dialog.dart';
import 'package:traveltranslation/ocr/widget/dialog/message_dialog.dart';

class TestDialogPage extends StatefulWidget {
  @override
  _TestDialogPageState createState() => _TestDialogPageState();
}

class _TestDialogPageState extends State<TestDialogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("测试各种dialog"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              showDialog<Null>(
                  context: context, //BuildContext对象
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return new LeadLoginDialog();
                  });
            },
            child: Text("登录领取更多权益"),
          ),
          RaisedButton(
            onPressed: () {
              SpUtils.getUserMap().then((value) {
                var ocrNum = 2;
                var transNum = 2;
                var batchNum = 2;
                //提示用户升级未VIP
                showDialog<Null>(
                    context: context, //BuildContext对象
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new LeadVipDialog(ocrNum, transNum, batchNum);
                    });
              });
            },
            child: Text("登录状态下次数用完"),
          ),
          RaisedButton(
            onPressed: () {},
            child: Text("登录领取更多权益"),
          ),
        ],
      ),
    );
  }
}
