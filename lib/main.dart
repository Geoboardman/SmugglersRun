import 'package:flutter/material.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(SmugglersRunApp());
}

class SmugglersRunApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smuggler's Run",
      theme: ThemeData.dark(),
      home: MapScreen(),
    );
  }
}
