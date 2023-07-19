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
  final Duration _animDuration = const Duration(milliseconds: 1000);

  @override
  void initState() {
    _ctrl = AnimationController(
      vsync: this,
      duration: _animDuration,
    );
    super.initState();
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
        ));
  }

  // 获取颜色
  // Color? get color => Color.lerp(Colors.blue, Colors.red, _ctrl.value);

  /// Tween 其实也可以脱离动画来使用，它的价值是：计算出起始对象和结束对象间位于某分率的对象。
  /// 动画只是获取分率的一种场景，
  /// 但并非唯一场景，比如滑页中的进度也是分率，也可以使用 ColorTween 来处理滑动中的颜色渐变。
  final ColorTween tween = ColorTween(begin: Colors.blue, end: Colors.red);

  Color? get color => tween.transform(_ctrl.value);

  Widget _buildByAnim(_, __) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  void _startAnim() {
    _ctrl.forward(from: 0);
  }
}
