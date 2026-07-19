// carries the output of TextSteganoService.encode()
// success true  → encodedText is the paragraph ready to copy and send
// success false → error describes what went wrong
class TextEncodeResult {
  final bool success;
  final String? encodedText;
  final String? error;

  TextEncodeResult({
    required this.success,
    this.encodedText,
    this.error,
  });
}

// carries the output of TextSteganoService.decode()
// success true  → message contains the revealed secret
// success false → error describes what went wrong
class TextDecodeResult {
  final bool success;
  final String? message;
  final String? error;

  TextDecodeResult({
    required this.success,
    this.message,
    this.error,
  });
}