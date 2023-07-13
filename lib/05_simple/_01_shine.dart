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
        child: CircleShineImage(
          color: Colors.pink,
          duration: Duration(milliseconds: 1000),
          curve: Curves.linear,
          image: NetworkImage(
              'https://p3-passport.byteimg.com/img/user-avatar/e69dd80881fb5aa67918a1e3cf6d519e~180x180.awebp'),
          radius: 20,
        ),
      ),
    );
  }
}

class CircleShineImage extends StatefulWidget {
  final double maxBlurRadius;
  final Color color;
  final Duration duration;
  final Curve curve;
  final ImageProvider image;
  final double radius;
  const CircleShineImage({
    this.maxBlurRadius = 10,
    required this.color,
    required this.duration,
    required this.curve,
    required this.image,
    required this.radius,
    super.key,
  });

  @override
  State<CircleShineImage> createState() => _CircleShineImageState();
}

class _CircleShineImageState extends State<CircleShineImage> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: widget.duration); // 声明：动画控制器
  late Animation<double> _blurRadiusAnim; // 声明：阴影半径动画器

  @override
  void initState() {
    _ctrl.addListener(_handleAnimationChanged);

    // 实例化:阴影半径动画器
    _blurRadiusAnim =
        Tween<double>(begin: 0, end: widget.maxBlurRadius).chain(CurveTween(curve: widget.curve)).animate(_ctrl);

    _ctrl.repeat(reverse: true);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CircleShineImage oldWidget) {
    _ctrl.duration = widget.duration;
    if (widget.curve != oldWidget.curve || widget.maxBlurRadius != oldWidget.maxBlurRadius) {
      _blurRadiusAnim =
          Tween<double>(begin: 0, end: widget.maxBlurRadius).chain(CurveTween(curve: widget.curve)).animate(_ctrl);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleAnimationChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.radius * 2,
      width: widget.radius * 2,
      decoration: BoxDecoration(
        image: DecorationImage(image: widget.image, fit: BoxFit.cover),
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: widget.color, blurRadius: _blurRadiusAnim.value, spreadRadius: 0)],
      ),
    );
  }
}
