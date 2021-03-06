import 'package:flutter/material.dart';
import 'top_screen.dart';
import 'bloc_provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: BlocProvider(child: TopScreenPage()),
    );

  }
}
