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
        child: SkewShadowText('一二三四五六七八九十'),
      ),
    );
  }
}

const _kAnimateDuration = Duration(milliseconds: 1000);

class SkewShadowText extends StatefulWidget {
  final String text;
  final Duration? duration;
  const SkewShadowText(this.text, {this.duration, super.key});

  @override
  State<SkewShadowText> createState() => _SkewShadowTextState();
}

class _SkewShadowTextState extends State<SkewShadowText> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: widget.duration ?? _kAnimateDuration);

  final TextStyle _commonStyle = const TextStyle(fontSize: 60, color: Colors.blue);

  final TextStyle _shadowStyle = TextStyle(fontSize: 60, color: Colors.blue.withAlpha(88));

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
  void didUpdateWidget(covariant SkewShadowText oldWidget) {
    if (widget.duration != oldWidget.duration) {
      _ctrl.duration = widget.duration ?? _kAnimateDuration;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startAnim,
      child: Stack(
        children: [
          Text(
            widget.text,
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

  Widget _buildByAnim(_, __) => Transform(transform: Matrix4.skewX(rad), child: Text(widget.text, style: _shadowStyle));

  void _startAnim() {
    _ctrl.forward(from: 0);
  }
}
