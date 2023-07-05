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
        child: AnimText(),
      ),
    );
  }
}

class AnimText extends StatelessWidget {
  const AnimText({super.key});

  final String _text = "张风捷特烈";

  final List<Color> _colors = const [
    Color(0xFFF60C0C),
    Color(0xFFF3B913),
    Color(0xFFE7F716),
    Color(0xFF3DF30B),
    Color(0xFF0DF6EF),
    Color(0xFF0829FB),
    Color(0xFFB709F4),
  ];

  final List<double> _pos = const [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];

  Paint getPaint() {
    Paint paint = Paint();

    /// 营造一种镂空字体的感觉
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    /// 着色器
    paint.shader = ui.Gradient.linear(
      const Offset(0, 0),
      const Offset(100, 0),
      _colors,
      _pos,
      TileMode.mirror,
      Matrix4.rotationZ(pi / 6).storage,
    );

    /// 遮罩过滤器
    paint.maskFilter = const MaskFilter.blur(BlurStyle.solid, 10);
    return paint;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(fontSize: 60, foreground: getPaint()),
    );
  }
}
