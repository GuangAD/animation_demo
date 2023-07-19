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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AnimDemo(),
      ),
    );
  }
}

class AnimDemo extends StatefulWidget {
  const AnimDemo({super.key});

  @override
  State<AnimDemo> createState() => _AnimDemoState();
}

class _AnimDemoState extends State<AnimDemo> {
  final Decoration startDecoration = const BoxDecoration(
      color: Colors.deepPurple,
      borderRadius: BorderRadius.all(Radius.circular(30)),
      boxShadow: [BoxShadow(offset: Offset(1, 1), color: Colors.purple, blurRadius: 5, spreadRadius: 2)]);

  final Decoration endDecoration = const BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      boxShadow: [BoxShadow(offset: Offset(1, 1), color: Colors.blue, blurRadius: 10, spreadRadius: 0)]);

  final Alignment startAlignment = Alignment.topLeft + const Alignment(0.2, 0.2);
  final Alignment endAlignment = Alignment.center;

  final double startHeight = 150.0;
  final double endHeight = 100.0;

  late Decoration _decoration;
  late double _height;

  late Alignment _alignment;

  @override
  void initState() {
    super.initState();
    _decoration = startDecoration;
    _height = startHeight;
    _alignment = startAlignment;
  }

  bool get selected => _height == endHeight;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Switch(
          value: selected,
          onChanged: onChanged,
        ),
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          decoration: _decoration,
          alignment: _alignment,
          height: _height,
          width: _height,
          child: const Icon(
            Icons.camera_outlined,
            color: Colors.green,
            size: 25,
          ),
        ),
      ],
    );
  }

  void onChanged(bool value) {
    setState(() {
      _height = value ? endHeight : startHeight;
      _decoration = value ? endDecoration : startDecoration;
      _alignment = value ? endAlignment : startAlignment;
    });
  }
}
