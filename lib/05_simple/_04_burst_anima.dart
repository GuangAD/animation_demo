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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: BurstMenu(
          swapAngle: 140,
          startAngle: -250,
          // itemClickClose: false,
          center: const BurstItem(),
          menus: List.generate(8, (index) => const BurstItem()),
        ),
      ),
    );
  }
}

typedef BurstMenuItemClick = bool? Function(int index);

class BurstMenu extends StatefulWidget {
  final double swapAngle;
  final double startAngle;
  final List<Widget> menus;
  final Widget center;
  final bool itemClickClose;
  final BurstMenuItemClick? burstMenuItemClick;
  const BurstMenu({
    super.key,
    required this.center,
    required this.menus,
    this.swapAngle = 360,
    this.startAngle = -90,
    this.burstMenuItemClick,
    this.itemClickClose = true,
  });

  @override
  State<BurstMenu> createState() => _BurstMenuState();
}

class _BurstMenuState extends State<BurstMenu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // 是否已关闭
  bool _closed = true;

  Future<void> toggle() async {
    if (_closed) {
      await _controller.forward();
    } else {
      await _controller.reverse();
    }
    _closed = !_closed;
  }

  void _handleItemClick(int index) {
    if (_closed) return;
    if (widget.burstMenuItemClick == null) {
      if (widget.itemClickClose) {
        toggle();
        return;
      }
    } else {
      bool? close = widget.burstMenuItemClick!.call(index);
      if (close == null && widget.itemClickClose) toggle();
      if (close != null && close) toggle();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: _CircleFlowDelegate(
        _controller,
        swapAngle: widget.swapAngle,
        startAngle: widget.startAngle,
      ),
      children: [
        ...widget.menus.asMap().keys.map((index) => GestureDetector(
              onTap: () {
                _handleItemClick(index);
              },
              child: widget.menus[index],
            )),
        GestureDetector(
          onTap: toggle,
          child: widget.center,
        ),
      ],
    );
  }
}

class _CircleFlowDelegate extends FlowDelegate {
  final double swapAngle;
  final double startAngle;
  final Animation<double> animation;

  _CircleFlowDelegate(
    this.animation, {
    this.swapAngle = 360,
    this.startAngle = -90,
  }) : super(repaint: animation);
  //绘制孩子的方法
  @override
  void paintChildren(FlowPaintingContext context) {
    double radius = context.size.shortestSide / 2;
    final int count = context.childCount - 1;

    /// 弧长等于半径的弧，其所对的圆心角为1弧度
    /// 一个圆的弧度为2pi
    /// 每一个的弧度
    final double perRad = swapAngle / 180 * pi / (count - 1);
    if (animation.value > 0.1) {
      for (int i = 0; i < count; i++) {
        final double cSizeX = context.getChildSize(i)?.width ?? 0 / 2;
        final double cSizeY = context.getChildSize(i)?.height ?? 0 / 2;
        final double offsetX = animation.value * (radius - cSizeX) * cos(i * perRad + startAngle / 180 * pi) + radius;
        final double offsetY = animation.value * (radius - cSizeY) * sin(i * perRad + startAngle / 180 * pi) + radius;

        context.paintChild(
          i,
          transform: Matrix4.translationValues(
            offsetX - cSizeX,
            offsetY - cSizeY,
            0.0,
          ),
          opacity: animation.value,
        );
      }
    }

    context.paintChild(
      context.childCount - 1,
      transform: Matrix4.translationValues(
        radius - (context.getChildSize(context.childCount - 1)?.width ?? 0 / 2),
        radius - (context.getChildSize(context.childCount - 1)?.height ?? 0 / 2),
        0.0,
      ),
    );
  }

  @override
  bool shouldRepaint(_CircleFlowDelegate oldDelegate) =>
      swapAngle != oldDelegate.swapAngle || startAngle != oldDelegate.startAngle;
}

class BurstItem extends StatelessWidget {
  const BurstItem({super.key});

  Color randomColor() =>
      Color.fromARGB(255, Random().nextInt(256) + 0, Random().nextInt(256) + 0, Random().nextInt(256) + 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.5),
        color: randomColor(),
      ),
    );
  }
}
