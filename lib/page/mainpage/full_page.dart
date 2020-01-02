import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';

class FullPage extends StatefulWidget {
  @override
  _FullPageState createState() => _FullPageState();
  final String text;

  FullPage({Key key, @required this.text}) : super(key: key);
}

class _FullPageState extends State<FullPage> {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: AppColor.BGColor,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: ScreenUtil.instance.setHeight(22),
            ),
            Container(
              // height: 650,
              child: RotatedBox(
                quarterTurns: 1,
                child: Container(
                    color: AppColor.BGColor,
                    width:ScreenUtil.instance.setWidth(650),
                    height: ScreenUtil.instance.setHeight(375),
                    child:FittedBox(
                        fit: BoxFit.fill,
                        //  alignment: Alignment.centerRight,
                        child: Container(
                          height:200,
                          width:300,
                          child:Center(
                            child:
                            AutoSizeText(
                              widget.text,
                              minFontSize: 40,
                              textAlign:TextAlign.center,
                            ),
                          ),
                        )
                    )
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  // padding: EdgeInsets.only(left: 5.0),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Image(
                    image: AssetImage("images/translate_icon_full.png"),
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}
