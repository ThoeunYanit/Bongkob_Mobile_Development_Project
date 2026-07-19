import 'package:flutter/material.dart';
import 'ui/screens/encode/encode_home_screen.dart';

void main() {
  runApp(const BongkobApp());
}

class BongkobApp extends StatelessWidget {
  const BongkobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EncodeHomeScreen(),
    );
  }
}