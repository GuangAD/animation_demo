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
  final TextStyle startStyle = const TextStyle(
      color: Colors.white, fontSize: 50, shadows: [Shadow(offset: Offset(1, 1), color: Colors.black, blurRadius: 3)]);
  final TextStyle endStyle = const TextStyle(
      color: Colors.white, fontSize: 20, shadows: [Shadow(offset: Offset(1, 1), color: Colors.purple, blurRadius: 3)]);

  late TextStyle _style;

  @override
  void initState() {
    super.initState();
    _style = startStyle;
  }

  bool get selected => _style == endStyle;

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
        AnimatedDefaultTextStyle(
          textAlign: TextAlign.start,
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          style: _style,
          child: const Text('天地玄黄'),
        ),
      ],
    );
  }

  void onChanged(bool value) {
    setState(() {
      _style = value ? endStyle : startStyle;
    });
  }
}
