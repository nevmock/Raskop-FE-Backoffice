import 'package:flutter/material.dart';

/// Template Home Page [REPLACE WITH OFFICIAL DESIGN FROM MAS ZIYAD]
class MyHomePage extends StatefulWidget {
  /// Home Page constructor
  const MyHomePage({required this.title, super.key});

  ///
  static const String route = 'home';

  ///
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome To Rasa Kopi - BackOffice',
            ),
          ],
        ),
      ),
    );
  }
}
