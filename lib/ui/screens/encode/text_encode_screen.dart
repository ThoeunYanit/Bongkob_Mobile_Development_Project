import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/services/session_service.dart';
import '../../../data/services/text_stegano_service.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/success_box.dart';
import '../../widgets/error_box.dart';


class TextEncodeScreen extends StatefulWidget {
  const TextEncodeScreen({super.key});

  @override
  State<TextEncodeScreen> createState() => _TextEncodeScreenState();
}

class _TextEncodeScreenState extends State<TextEncodeScreen> {
  final messageController = TextEditingController();
  final coverController = TextEditingController();
  final passwordController = TextEditingController();

  final service = TextSteganoService();
 

  bool showPassword = false;

  int wordCount = 0; // get word count of cover paragraph

  // holds the encoded output — used only for copying, never displayed
  String? successMessage;
  String? errorMessage;

  @override
  void dispose() {
    messageController.dispose();
    coverController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // called when user taps Save
  void handleSave() async {
    setState(() {
      successMessage = null;
      errorMessage = null;
    });

    final result = service.encode(
      message: messageController.text.trim(),
      coverText: coverController.text.trim(),
      password: passwordController.text,
    );

    // log session after encode
    SessionService.instance.add('encode', result.success ? 'success' : 'failed');


    setState(() {
      if (result.success) {
        successMessage = result.encodedText;
      } else {
        errorMessage = result.error;
      }
    });
  }

  // called when user taps Try again
  void handleRetry() {
    setState(() => errorMessage = null);
  }

  // called when user taps Copy
  // copies encoded output to clipboard
  void handleCopy() {
    if (successMessage == null) return;
    Clipboard.setData(ClipboardData(text: successMessage!));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
  }

  // called when user taps Dismiss
  void handleDismiss() {
    setState(() => successMessage = null);
  }

  // to get word count of cover paragraph
  String get getWordCount {
    final needed_word = service.wordsNeeded(messageController.text.trim());
    final current = filterExtraSpace(coverController.text);

    return '$current / $needed_word words';
  }

  Color get getWordCountColor {
    final needed_word = service.wordsNeeded(messageController.text.trim());
    final current = filterExtraSpace(coverController.text);

    return current >= needed_word ? AppTheme.green : Colors.red;
  }

  int filterExtraSpace(String text) {
    return text.trim().split(' ').where((word) => word.isNotEmpty).length;
  } //filter extra space // Hello   WOrld => count as 2 // without it => 4 if we only filter ' '

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Row(
            children: [
              SizedBox(width: 16),
              Icon(Icons.arrow_back, color: Colors.black, size: 20),
            ],
          ),
        ),
        leadingWidth: 60,
        title: const Text(
          'BACK',
          style: TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Text steganography',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),

            // ── MESSAGE ──
            const Text(
              'MESSAGE TO HIDE',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: AppTheme.labelColor,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: messageController,
              onChanged: (value) => setState(() {}),
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Meet me at 9PM riverside.',
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.divider),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.divider),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.green, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── COVER TEXT ──
            const Text(
              'COVER PARAGRAPH',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: AppTheme.labelColor,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: coverController,
              onChanged: (value) => setState(() {}),
              minLines: 1,
              maxLines: null,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                height: 1.4,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(bottom: 8),
                hintText:
                    'The weather today is very nice and sunny outside near the riverside park, where people take their afternoon walks.',
                hintStyle: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.grey.shade400,
                ),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.divider),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.divider),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.green, width: 2),
                ),
              ),
            ),

            //  ── wordCount ──
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  getWordCount,
                  style: TextStyle(color: getWordCountColor, fontSize: 11),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── PASSWORD ──
            const Text(
              'PASSWORD',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: AppTheme.labelColor,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: !showPassword,
              style: const TextStyle(fontSize: 18, color: Colors.black),
              decoration: InputDecoration(
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.divider),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.divider),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.green, width: 2),
                ),
                suffixIcon: GestureDetector(
                  onTap: () => setState(() => showPassword = !showPassword),
                  child: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // ── SAVE BUTTON ──
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'SAVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── INFO BOX ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.divider),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'COPY IT, NEVER RETYPE IT',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.green,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please copy and paste. Retyping will erase the hidden characters.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // ── SUCCESS ──
            if (successMessage != null) ...[
              const SizedBox(height: 16),
              SuccessBox(
                title: 'Encoding complete',
                message: successMessage!,
                onCopy: handleCopy,
                onDismiss: handleDismiss,
              ),
            ],

            // ── ERROR ──
            if (errorMessage != null) ...[
              const SizedBox(height: 16),
              ErrorBox(error: errorMessage!, onRetry: handleRetry),
            ],
          ],
        ),
      ),
    );
  }
}
