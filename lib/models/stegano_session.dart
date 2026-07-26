class SteganoSession {
  final String mode;    // 'encode' or 'decode'
  final String result;  // 'success' or 'failed'
  final DateTime time;

  SteganoSession({
    required this.mode,
    required this.result,
    required this.time,
  });
}