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
        child: CircleAnim(),
      ),
    );
  }
}

class CircleAnim extends StatefulWidget {
  const CircleAnim({super.key});

  @override
  State<CircleAnim> createState() => _CircleAnimState();
}

class _CircleAnimState extends State<CircleAnim> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final Duration _animDuration = const Duration(milliseconds: 2000);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      lowerBound: 32,
      upperBound: 80,
      vsync: this,
      duration: _animDuration,
    );
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
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: _buildByAnim,
      ),
    );
  }

  double get radius => _ctrl.value;

  Widget _buildByAnim(_, __) => Container(
        width: radius * 2,
        height: radius * 2,
        decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
      );

  void _startAnim() {
    _ctrl.forward();
  }
}
