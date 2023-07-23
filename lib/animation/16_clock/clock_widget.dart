import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClockWidget extends StatefulWidget {
  final double radius;
  const ClockWidget({
    super.key,
    this.radius = 120,
  });

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final ValueNotifier<DateTime> _time = ValueNotifier<DateTime>(DateTime.now());
  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _time.dispose();
    super.dispose();
  }

  void _tick(Duration duration) {
    if (_time.value.second != DateTime.now().second) {
      _time.value = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.radius * 2, widget.radius * 2),
      foregroundPainter: ClockPointPainter(radius: widget.radius, listenable: _time),
      painter: ClockDialPainter(radius: widget.radius),
    );
  }
}

mixin ClockPainterRadiusMixin {
  double get _radius;

  double get logic1 => _radius * 0.01;
}

class ClockDialPainter extends CustomPainter with ClockPainterRadiusMixin {
  final double radius;
  ClockDialPainter({required this.radius});

  @override
  double get _radius => radius;

  double get scaleSpace => logic1 * 11; // 刻度与外圈的间隔
  double get shortScaleLen => logic1 * 7; // 短刻度线长
  double get shortLenWidth => logic1; // 短刻度线长
  double get longScaleLen => logic1 * 11; // 长刻度线长
  double get longLineWidth => logic1 * 2; // 长刻度线宽

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    drawOuterCircle(canvas);
    drawScale(canvas);
    drawText(canvas);
  }

  void drawOuterCircle(Canvas canvas) {
    Paint paint = Paint()
      ..strokeWidth = logic1 * 1.3
      ..style = PaintingStyle.stroke
      ..color = const Color(0xff00abf2);
    for (int i = 0; i < 4; i++) {
      _paintArc(paint, canvas);
      canvas.rotate(pi / 2);
    }
  }

  void _paintArc(Paint paint, Canvas canvas) {
    paint.maskFilter = MaskFilter.blur(BlurStyle.solid, logic1);
    final Path circlePath = Path()
      ..addArc(
        Rect.fromCenter(center: Offset.zero, width: radius * 2, height: radius * 2),
        10 / 180 * pi,
        pi / 2 - 20 / 180 * pi,
      );
    canvas.drawPath(circlePath, paint); //绘制
  }

  void drawScale(Canvas canvas) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;
    double count = 60;
    double perAngle = 2 * pi / count;
    for (int i = 0; i < count; i++) {
      if (i % 5 == 0) {
        paint
          ..strokeWidth = longLineWidth
          ..color = Colors.blue;
        canvas.drawLine(Offset(radius - scaleSpace, 0), Offset(radius - scaleSpace - longScaleLen, 0), paint);
        canvas.drawCircle(
            Offset(radius - scaleSpace - longScaleLen - logic1 * 5, 0), longLineWidth, paint..color = Colors.orange);
      } else {
        paint
          ..strokeWidth = shortLenWidth
          ..color = Colors.black;
        canvas.drawLine(Offset(radius - scaleSpace, 0), Offset(radius - scaleSpace - shortScaleLen, 0), paint);
      }
      canvas.rotate(perAngle);
    }
  }

  void drawText(Canvas canvas) {
    final TextPainter textPainter = TextPainter(textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    _drawCircleText(textPainter, canvas, 'Ⅸ', offsetX: -radius);
    _drawCircleText(textPainter, canvas, 'Ⅲ', offsetX: radius);
    _drawCircleText(textPainter, canvas, 'Ⅵ', offsetY: radius);
    _drawCircleText(textPainter, canvas, 'Ⅻ', offsetY: -radius);
    _drawLogoText(textPainter, canvas, offsetY: -radius * 0.5);
  }

  _drawCircleText(TextPainter textPainter, Canvas canvas, String text, {double offsetX = 0, double offsetY = 0}) {
    textPainter.text = TextSpan(text: text, style: TextStyle(fontSize: radius * 0.15, color: Colors.blue));
    textPainter.layout();
    textPainter.paint(
        canvas, Offset.zero.translate(-textPainter.size.width / 2 + offsetX, -textPainter.height / 2 + offsetY));
  }

  _drawLogoText(TextPainter textPainter, Canvas canvas, {double offsetX = 0, double offsetY = 0}) {
    textPainter.text =
        TextSpan(text: 'Toly', style: TextStyle(fontSize: radius * 0.2, color: Colors.blue, fontFamily: 'CHOPS'));
    textPainter.layout();
    textPainter.paint(
        canvas, Offset.zero.translate(-textPainter.size.width / 2 + offsetX, -textPainter.height / 2 + offsetY));
  }

  @override
  bool shouldRepaint(covariant ClockDialPainter oldDelegate) => oldDelegate.radius != radius;
}

class ClockPointPainter extends CustomPainter with ClockPainterRadiusMixin {
  final double radius;
  final ValueListenable<DateTime> listenable;
  ClockPointPainter({required this.radius, required this.listenable}) : super(repaint: listenable);

  @override
  double get _radius => radius;
  double get minusLen => logic1 * 60; // 分针长
  double get hourLen => logic1 * 45; // 时针长
  double get secondLen => logic1 * 68; // 秒针长
  double get hourLineWidth => logic1 * 3; // 时针线宽
  double get minusLineWidth => logic1 * 2; // 分针线宽
  double get secondLineWidth => logic1; // 秒针线宽
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    drawArrow(canvas, listenable.value);
  }

  void drawArrow(Canvas canvas, DateTime time) {
    int sec = time.second;
    int min = time.minute;
    int hour = time.hour;

    double perAngle = 360 / 60;
    double secondRad = (sec * perAngle) / 180 * pi;
    double minusRad = ((min + sec / 60) * perAngle) / 180 * pi;
    double hourRad = ((hour + min / 60 + sec / 3600) * perAngle * 5) / 180 * pi;

    canvas.save();
    canvas.rotate(-pi / 2); // tag1: 将初始角度转到 0 刻度。

    canvas.save();
    canvas.rotate(minusRad);
    drawMinus(canvas);
    canvas.restore();

    canvas.save();
    canvas.rotate(hourRad);
    drawHour(canvas);
    canvas.restore();

    canvas.save();
    canvas.rotate(secondRad);
    drawSecond(canvas);
    canvas.restore();

    canvas.restore();
  }

  void drawHour(Canvas canvas) {
    Paint paint = Paint()
      ..strokeWidth = hourLineWidth
      ..color = const Color(0xff8FC552)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, Offset(hourLen, 0), paint);
  }

  void drawMinus(Canvas canvas) {
    Paint paint = Paint()
      ..strokeWidth = minusLineWidth
      ..color = const Color(0xff87B953)
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
        Offset.zero,
        Offset(
          minusLen,
          0,
        ),
        paint);
  }

  void drawSecond(Canvas canvas) {
    Paint paint = Paint()
      ..strokeWidth = logic1 * 2.5
      ..color = const Color(0xff6B6B6B)
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;
    Path path = Path();

    canvas.save();
    canvas.rotate((360 - 270) / 2 / 180 * pi);
    path.addArc(Rect.fromPoints(Offset(-logic1 * 9, -logic1 * 9), Offset(logic1 * 9, logic1 * 9)), 0, 270 / 180 * pi);
    canvas.drawPath(path, paint);
    canvas.restore();

    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(-logic1 * 9, 0), Offset(-logic1 * 20, 0), paint);

    paint
      ..strokeWidth = logic1
      ..color = Colors.black;
    canvas.drawLine(Offset.zero, Offset(secondLen, 0), paint);

    paint
      ..strokeWidth = logic1 * 3
      ..color = const Color(0xff6B6B6B);
    canvas.drawCircle(Offset.zero, logic1 * 5, paint);

    paint
      ..color = const Color(0xff8FC552)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, logic1 * 4, paint);
  }

  @override
  bool shouldRepaint(covariant ClockDialPainter oldDelegate) => oldDelegate.radius != radius;
}
