import '../../models/stegano_result.dart';
import 'crypto_service.dart';

class TextSteganoService {
  final CryptoService _crypto = CryptoService();

  // U+200B zero-width space — represents bit 0
  static const String _bit0 = '\u200B';

  // U+200C zero-width non-joiner — represents bit 1
  static const String _bit1 = '\u200C';

  // hides secret message inside cover text using zero-width invisible chars
  // step 1 — validates all inputs
  // step 2 — encrypts message using AES-256
  // step 3 — prepends header to encrypted result
  // step 4 — converts full payload to binary bits
  // step 5 — auto pads cover text by repeating it if too short
  // step 6 — inserts invisible chars between words to carry the bits
  // returns TextEncodeResult with encodedText on success or error on failure
  TextEncodeResult encode({
    required String message,
    required String coverText,
    required String password,
  }) {
    if (message.isEmpty) {
      return TextEncodeResult(success: false, error: 'Message cannot be empty');
    }
    if (coverText.isEmpty) {
      return TextEncodeResult(
        success: false,
        error: 'Cover text cannot be empty',
      );
    }
    if (password.isEmpty) {
      return TextEncodeResult(
        success: false,
        error: 'Password cannot be empty',
      );
    }

    final encrypted = _crypto.encrypt(message, password);
    final payload = _crypto.header + encrypted;
    final bits = _toBits(payload);
    final paddedCover = _padCoverText(coverText, bits.length);
    final words = paddedCover.split(' ');

    final buffer = StringBuffer();
    for (int i = 0; i < words.length; i++) {
      buffer.write(words[i]);
      if (i < bits.length) {
        buffer.write(bits[i] == 0 ? _bit0 : _bit1);
      } else if (i < words.length - 1) {
        buffer.write(' ');
      }
    }

    return TextEncodeResult(success: true, encodedText: buffer.toString());
  }

  // extracts hidden message from encoded text using password
  // step 1 — validates inputs
  // step 2 — scans text for invisible zero-width chars and collects bits
  // step 3 — converts bits back to string
  // step 4 — checks for header to confirm text was encoded by Bongkob
  // step 5 — strips header and decrypts remaining payload
  // step 6 — end marker inside decrypted result confirms correct password
  // returns TextDecodeResult with message on success or error on failure
  TextDecodeResult decode({
    required String encodedText,
    required String password,
  }) {
    if (encodedText.isEmpty) {
      return TextDecodeResult(
        success: false,
        error: 'Please paste the encoded text',
      );
    }
    if (password.isEmpty) {
      return TextDecodeResult(
        success: false,
        error: 'Password cannot be empty',
      );
    }

    final List<int> bits = [];
    for (int i = 0; i < encodedText.length; i++) {
      if (encodedText[i] == _bit0) bits.add(0);
      if (encodedText[i] == _bit1) bits.add(1);
    }

    if (bits.isEmpty) {
      return TextDecodeResult(
        success: false,
        error: 'No hidden data found in this text',
      );
    }

    final extracted = _fromBits(bits);

    if (!extracted.startsWith(_crypto.header)) {
      return TextDecodeResult(
        success: false,
        error: 'No hidden data found in this text',
      );
    }

    final encryptedPart = extracted.substring(_crypto.header.length);
    final decrypted = _crypto.decrypt(encryptedPart, password);

    if (decrypted == null) {
      return TextDecodeResult(success: false, error: 'Incorrect password');
    }

    return TextDecodeResult(success: true, message: decrypted);
  }

  // repeats cover text until it has enough word gaps to carry all bits
  // one word gap carries one bit
  String _padCoverText(String coverText, int bitsNeeded) {
    var padded = coverText;
    while (padded.split(' ').length - 1 < bitsNeeded) {
      padded = '$padded $coverText';
    }
    return padded;
  }

  // converts a string into a list of individual bits
  // each character becomes 8 bits in big-endian order
  List<int> _toBits(String text) {
    return text.codeUnits
        .expand((c) => List.generate(8, (i) => (c >> (7 - i)) & 1))
        .toList();
  }

  // converts a list of bits back into a string
  // every 8 bits becomes one character
  String _fromBits(List<int> bits) {
    final buffer = StringBuffer();
    for (int i = 0; i + 7 < bits.length; i += 8) {
      final byte = bits.sublist(i, i + 8).fold(0, (acc, b) => (acc << 1) | b);
      buffer.writeCharCode(byte);
    }
    return buffer.toString();
  }
}
