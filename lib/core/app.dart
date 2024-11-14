import 'package:flutter/material.dart';

/// RasKop BackOffice App
class RasKopBackOfficeApp extends StatelessWidget {
  /// RasKop BackOffice Key Constructor
  const RasKopBackOfficeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade300),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'RasKop - FE - BackOffice'),
    );
  }
}

/// Template Home Page
class MyHomePage extends StatefulWidget {
  /// Home Page constructor
  const MyHomePage({required this.title, super.key});

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
