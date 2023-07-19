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
      painter: CrossLoadingPainter(_ctrl),
    );
  }
}

class CrossLoadingPainter extends CustomPainter {
  Animation<double> animation;
  double itemWidth;
  Tween<double> rotateTween = Tween(begin: 0, end: -pi * 2);
  final List<Color> _colors = const [Color(0xffF44336), Color(0xff5C6BC0), Color(0xffFFB74D), Color(0xff8BC34A)];
  CrossLoadingPainter(
    this.animation, {
    this.itemWidth = 33,
  }) : super(repaint: animation);
  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey.withAlpha(11));

    canvas.translate(size.width / 2, size.height / 2);

    final double begin = itemWidth / sqrt(pi / 2);
    final double end = -size.height / 2 + itemWidth / sqrt(pi / 2);

    drawItem(canvas, begin, end, _colors[0], true);
    drawItem(canvas, -begin, -end, _colors[1], true);
    drawItem(canvas, -begin, -end, _colors[2], false);
    drawItem(canvas, begin, end, _colors[3], false);
  }

  void drawItem(Canvas canvas, double begin, double end, Color color, bool vertical, {Curve curve = Curves.linear}) {
    Animatable<double> tween = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: begin, end: end),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: end, end: begin),
          weight: 1,
        ),
      ],
    ).chain(CurveTween(curve: curve));
    drawDiamond(
      canvas,
      tween.evaluate(animation),
      color,
      vertical,
    );
  }

  void drawDiamond(Canvas canvas, double offset, Color color, bool vertical) {
    canvas.save();
    if (vertical) {
      canvas.translate(0, offset);
    } else {
      canvas.translate(offset, 0);
    }
    canvas.rotate(45 / 180 * pi);
    canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: itemWidth, height: itemWidth), _paint..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CrossLoadingPainter oldDelegate) => oldDelegate.animation != animation;
}
