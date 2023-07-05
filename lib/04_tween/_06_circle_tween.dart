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
        child: AnimPanel(),
      ),
    );
  }
}

/// Curve 类本身似乎并没有太关注。
/// 其实它本身非常简单，就是进行数值的 transform 变换而已
/// ```
/// @immutable
/// abstract class Curve extends ParametricCurve<double> {
///
///   const Curve();
///
///   @override
///   double transform(double t) {
///     if (t == 0.0 || t == 1.0) {
///       return t;
///     }
///     return super.transform(t);
///   }
///
///   Curve get flipped => FlippedCurve(this);
/// }
/// ```
/// 为了方便实用，Flutter 内置了 41 种常用的动画曲线静态常量，
/// 定义在 Curves 类中。这些 Curve 对象本质上都是通过 Curve
/// 的相关子类创建的。
///
///

class AnimPanel extends StatefulWidget {
  const AnimPanel({super.key});

  @override
  State<AnimPanel> createState() => _AnimPanelState();
}

class _AnimPanelState extends State<AnimPanel> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  final Duration _animDuration = const Duration(milliseconds: 1000);

  late Animation<Circle> _animation;

  final CircleTween _tween = CircleTween(
    begin: Circle(center: Offset.zero, radius: 25, color: Colors.blue),
    end: Circle(center: const Offset(100, 0), radius: 50, color: Colors.red),
  );

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: _animDuration,
    );
    _animation = _tween.animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();

    super.dispose();
  }

  void _startAnim() async {
    debugPrint('start!---${DateTime.now().toIso8601String()}----------');
    await _ctrl.forward(from: 0);
    debugPrint('done!---${DateTime.now().toIso8601String()}----------');
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

  Widget _buildByAnim(_, __) => CircleWidget(circle: _animation.value);
}

class Circle {
  final Color color;
  final double radius;
  final Offset center;

  Circle({required this.color, required this.radius, required this.center});
}

class CircleWidget extends StatelessWidget {
  final Circle circle;
  const CircleWidget({super.key, required this.circle});

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(circle.center.dx, circle.center.dy, 0),
      width: circle.radius * 2,
      height: circle.radius * 2,
      decoration: BoxDecoration(color: circle.color, shape: BoxShape.circle),
    );
  }
}

class CircleTween extends Tween<Circle> {
  CircleTween({required Circle begin, required Circle end}) : super(begin: begin, end: end);

  @override
  Circle lerp(double t) {
    return Circle(
      color: Color.lerp(begin!.color, end!.color, t)!,
      radius: (begin!.radius + (end!.radius - begin!.radius) * t),
      center: Offset.lerp(begin!.center, end!.center, t)!,
    );
  }
}
