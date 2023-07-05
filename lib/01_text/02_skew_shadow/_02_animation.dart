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
        child: SkewShadowText(),
      ),
    );
  }
}

class SkewShadowText extends StatefulWidget {
  const SkewShadowText({super.key});

  @override
  State<SkewShadowText> createState() => _SkewShadowTextState();
}

class _SkewShadowTextState extends State<SkewShadowText> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  final Duration animDuration = const Duration(milliseconds: 800);
  final TextStyle _commonStyle = const TextStyle(fontSize: 60, color: Colors.blue);

  final TextStyle _shadowStyle = TextStyle(fontSize: 60, color: Colors.blue.withAlpha(88));

  final String _text = '张风捷特烈';

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: animDuration);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startAnim,
      child: Stack(
        children: [
          Text(
            _text,
            style: _commonStyle,
          ),
          AnimatedBuilder(
            animation: _ctrl,
            builder: _buildByAnim,
          ),
        ],
      ),
    );
  }

  double get rad => 6 * (_ctrl.value) / 180 * pi;

  Widget _buildByAnim(_, __) => Transform(transform: Matrix4.skewX(rad), child: Text(_text, style: _shadowStyle));

  void _startAnim() {
    _ctrl.forward(from: 0);
  }
}
