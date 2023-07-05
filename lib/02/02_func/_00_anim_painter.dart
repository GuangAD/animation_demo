import 'dart:async';
import 'dart:ui';

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

class PointData extends ChangeNotifier {
  final List<double> values = [];

  void push(double value) {
    values.add(value);
    notifyListeners();
  }

  void clear() {
    values.clear();
    notifyListeners();
  }
}

class AnimPainter extends CustomPainter {
  final PointData points;

  ///坐标系
  Paint axisPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  /// 点
  Paint fpsPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.green;

  /// 文字
  TextPainter textPainter = TextPainter(textAlign: TextAlign.center, textDirection: TextDirection.ltr);

  AnimPainter(this.points) : super(repaint: points);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0, size.height);

    /// 标题
    textPainter.text = const TextSpan(
      text: '动画控制器数值散点图',
      style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
    );
    textPainter.layout(); // 进行布局
    Size textSize = textPainter.size; // 尺寸必须在布局后获取
    textPainter.paint(canvas, Offset(size.width / 2 - textSize.width / 2, -size.height - 30));

    _drawAxis(canvas, size);
    _drawScale(canvas, size);
    _drawPoint(points.values, canvas, size);

    /// 终点竖线
    Path fps_60 = Path();
    fps_60.moveTo(3.0 * 60, 0);
    fps_60.relativeLineTo(0, -size.height);
    canvas.drawPath(fps_60, fpsPaint);
    textPainter.text = const TextSpan(text: '60 帧', style: TextStyle(fontSize: 12, color: Colors.green));
    textPainter.layout(); // 进行布局
    textPainter.paint(canvas, Offset(3.0 * 61 + 5, -size.height));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  /// 坐标系单位
  void _drawAxis(Canvas canvas, Size size) {
    Path axisPath = Path();
    // 将一条直线段从当前点添加到与当前点的给定偏移处的点(根据偏移量，而不是坐标点)
    ///坐标系线段
    axisPath.relativeLineTo(size.width, 0); // 横坐标横线
    axisPath.relativeLineTo(-10, -4); // 横坐标横线上划线
    axisPath.moveTo(size.width, 0);
    axisPath.relativeLineTo(-10, 4); // 横坐标横线下划线
    axisPath.moveTo(0, 0);
    axisPath.relativeLineTo(0, -size.height); // 纵坐标竖线
    axisPath.relativeLineTo(-4, 10); // 纵坐标竖线左斜线
    axisPath.moveTo(0, -size.height);
    axisPath.relativeLineTo(4, 10); // 纵坐标竖线右斜线
    canvas.drawPath(axisPath, axisPaint);

    ///坐标系文字
    textPainter.text = const TextSpan(text: '帧数/f', style: TextStyle(fontSize: 12, color: Colors.black));
    textPainter.layout(); // 进行布局
    Size textSize = textPainter.size; // 尺寸必须在布局后获取
    textPainter.paint(canvas, Offset(size.width - textSize.width, 5));
    textPainter.text = const TextSpan(text: '数值/y', style: TextStyle(fontSize: 12, color: Colors.black));
    textPainter.layout(); // 进行布局
    Size textSize2 = textPainter.size; // 尺寸必须在布局后获取
    textPainter.paint(canvas, Offset(-textSize2.width - 10, -size.height - textSize2.height / 2));
  }

  /// 坐标系单位
  void _drawScale(Canvas canvas, Size size) {
    double step = size.height / 11;
    if (points.values.isNotEmpty) {
      canvas.drawLine(Offset(0, -points.values.last * step * 10), Offset(280, -points.values.last * step * 10),
          Paint()..color = Colors.purple);
      canvas.drawCircle(Offset(240, -points.values.last * step * 10), 10, Paint()..color = Colors.orange);
    }
    Path scalePath = Path();
    for (int i = 1; i <= 10; i++) {
      scalePath
        ..moveTo(0, -step * i)
        ..relativeLineTo(5, 0);

      textPainter.text = TextSpan(text: '${i / 10}', style: const TextStyle(fontSize: 12, color: Colors.black));

      textPainter.layout(); // 进行布局
      Size textSize = textPainter.size; // 尺寸必须在布局后获取
      textPainter.paint(canvas, Offset(-textSize.width - 5, -step * i - textSize.height / 2));
    }
    canvas.drawPath(scalePath, axisPaint);
  }

  void _drawPoint(List<double> values, Canvas canvas, Size size) {
    double stepY = size.height / 11;

    List<Offset> drawPoint = [];
    // print(values.length);

    for (int i = 0; i < values.length; i++) {
      drawPoint.add(Offset(3.0 * (i + 1), -values[i] * (size.height - stepY)));
    }

    canvas.drawPoints(
        PointMode.points,
        drawPoint,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.blue
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2);
  }
}

class AnimPanel extends StatefulWidget {
  const AnimPanel({super.key});
  @override
  State<AnimPanel> createState() => _AnimPanelState();
}

class _AnimPanelState extends State<AnimPanel> with SingleTickerProviderStateMixin {
  final PointData _points = PointData();

  late AnimationController _ctrl;

  final Duration _animDuration = const Duration(milliseconds: 1000);

  // Animation curve;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: _animDuration,
    )
      ..addListener(_collectPoint)
      ..addStatusListener(_listenStatus);
    // curve = CurvedAnimation(parent: _ctrl, curve: Curves.bounceOut);
  }

  _listenStatus(AnimationStatus status) {
    debugPrint(status.toString());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _points.dispose();
    super.dispose();
  }

  void _collectPoint() {
    _points.push(_ctrl.value);
  }

  Future<void> _animForward() async {
    _points.clear();
    debugPrint('start!---${DateTime.now().toIso8601String()}----------');
    await _ctrl.forward(from: 0);
    // await _ctrl.forward(from: 0.4);
    debugPrint('done!---${DateTime.now().toIso8601String()}----------');
  }

  Future<void> _animReverse() async {
    _points.clear();
    debugPrint('start!---${DateTime.now().toIso8601String()}----------');
    _ctrl.value = 1;
    await _ctrl.reverse();
    // await _ctrl.reverse(from: 1);
    debugPrint('done!---${DateTime.now().toIso8601String()}----------');
  }

  Future<void> _animRepeat() async {
    _points.clear();
    Timer(_animDuration, _stop);
    debugPrint('start!---${DateTime.now().toIso8601String()}----------');
    await _ctrl.repeat(
      // reverse: true,
      reverse: false,
      // min: 0,
      // max: 1,
      period: _animDuration ~/ 4,
    );
    debugPrint('done!---${DateTime.now().toIso8601String()}----------');
  }

  void _animReset() async {
    _points.clear();
    Timer(_animDuration, _stop);
    _ctrl.reset();
  }

  Future<void> _animStop() async {
    _points.clear();
    Timer((_animDuration ~/ 4) * 1.5, () {
      _ctrl.stop(
        // canceled: false,
        canceled: true,
      );
    });
    Timer(_animDuration * 3, () {
      _ctrl.reverse();
    });
    debugPrint('start!---${DateTime.now().toIso8601String()}----------');
    await _ctrl
        .repeat(
          reverse: true,
          // reverse: false,
          // min: 0,
          // max: 1,
          period: _animDuration ~/ 4,
        )
        .orCancel
        .then((value) {})
        // ??????????
        .onError((error, stackTrace) {
      debugPrint(error.toString());
    });
    debugPrint('done!---${DateTime.now().toIso8601String()}----------');
  }

  Future<void> _animFluing() async {
    _points.clear();
    _ctrl.value = 0;
    debugPrint('start!---${DateTime.now().toIso8601String()}----------');

    // /// case 1
    // await _ctrl.fling();

    // /// case 2 velocity值越大，初期速度越大
    // await _ctrl.fling(velocity: 3);
    // await _ctrl.fling(velocity: 13);

    /// case3
    /// ```
    /// class SpringDescription {
    ///   const SpringDescription({
    ///     required this.mass, // 质量
    ///     required this.stiffness, // 刚度
    ///     required this.damping, // 阻尼
    ///   });
    ///
    ///   SpringDescription.withDampingRatio({
    ///   required this.mass,
    ///   required this.stiffness,
    ///  double ratio = 1.0,
    /// }) : damping = ratio * 2.0 * math.sqrt(mass * stiffness);
    /// ```
    /// ratio增大说明阻尼增大，表现来看会用更长的时间达到终点，也就是运动时长会随着增加
    // _ctrl.fling(
    //     velocity: 10,
    //     springDescription: SpringDescription.withDampingRatio(
    //       mass: 1.0,
    //       stiffness: 500.0,
    //       ratio: 3.0,
    //     ));

    /// 刚性 stiffness 越大 ，就说明越难形变，对应表现是：会用更短的时间达到终点。
    // _ctrl.fling(
    //     velocity: 10,
    //     springDescription: SpringDescription.withDampingRatio(
    //       mass: 1.0,
    //       stiffness: 1000.0,
    //       ratio: 3.0,
    //     ));

    /// 质量 mass 越大 ，就说明惯性越大，对应表现是：会用更长的时间达到终点。
    _ctrl.fling(
        velocity: 10,
        springDescription: SpringDescription.withDampingRatio(
          mass: 5.0,
          stiffness: 1000.0,
          ratio: 3.0,
        ));
    debugPrint('done!---${DateTime.now().toIso8601String()}----------');
  }

  /// 仿真驱动动画
  Future<void> _animAnimateWith() async {
    _points.clear();
    _ctrl.value = 0;
    debugPrint('start!---${DateTime.now().toIso8601String()}----------');

    /// 入参为 Simulation，是用来表示仿真运动的
    /// repeat 开启周期性动画，本质上是通过 _RepeatingSimulation 这个仿真器实现的
    /// fling 方法，本质上是通过 SpringSimulation 这个仿真器实现的
    debugPrint('done!---${DateTime.now().toIso8601String()}----------');
  }

  /// 让动画器从当前值正向运动到指定的 target
  Future<void> _animAnimateTo() async {
    _points.clear();
    _ctrl.value = 0;
    debugPrint('start!---${DateTime.now().toIso8601String()}----------');

    debugPrint('done!---${DateTime.now().toIso8601String()}----------');
  }

  /// 让动画器从当前值反向运动到指定的 target
  Future<void> _animAnimateBack() async {
    _points.clear();
    _ctrl.value = 0;
    debugPrint('start!---${DateTime.now().toIso8601String()}----------');

    debugPrint('done!---${DateTime.now().toIso8601String()}----------');
  }

  /// 让动画器从当前值反向运动到指定的 target
  void _animDispose() {
    _points.clear();
    _ctrl.value = 0;
    debugPrint('start!---${DateTime.now().toIso8601String()}----------');

    /// 动画控制器内部维护了 _ticker 对象，其实动画的进行都是它的功劳，Animation 只是表层的一个封装。
    /// 在 dispose 中只是对 _ticker 对象进行销毁。
    debugPrint('done!---${DateTime.now().toIso8601String()}----------');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomPaint(
            painter: AnimPainter(_points),
            size: const Size(
              200,
              200,
            ),
          ),
          Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: _animForward, child: const Text('forward')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: _animReverse, child: const Text('reverse')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: _animRepeat, child: const Text('repeat')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: _animReset, child: const Text('reset')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: _animStop, child: const Text('stop')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: _animFluing, child: const Text('fling')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: _animAnimateWith, child: const Text('animateWith')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: _animAnimateTo, child: const Text('animateTo')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: _animAnimateBack, child: const Text('animateBack')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: _animDispose, child: const Text('dispose')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _stop() {
    _ctrl.stop();
  }
}
