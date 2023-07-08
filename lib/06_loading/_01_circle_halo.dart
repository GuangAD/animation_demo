import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

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
          child: CircleHalo(),
        ),
      ),
    );
  }
}

class CircleHalo extends StatefulWidget {
  const CircleHalo({super.key});

  @override
  State<CircleHalo> createState() => _CircleHaloState();
}

class _CircleHaloState extends State<CircleHalo> with SingleTickerProviderStateMixin {
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
      painter: CircleHaloPainter(_ctrl),
    );
  }
}

class CircleHaloPainter extends CustomPainter {
  static final List<Color> _color = [
    const Color(0xFFF60C0C),
    const Color(0xFFF3B913),
    const Color(0xFFE7F716),
    const Color(0xFF3DF30B),
    const Color(0xFF0DF6EF),
    const Color(0xFF0829FB),
    const Color(0xFFB709F4),
  ];

  Animation<double> animation;
  late Animation<double> _breatheAnima;
  late Animation<double> _rotateAnima;
  final List<Color> _colors = [];
  late List<double> _pos;
  CircleHaloPainter(this.animation) : super(repaint: animation) {
    _rotateAnima = Tween<double>(begin: 0, end: 2 * pi).chain(CurveTween(curve: Curves.linear)).animate(animation);
    _breatheAnima = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 4),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 4, end: 0),
          weight: 1,
        ),
      ],
    ).chain(CurveTween(curve: Curves.linear)).animate(animation);
    _colors
      ..addAll(_color)
      ..addAll(_color.reversed.toList());
    _pos = List.generate(_colors.length, (index) => index / _colors.length);
  }
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    final Paint paint = Paint()

      /// 绘画风格
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, _breatheAnima.value)
      ..shader = ui.Gradient.sweep(Offset.zero, _colors, _pos, TileMode.clamp, 0, 2 * pi);

    Path circlePath = Path()..addOval(Rect.fromCenter(center: const Offset(0, 0), width: 100, height: 100));
    Path circlePath2 = Path()..addOval(Rect.fromCenter(center: const Offset(-1, 0), width: 100, height: 100));
    Path result = Path.combine(PathOperation.difference, circlePath, circlePath2);
    canvas.drawPath(circlePath, paint);

    /// ????
    canvas.save();

    canvas.rotate(_rotateAnima.value);
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xff00abf2);
    paint.shader = null;
    canvas.drawPath(result, paint);

    /// ????
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CircleHaloPainter oldDelegate) => oldDelegate.animation != animation;
}
