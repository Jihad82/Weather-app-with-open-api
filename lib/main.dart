import 'package:flutter/material.dart';
import 'View/main_screen.dart';

const String baseUrl = "http://api.weatherapi.com/v1/forecast.json?key=3385ff506c1b450182c152917242509";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

