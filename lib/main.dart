import 'package:app/main_page.dart';
import 'package:flutter/material.dart';
import 'theme/custom_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECOMMERCE',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme,
      home: const MyMain(),
    );
  }
}