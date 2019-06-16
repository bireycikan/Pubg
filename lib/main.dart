import 'package:flutter/material.dart';
import 'screens/search_screen.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(Pubg());
  });
}

class Pubg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchPlayerScreen(),
    );
  }
}
