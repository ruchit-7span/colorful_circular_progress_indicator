import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to ColorfulCircularProgressIndicator'),
        ),
        body: const Center(
            child: ColorfulCircularProgressIndicator(
          colors: [Colors.blue, Colors.red, Colors.yellow, Colors.green],
          strokeWidth: 5,
          indicatorHeight: 40,
          indicatorWidth: 40,
        )),
      ),
    );
  }
}
