import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  // checks if device supports biometric authentication
  Future<bool> isAvailable() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  // prompts the user to authenticate using fingerprint
  // returns true if authentication succeeded
  // returns false if failed or cancelled
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Scan your fingerprint to access Bongkob',
        biometricOnly: true,
      );
    } catch (e) {
      return false;
    }
  }
}