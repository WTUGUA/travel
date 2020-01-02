
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';

class WaveLoadingWidget extends StatefulWidget {
  final Color backgroundColor;

  final Color foregroundColor;

  final Color waveColor;

  WaveLoadingWidget(
      {
        @required this.backgroundColor,
        @required this.foregroundColor,
        @required this.waveColor}) {
    assert(backgroundColor != null && backgroundColor == AppColor.white);
  }

  @override
  _WaveLoadingWidgetState createState() => _WaveLoadingWidgetState(
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    waveColor: waveColor,
  );
}

class _WaveLoadingWidgetState extends State<WaveLoadingWidget>
    with SingleTickerProviderStateMixin {

  final Color backgroundColor;

  final Color foregroundColor;

  final Color waveColor;

  AnimationController controller;

  Animation<double> animation;

  _WaveLoadingWidgetState(
      {
        @required this.backgroundColor,
        @required this.foregroundColor,
        @required this.waveColor});

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    controller.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.dismissed:
          print("dismissed");
          break;
        case AnimationStatus.forward:
          print("forward");
          break;
        case AnimationStatus.reverse:
          print("reverse");
          break;
        case AnimationStatus.completed:
          print("completed");
          break;
      }
    });

    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(controller)
      ..addListener(() {
        setState(() => {
          //controller.stop()
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaveLoadingPainter(
        animatedValue: animation.value,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        waveColor: waveColor,
      ),
    );
  }
}



//绘图类
class WaveLoadingPainter extends CustomPainter {
  //如果外部没有指定颜色值，则使用此默认颜色值
  static final Color defaultColor = Colors.lightBlue;

  //画笔对象
  var _paint = Paint();

  //圆形路径
  Path _circlePath = Path();

  //波浪路径
  Path _wavePath = Path();


  final double animatedValue;

  final Color backgroundColor;

  final Color foregroundColor;

  final Color waveColor;

  WaveLoadingPainter(
      {
        this.animatedValue,
        this.backgroundColor,
        this.foregroundColor,
        this.waveColor}) {
    _paint
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..strokeWidth = 3
      ..color = waveColor ?? defaultColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double side = min(size.width, size.height);
    double radius = side / 2.0;
    _paint
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color =AppColor.privacyColor;
    //_drawText(canvas: canvas, side: side, colors: backgroundColor);

//    _circlePath.reset();
//    _circlePath.addArc(Rect.fromLTWH(0, 0, side, side), 0, 2 * pi);
    double waveWidth = side * 0.8;
    double waveHeight = side / 15;
    _wavePath.reset();
    _wavePath.moveTo((animatedValue - 1) * waveWidth, radius);
    for (double i = -waveWidth; i < side; i += waveWidth) {
      _wavePath.relativeQuadraticBezierTo(
          waveWidth / 4, -waveHeight, waveWidth / 2, 0);
      _wavePath.relativeQuadraticBezierTo(
          waveWidth / 4, waveHeight, waveWidth / 2, 0);
    }
//    _wavePath.relativeLineTo(0, radius);
//    _wavePath.lineTo(-waveWidth, side);
//    _wavePath.close();
    //为了方便读者理解，这里把路径绘制出来，实际上不需要
    canvas.drawPath(_wavePath, _paint);

    //第二条曲线
    Path path=Path();
    var paint1 = Paint();
    paint1
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color =AppColor.privacyColor;
    double waveWidth1 = side * 0.6;
    double waveHeight1 = side / 21;
    path.reset();
    path.moveTo((animatedValue - 1) *waveWidth1, radius);
    for (double i = -waveWidth1; i < side; i += waveWidth1) {
      path.relativeQuadraticBezierTo(
          waveWidth1 / 4, -waveHeight1, waveWidth1 / 2, 0);
      path.relativeQuadraticBezierTo(
          waveWidth1 / 4, waveHeight1, waveWidth1 / 2, 0);
    }
    //为了方便读者理解，这里把路径绘制出来，实际上不需要
    canvas.drawPath(path, paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}