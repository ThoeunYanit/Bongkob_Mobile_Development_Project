import 'package:bongkob_project_v2/ui/screens/biometric_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const BongkobApp());
}

class BongkobApp extends StatelessWidget {
  const BongkobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // app starts on the fingerprint scan screen, not the main tabs
      home: BiometricScreen(),
      // home: MainScreen() // to skip Biometric
    );
  }
}