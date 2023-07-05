/// TweenSequence 继承自 Animatable ，其中维护了 TweenSequenceItem<T> 类型的列表。
/// 它的作用是：让多个同泛型的 Animatable 序列执行，
///

import 'package:exam/02/02_func/_00_anim_painter.dart';
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
  final PointData _points = PointData();

  late AnimationController _ctrl;

  final Duration _animDuration = const Duration(milliseconds: 1000);

  late Animation<double> _curveAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: _animDuration,
    )..addListener(_collectPoint);
    _curveAnim = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 0.5).chain(CurveTween(curve: Curves.ease)),
          weight: 20.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(0.5),
          weight: 20.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.5, end: 1.0).chain(CurveTween(curve: Curves.decelerate)),
          weight: 20.0,
        ),
      ],
    ).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _points.dispose();
    super.dispose();
  }

  void _collectPoint() {
    _points.push(_curveAnim.value);
  }

  void _startAnim() async {
    _points.clear();
    debugPrint('start!---${DateTime.now().toIso8601String()}----------');
    await _ctrl.forward(from: 0);
    debugPrint('done!---${DateTime.now().toIso8601String()}----------');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startAnim,
      child: CustomPaint(
        painter: AnimPainter(_points),
        size: const Size(
          200,
          200,
        ),
      ),
    );
  }
}
