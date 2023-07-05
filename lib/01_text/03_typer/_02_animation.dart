import 'dart:async';

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

  final String _text = '桃树、杏树、梨树，你不让我，我不让你，都开满了花赶趟儿。'
      '红的像火，粉的像霞，白的像雪。花里带着甜味，闭了眼，'
      '树上仿佛已经满是桃儿、杏儿、梨儿。';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextTyper(_text),
      ),
    );
  }
}

class TextTyper extends StatefulWidget {
  final String text;
  const TextTyper(this.text, {super.key});

  @override
  State<TextTyper> createState() => _TextTyperState();
}

class _TextTyperState extends State<TextTyper> with SingleTickerProviderStateMixin {
  final Duration _animDuration = const Duration(milliseconds: 200);

  late final String _text;

  final ValueNotifier<String> data = ValueNotifier<String>("");

  Timer? _timer;
  int currentIndex = 0;

  String get currentText => _text.substring(0, currentIndex);

  @override
  void initState() {
    super.initState();
    _text = widget.text;
    _startAnim();
  }

  @override
  void dispose() {
    _timer?.cancel();
    data.dispose();
    super.dispose();
  }

  void _startAnim() {
    _timer?.cancel();
    data.value = '';
    currentIndex = 0;
    _timer = Timer.periodic(_animDuration, _type);
  }

  void _type(Timer timer) {
    if (currentIndex < _text.length) {
      currentIndex++;
      data.value = currentText;
    } else {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startAnim,
      child: SizedBox(
        width: 300,
        child: AnimatedBuilder(
          animation: data,
          builder: _buildByAnim,
        ),
      ),
    );
  }

  Widget _buildByAnim(_, __) => Text(data.value, style: const TextStyle(color: Colors.blue));
}
