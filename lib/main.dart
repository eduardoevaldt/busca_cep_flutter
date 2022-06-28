import 'package:flutter/material.dart';
import 'package:web_service/views/home_screen.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Web Service Cep',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
