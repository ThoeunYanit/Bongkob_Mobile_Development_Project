
import 'package:bongkob_project_v2/ui/screens/main_screen.dart';
import 'package:flutter/material.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreen();
}

class _BiometricScreen extends State<BiometricScreen> {
  bool isAuthenticating = false;

  static const backgroundColor = Color(0xFFF7F1E3);
  static const textColor = Color(0xFF2B2620);
  static const mutedColor = Color(0xFF9C9683);

  void scan() {
    setState(() {
      isAuthenticating = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isAuthenticating = false;
      });
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lock  screen icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: textColor, width: 1.5),
              ),
              child: const Icon(Icons.lock_outline, color: textColor),
            ),
            SizedBox(height: 20),
            Text(
              "Hello this is Bongkob app",
              style: TextStyle(color: mutedColor, fontSize: 14, height: 1.4),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 56),
            // Scan thumb
            GestureDetector(
              onTap: scan,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: mutedColor, width: 1),
                ),
                child: Center(
                  child: isAuthenticating
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: mutedColor),
                        )
                      : const Icon(
                          Icons.fingerprint,
                          color: mutedColor,
                          size: 30,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Place a finger on sensor",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: mutedColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
