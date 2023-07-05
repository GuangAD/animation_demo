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
      body: Center(
        child: SkewShadowText(),
      ),
    );
  }
}

class SkewShadowText extends StatelessWidget {
  SkewShadowText({super.key});

  final TextStyle _commonStyle = const TextStyle(fontSize: 60, color: Colors.blue);
  final TextStyle _shadowStyle = TextStyle(fontSize: 60, color: Colors.blue.withAlpha(88));
  final String _text = '张风捷特烈';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          _text,
          style: _commonStyle,
        ),
        Transform(
          transform: Matrix4.skewX(4 * pi / 180),
          child: Text(
            _text,
            style: _shadowStyle,
          ),
        ),
      ],
    );
  }
}
