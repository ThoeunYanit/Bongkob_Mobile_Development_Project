// import 'package:bongkob_project_v2/ui/screens/main_screen.dart';
// import 'package:flutter/material.dart';

// class BiometricScreen extends StatefulWidget {
//   const BiometricScreen({super.key});

//   @override
//   State<BiometricScreen> createState() => _BiometricScreen();
// }

// class _BiometricScreen extends State<BiometricScreen> {
//   bool isAuthenticating = false;

//   static const backgroundColor = Color(0xFFF7F1E3);
//   static const textColor = Color(0xFF2B2620);
//   static const mutedColor = Color(0xFF9C9683);

//   void scan() {
//     setState(() {
//       isAuthenticating = true;
//     });

//     Future.delayed(const Duration(seconds: 1), () {
//       setState(() {
//         isAuthenticating = false;
//       });
//     });
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const MainScreen()),
//     );
//   }

//   @override
//   Widget build(Object context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 32),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Lock  screen icon
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: textColor, width: 1.5),
//               ),
//               child: const Icon(Icons.lock_outline, color: textColor),
//             ),
//             SizedBox(height: 20),
//             Text(
//               "Hello this is Bongkob app",
//               style: TextStyle(color: mutedColor, fontSize: 14, height: 1.4),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 56),
//             // Scan thumb
//             GestureDetector(
//               onTap: scan,
//               child: Container(
//                 width: 70,
//                 height: 70,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: mutedColor, width: 1),
//                 ),
//                 child: Center(
//                   child: isAuthenticating
//                       ? const SizedBox(
//                           width: 22,
//                           height: 22,
//                           child: CircularProgressIndicator(color: mutedColor),
//                         )
//                       : const Icon(
//                           Icons.fingerprint,
//                           color: mutedColor,
//                           size: 30,
//                         ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               "Place a finger on sensor",
//               style: TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 1.5,
//                 color: mutedColor,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../data/services/biometric_service.dart';
import '../../theme/app_theme.dart';
import 'main_screen.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  final biometric = BiometricService();

  bool isAuthenticating = false;
  String? errorMessage;

  // unique dark brown 
  static const textColor = Color(0xFF2B2620);

  // called when user taps fingerprint icon
  // triggers real biometric authentication
  void scan() async {
    setState(() {
      isAuthenticating = true;
      errorMessage = null;
    });

    final success = await biometric.authenticate();

    setState(() => isAuthenticating = false);

    if (success) {
      // replace lock screen with main screen
      // pushReplacement so user cannot go back to lock screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      setState(() => errorMessage = 'Authentication failed. Try again.');
    }
  }

  @override
  void initState() {
    super.initState();
    // auto trigger biometric when screen opens
    scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── LOCK ICON ──
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: textColor, width: 1.5),
                ),
                child: const Icon(Icons.lock_outline, color: textColor),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bongkob',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Scan your fingerprint to continue',
              style: TextStyle(
                color: AppTheme.labelColor,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 56),

            // ── FINGERPRINT BUTTON ──
            Center(
              child: GestureDetector(
                onTap: isAuthenticating ? null : scan,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.labelColor, width: 1),
                  ),
                  child: Center(
                    child: isAuthenticating
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: AppTheme.labelColor,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.fingerprint,
                            color: AppTheme.labelColor,
                            size: 30,
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'PLACE A FINGER ON SENSOR',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: AppTheme.labelColor,
              ),
              textAlign: TextAlign.center,
            ),

            // ── ERROR ──
            if (errorMessage != null) ...[
              const SizedBox(height: 24),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: scan,
                child: const Text(
                  'Try again',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
