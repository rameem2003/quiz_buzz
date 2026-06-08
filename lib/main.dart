import 'package:flutter/material.dart';
import 'package:quiz_buzz/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Scaffold(
        // appBar: AppBar(title: const Text('Flutter Demo Home Page')),
        body: const splashScreen(),
      ),
    );
  }
}
