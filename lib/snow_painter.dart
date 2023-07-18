import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlue, Colors.white],
            stops: [0.1, 0.7, 0.95],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomPaint(
          painter: SnowPainter(_controller),
        ),
      ),
    );
  }
}

class SnowPainter extends CustomPainter {
  Animation ctrl;
  List<Snowflake>? _snowflakes;
  SnowPainter(this.ctrl) : super(repaint: ctrl) {
    print("object");
  }

  List<Snowflake> getSnowflakes(Size size) {
    return _snowflakes ??= List.generate(1000, (index) => Snowflake(width: size.width, height: size.height));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final snowflakes = getSnowflakes(size);
    Paint paint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(size.width / 2, size.height - 200), 60, paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(size.width / 2, size.height - 50), width: 200, height: 250), paint);
    snowflakes.forEach((element) {
      canvas.drawCircle(Offset(element.x, element.y), element.radius, paint);
      element.fall();
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Snowflake {
  final double height;
  final double width;
  late double x;
  late double y;
  double radius = Random().nextDouble() * 2 + 3;
  double velocity = Random().nextDouble() * 2 + 2;
  Snowflake({required this.width, required this.height}) {
    x = Random().nextDouble() * width;
    y = Random().nextDouble() * height;
  }

  fall() {
    y += velocity;
    if (y > height) {
      y = 0;
      x = Random().nextDouble() * width;
      radius = Random().nextDouble() * 2 + 3;
      velocity = Random().nextDouble() * 2 + 2;
    }
  }
}
