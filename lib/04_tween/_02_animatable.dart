/// Animatable 和 Animation 是两个名字比较像，不要搞混了。
/// Animatable 是抽象类，且可以指定一个泛型 T ，只有一个抽象方法 transform ，
/// 它的作用是通过 分率 t 创建 T 类型对象。
///
///
///
/// evaluate : 入参是 Animation<double> 对象，能通过 transform 计算 动画器 当前值返回 T 类型对象。
/// T evaluate(Animation<double> animation) => transform(animation.value);
/// Color get color => tween.transform(_ctrl.value);
/// Color get color => tween.evaluate(_ctrl); // 等价于上行
///
///
///
///
/// animate : 入参是 Animation<double> 对象，作用是通过传入的 动画器 对象，返回一个 T 泛型的动画器 对象。
/// Animation<T> animate(Animation<double> parent) {
///   return _AnimatedEvaluation<T>(parent, this);
/// }
/// 这个方法比较像 CurvedAnimation 通过 动画器 和 Curve 创建新动画器。
/// 它是通过 Animation 和 动画器创建新动画器，使用代码如下
///
///
///chain : 入参是 Animatable<double> 对象，作用是通过传入的 Animatable 对象，
///返回一个 T 泛型的Animatable 对象。代码中返回的实现类是 _ChainedEvaluation。
/// Animatable<T> chain(Animatable<double> parent) {
///    return _ChainedEvaluation<T>(parent, this);
/// }
///CurveTween 继承自 Animatable<double> ，所以可以作为 chain 的入参，
///这样就能让 Animatable 对象在 transform 时具有曲线效果。
///也就是说，chain 可以让当前 Animatable 对象执行变换前，先执行一个其他 double 型的变换。
///
///最核心的就是 transform 抽象方法，它的作用是通过 分率 t 创建 T 类型对象。
///其他的三个方法都是依赖 transform 方法实现的，属于锦上添花。
///
///

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
      body: const SingleChildScrollView(
        child: Column(
          children: [
            CircleAnimEvaluate(),
            SizedBox(height: 20),
            CircleAnimAnimate(),
          ],
        ),
      ),
    );
  }
}

class CircleAnimEvaluate extends StatefulWidget {
  const CircleAnimEvaluate({super.key});

  @override
  State<CircleAnimEvaluate> createState() => _CircleAnimEvaluateState();
}

class _CircleAnimEvaluateState extends State<CircleAnimEvaluate> with SingleTickerProviderStateMixin {
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
  final ColorTween tween = ColorTween(begin: Colors.blue, end: Colors.red);

  Color? get color => tween.evaluate(_ctrl);

  Widget _buildByAnim(_, __) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  void _startAnim() {
    _ctrl.forward(from: 0);
  }
}

class CircleAnimAnimate extends StatefulWidget {
  const CircleAnimAnimate({super.key});

  @override
  State<CircleAnimAnimate> createState() => _CircleAnimAnimateState();
}

class _CircleAnimAnimateState extends State<CircleAnimAnimate> with SingleTickerProviderStateMixin {
  late Animation<Color?> _colorAnima;
  late AnimationController _ctrl;
  final Duration _animDuration = const Duration(milliseconds: 1000);
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: _animDuration,
    );
    // 2.创建 ColorTween 对象
    final ColorTween tween = ColorTween(begin: Colors.blue, end: Colors.red);
    // 3. 通过 animate 方法创建新动画器
    _colorAnima = tween.animate(_ctrl);
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

  Color? get color => _colorAnima.value;

  Widget _buildByAnim(_, __) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  void _startAnim() {
    _ctrl.forward(from: 0);
  }
}
