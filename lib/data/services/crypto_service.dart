import 'package:encrypt/encrypt.dart' as enc;

class CryptoService {
  // appended inside the message before encrypting
  // used after decryption to confirm the password was correct
  static const String _endMarker = '<<<END>>>';

  // prepended to the full payload in plain text before hiding
  // used during decode to detect if the text was encoded by Bongkob
  static const String _header = 'BONGKOB_V1<<<PAYLOAD>>>';

  // fixed initialization vector for AES — must be exactly 16 characters
  // same value used in both encrypt and decrypt so they produce matching results
  static final enc.IV _iv = enc.IV.fromUtf8('bongkob_iv_16byt');

  // encrypts a message using AES-256 with the given password
  // password is padded or trimmed to exactly 32 chars to form the AES key
  // end marker is appended to message before encrypting
  // returns base64 encoded encrypted string
  String encrypt(String message, String password) {
    final key = enc.Key.fromUtf8(password.padRight(32).substring(0, 32));
    final encrypter = enc.Encrypter(enc.AES(key));
    return encrypter.encrypt(message + _endMarker, iv: _iv).base64;
  }

  // decrypts an AES-256 encrypted base64 string using the given password
  // returns the original message if password is correct and end marker is found
  // returns null if password is wrong or data is corrupted
  String? decrypt(String encrypted, String password) {
    try {
      final key = enc.Key.fromUtf8(password.padRight(32).substring(0, 32));
      final encrypter = enc.Encrypter(enc.AES(key));
      final decrypted = encrypter.decrypt64(encrypted, iv: _iv);
      if (!decrypted.contains(_endMarker)) return null;
      return decrypted.substring(0, decrypted.indexOf(_endMarker));
    } catch (e) {
      return null;
    }
  }

  // exposes the header so stegano services can prepend it to payloads
  String get header => _header;
}
