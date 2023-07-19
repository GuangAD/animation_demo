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
        child: AnimText(''),
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
const _kAnimateDuration = Duration(milliseconds: 1000);

class AnimText extends StatefulWidget {
  final String text;
  final List<Color>? colors;
  final TextStyle? style;
  final Duration? duration;
  const AnimText(this.text, {this.colors, this.style, super.key, this.duration});

  @override
  State<AnimText> createState() => _AnimTextState();
}

class _AnimTextState extends State<AnimText> with SingleTickerProviderStateMixin {
  List<Color> get _colors => widget.colors ?? _kAnimTextColors;

  TextStyle get _style => widget.style ?? _kAnimTextStyle;

  List<double> get _pos => List.generate(_colors.length, (index) => (index + 1) / _colors.length);
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: widget.duration ?? _kAnimateDuration);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimText oldWidget) {
    if (widget.duration != oldWidget.duration) {
      _ctrl.duration = widget.duration ?? _kAnimateDuration;
    }
    super.didUpdateWidget(oldWidget);
  }

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
    paint.maskFilter = MaskFilter.blur(BlurStyle.solid, 15 * _ctrl.value);
    return paint;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startAnim,
      child: AnimatedBuilder(
        // 4.通过 AnimatedBuilder 监听动画器构建组件
        animation: _ctrl,
        builder: _buildByAnim,
      ),
    );
  }

  Widget _buildByAnim(BuildContext context, Widget? child) {
    return Text(
      widget.text,
      style: _style.copyWith(foreground: getPaint()),
    );
  }

  void _startAnim() {
    // 3. 启动动画器
    _ctrl.forward(from: 0);
  }
}
