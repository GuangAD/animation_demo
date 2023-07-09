import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: RotateLoading(),
        ),
      ),
    );
  }
}

class RotateLoading extends StatefulWidget {
  const RotateLoading({super.key});

  @override
  State<RotateLoading> createState() => _RotateLoadingState();
}

class _RotateLoadingState extends State<RotateLoading> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 200),
      painter: RotateLoadingPainter(_ctrl),
    );
  }
}

class RotateLoadingPainter extends CustomPainter {
  Animation<double> animation;
  double itemWidth;
  double span;
  Tween<double> rotateTween = Tween(begin: 0, end: -pi * 2);
  final List<Color> _colors = const [Color(0xffF44336), Color(0xff5C6BC0), Color(0xffFFB74D), Color(0xff8BC34A)];
  RotateLoadingPainter(
    this.animation, {
    this.itemWidth = 33,
    this.span = 16,
  }) : super(repaint: animation);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(animation.value * 2 * pi);
    final double len = itemWidth / 2 + span / 2;
    final Paint paint = Paint(); //画板
    // 绘制红色
    Offset centerA = Offset(-len, -len);
    drawItem(canvas, centerA, paint, _colors[0]);

    // 绘制蓝色
    Offset centerB = Offset(len, len);
    drawItem(canvas, centerB, paint, _colors[1]);

    // 绘制橙色
    Offset centerC = Offset(len, -len);
    drawItem(canvas, centerC, paint, _colors[2]);

    // 绘制绿色
    Offset centerD = Offset(-len, len);
    drawItem(canvas, centerD, paint, _colors[3]);
  }

  void drawItem(Canvas canvas, Offset center, Paint paint, Color color) {
    Rect rect = Rect.fromCenter(center: center, width: itemWidth, height: itemWidth);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotateTween.evaluate(animation) * 2);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(5)),
      paint..color = color,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RotateLoadingPainter oldDelegate) => oldDelegate.animation != animation;
}
