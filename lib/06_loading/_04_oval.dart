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
          child: OvalLoading(150),
        ),
      ),
    );
  }
}

class OvalLoading extends StatefulWidget {
  final double size;
  const OvalLoading(this.size, {super.key});

  @override
  State<OvalLoading> createState() => _OvalLoadingState();
}

class _OvalLoadingState extends State<OvalLoading> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = Tween<double>(begin: 0, end: pi * 2).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _ctrl.repeat(reverse: false);
      },
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: OvalLoadingPainter(animation),
      ),
    );
  }
}

class OvalLoadingPainter extends CustomPainter {
  Animation<double> animation;

  OvalLoadingPainter(this.animation, {this.radius = 15, this.a = 0.4}) : super(repaint: animation);

  final List<Color> colors = const [Color(0xffF44336), Color(0xff5C6BC0), Color(0xffFFB74D), Color(0xff8BC34A)];

  final Paint _paint = Paint();
  final double radius;
  final double a;

  @override
  void paint(Canvas canvas, Size size) {
    double zoneSize = size.shortestSide / 2;
    canvas.translate(size.width / 2, size.height / 2);

    drawItem(canvas, zoneSize, 0, colors[0]);
    drawItem(canvas, zoneSize, pi / 2, colors[1]);
    drawItem(canvas, zoneSize, -pi / 2, colors[2]);
    drawItem(canvas, zoneSize, pi, colors[3]);
  }

  double f(double t) => cos(t);
  double g(double t) => a * sin(t);

  void drawItem(Canvas canvas, double zoneSize, double rad, Color color) {
    // 0 ~ 2*pi
    double x = (zoneSize - radius) * f(animation.value);
    double y = (zoneSize - radius) * g(animation.value);

    canvas.save();
    canvas.rotate(rad);
    canvas.drawCircle(Offset(x, y), radius, _paint..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant OvalLoadingPainter oldDelegate) =>
      oldDelegate.a != a || oldDelegate.animation != animation;
}
