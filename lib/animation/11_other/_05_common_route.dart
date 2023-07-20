import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GreenPage(),
    );
  }
}

class GreenPage extends StatelessWidget {
  const GreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('GreenPage'),
        actions: [
          IconButton(
            onPressed: () => _toRed(context),
            icon: const Icon(Icons.navigate_next),
          )
        ],
      ),
    );
  }

  void _toRed(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(builder: (ctx) => const RedPage()),
    );
  }
}

class RedPage extends StatelessWidget {
  const RedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: const Text('RedPage'),
      ),
    );
  }
}
