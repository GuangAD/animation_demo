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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<double> _angle = ValueNotifier<double>(90);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ValueListenableBuilder(
            valueListenable: _angle,
            builder: (context, value, _) {
              return Center(
                child: Column(
                  children: [
                    Slider(
                      value: value,
                      min: 0,
                      max: 360,
                      onChanged: (v) {
                        _angle.value = v;
                      },
                    ),
                    ToggleRotate(
                      endAngle: value,
                      child: ClipOval(
                        child: Image.network(
                          'https://p3-passport.byteimg.com/img/user-avatar/e69dd80881fb5aa67918a1e3cf6d519e~180x180.awebp',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class ToggleRotate extends StatefulWidget {
  final Widget child;
  final ValueChanged<bool>? onEnd;
  final VoidCallback? onTap;
  final double beginAngle;
  final double endAngle;
  final Duration duration;

  /// 是否顺时针旋转
  final bool clockwise;
  final Curve curve;
  const ToggleRotate({
    super.key,
    required this.child,
    this.onEnd,
    this.onTap,
    this.beginAngle = 0,
    this.endAngle = 90,
    this.clockwise = true,
    this.curve = Curves.fastOutSlowIn,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<ToggleRotate> createState() => _ToggleRotateState();
}

class _ToggleRotateState extends State<ToggleRotate> with SingleTickerProviderStateMixin {
  bool _rotated = false; // 是否已旋转
  late AnimationController _controller = AnimationController(vsync: this, duration: _duration); // 是否动画控制器
  late Animation<double> _rotateAnim; // 旋转动画器

  Duration get _duration => widget.duration;
  @override
  void initState() {
    _initTweenAnim();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ToggleRotate oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller.dispose();
      _controller = AnimationController(duration: _duration, vsync: this);
    }

    if (widget.beginAngle != oldWidget.beginAngle ||
        widget.endAngle != oldWidget.endAngle ||
        widget.curve != oldWidget.curve ||
        widget.duration != oldWidget.duration) {
      _initTweenAnim();
    }
  }

  _initTweenAnim() {
    _rotateAnim = Tween<double>(begin: widget.beginAngle / 180 * pi, end: widget.endAngle / 180 * pi)
        .chain(CurveTween(curve: widget.curve))
        .animate(_controller);
  }

  double get rad => widget.clockwise ? _rotateAnim.value : -_rotateAnim.value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleRotate,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => Transform(
          transform: Matrix4.rotationZ(rad),
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }

  void _toggleRotate() async {
    widget.onTap?.call();
    if (_rotated) {
      await _controller.reverse();
    } else {
      await _controller.forward();
    }
    _rotated = !_rotated;
    widget.onEnd?.call(_rotated);
  }
}
