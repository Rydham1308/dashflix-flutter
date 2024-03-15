import 'package:dashflix/screens/home_screen_module/screen/home_screen.dart';
import 'package:flutter/material.dart';

import 'helper/injections.dart';

void main() {
  initializeSingletons();

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen.create(),
    );
  }
}
