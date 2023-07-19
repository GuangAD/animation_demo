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
        child: AnimText('一二三四五六七八九十'),
      ),
    );
  }
}

const _kAnimTextColors = [
  Color(0xFFF60C0C),
  Color(0xFFF3B913),
  Color(0xFFE7F716),
  Color(0xFF3DF30B),
  Color(0xFF0DF6EF),
  Color(0xFF0829FB),
  Color(0xFFB709F4)
];

const _kAnimTextStyle = TextStyle(fontSize: 18);

class AnimText extends StatelessWidget {
  final String text;
  final List<Color>? colors;
  final TextStyle? style;
  const AnimText(this.text, {this.colors, this.style, super.key});

  List<Color> get _colors => colors ?? _kAnimTextColors;

  TextStyle get _style => style ?? _kAnimTextStyle;

  List<double> get _pos => List.generate(_colors.length, (index) => (index + 1) / _colors.length);

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
      text,
      style: _style.copyWith(foreground: getPaint()),
    );
  }
}
