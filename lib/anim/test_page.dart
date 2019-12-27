import 'dart:math';

import 'package:flutter/material.dart';

class AnimPage extends StatefulWidget {
  @override
  _AnimPageState createState() => _AnimPageState();
}

class _AnimPageState extends State<AnimPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter之旅"),
      ),
      body: CustomPaint(
        painter: AnimView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //TODO 执行动画
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AnimView extends CustomPainter {
  Paint mPaint;
  Paint gridPaint;
  AnimView() {
    mPaint = new Paint();
    gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.cyanAccent;
    mPaint.color = Colors.deepOrange;
  }
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(gridPath(area: Size(500, 1000)), gridPaint);//绘制网格
    canvas.translate(200, 200);
    canvas.drawPath(nStarPath(5, 100, 50), mPaint);//绘制五角星
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/// 可以创建一个外接圆半径为[R],内接圆半径半径为[r]的[num]角星,
Path nStarPath(int num, double R, double r) {
  Path path = new Path();
  double perDeg = 360 / num;
  double degA = perDeg/2/2;
  double degB = (360 / (num - 1) - degA) / 2 + degA;

  path.moveTo(cos(_rad(degA)) * R, (-sin(_rad(degA)) * R));
  for (int i = 0; i < num; i++) {
    path.lineTo(
        cos(_rad(degA + perDeg * i)) * R, -sin(_rad(degA + perDeg * i)) * R);
    path.lineTo(
        cos(_rad(degB + perDeg * i)) * r, -sin(_rad(degB + perDeg * i)) * r);
  }
  path.close();
  return path;
}

double _rad(double deg) {
  return deg * pi / 180;
}

///创建一个区域是[area]，小格边长为[step]的网格的路径
Path gridPath({double step = 20, Size area}) {
  Path path = Path();
  for (int i = 0; i < area.height / step + 1; i++) {
    //画横线
    path.moveTo(0, step * i); //移动画笔
    path.lineTo(area.width, step * i); //画直线
  }

  for (int i = 0; i < area.width / step + 1; i++) {
    //画纵线
    path.moveTo(step * i, 0);
    path.lineTo(step * i, area.height);
  }
  return path;
}

//正弦曲线
class ShakeCurve extends Curve {
  @override
  double transform(double t) {
//    return math.sin(t * math.PI * 2);
  }
}

