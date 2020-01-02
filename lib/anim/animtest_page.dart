import 'package:flutter/material.dart';
import 'dart:math';

import 'package:traveltranslation/ocr/config/app_color.dart';

class DrawingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: CurvePainter(),
      ),
    );
  }
}




class CurvePainter extends CustomPainter {
  //如果外部没有指定颜色值，则使用此默认颜色值
  static final Color defaultColor = Colors.lightBlue;
  //画笔对象
  var _paint = Paint();
  //圆形路径
  Path _circlePath = Path();
  //波浪路径
  Path _wavePath = Path();

  @override
  void paint(Canvas canvas, Size size) {
    double side = min(size.width, size.height);
    double radius = side / 2.0;
    _paint
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color =defaultColor;
    //_drawText(canvas: canvas, side: side, colors: backgroundColor);

    _circlePath.reset();
    _circlePath.addArc(Rect.fromLTWH(0, 0, side, side), 0, 2 * pi);

    double waveWidth = side * 0.9;
    double waveHeight = side / 50;
    _wavePath.reset();
    _wavePath.moveTo(-waveWidth, radius);
    for (double i = -waveWidth; i < side; i += waveWidth) {
      _wavePath.relativeQuadraticBezierTo(
          waveWidth / 4, -waveHeight, waveWidth / 2, 0);
      _wavePath.relativeQuadraticBezierTo(
          waveWidth / 4, waveHeight, waveWidth / 2, 0);
    }
    //为了方便读者理解，这里把路径绘制出来，实际上不需要
    canvas.drawPath(_wavePath, _paint);

    //第二条曲线
    Path path=Path();
    var paint1 = Paint();
    paint1
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color =AppColor.privacyColor;
    double waveWidth1 = side * 20;
    double waveHeight1 = side / 100;
    path.reset();
    path.moveTo(-waveWidth1, radius);
    for (double i = -waveWidth1; i < side; i += waveWidth1) {
      path.relativeQuadraticBezierTo(
          waveWidth1 / 8, -waveHeight1, waveWidth1 / 4, 0);
      path.relativeQuadraticBezierTo(
          waveWidth1 / 16, waveHeight1, waveWidth1 / 2, 0);
    }
    //为了方便读者理解，这里把路径绘制出来，实际上不需要
    canvas.drawPath(path, paint1);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
