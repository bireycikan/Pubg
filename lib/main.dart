import 'package:flutter/material.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(Pubg());
}

class Pubg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchPlayerScreen(),
    );
  }
}
