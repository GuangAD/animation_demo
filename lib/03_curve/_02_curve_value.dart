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
    // CurvedAnimation 并不能启动动画，它很好地体现了: 我不创造数值，我只是数值的计算器。
    // 这样它必须要依附于别的动画器才能工作，也就是 parent 属性
    // _curveAnim = CurvedAnimation(parent: _ctrl, curve: Curves.bounceOut);
    // _curveAnim = CurvedAnimation(parent: _ctrl, curve: Curves.ease);
    // _curveAnim = CurvedAnimation(parent: _ctrl, curve: Curves.decelerate);
    // _curveAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _curveAnim = CurvedAnimation(parent: _ctrl, curve: const SawTooth(3));
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
