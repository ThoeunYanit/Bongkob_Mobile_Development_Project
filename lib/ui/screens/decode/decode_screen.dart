import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/services/text_stegano_service.dart';
import 'package:bongkob_project_v2/theme/app_theme.dart';
import 'package:bongkob_project_v2/ui/widgets/error_box.dart';
import 'package:bongkob_project_v2/ui/widgets/success_box.dart';

enum DecodeTab { image, text, audio }

class DecodeScreen extends StatefulWidget {
  const DecodeScreen({super.key});

  @override
  State<DecodeScreen> createState() => _DecodeScreenState();
}

class _DecodeScreenState extends State<DecodeScreen> {
  final service = TextSteganoService();
  final textController = TextEditingController();
  final passwordController = TextEditingController();

  DecodeTab activeTab = DecodeTab.image;
  bool isDecoding = false;
  bool showPassword = false;
  String? successMessage;
  String? errorMessage;

  @override
  void dispose() {
    textController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // called when user taps a tab
  // clears result state and switches tab
  void _onTabChanged(DecodeTab tab) {
    setState(() {
      activeTab = tab;
      successMessage = null;
      errorMessage = null;
      textController.clear();
    });
  }

  // called when user taps Extract
  // only text works
  void _onExtractPressed() async {
    if (activeTab != DecodeTab.text) {
      setState(() => errorMessage = 'Coming in Step 3');
      return;
    }

    setState(() {
      isDecoding = true;
      successMessage = null;
      errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    final result = service.decode(
      encodedText: textController.text,
      password: passwordController.text,
    );

    setState(() {
      isDecoding = false;
      if (result.success) {
        successMessage = result.message;
      } else {
        errorMessage = result.error;
      }
    });
  }

  // called when user taps Try again
  void _onRetryPressed() {
    setState(() {
      successMessage = null;
      errorMessage = null;
    });
  }

  // called when user taps Copy
  void _onCopyPressed() {
    if (successMessage == null) {
      return;
    }
    Clipboard.setData(ClipboardData(text: successMessage!));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Message copied')));
  }

  // called when user taps Dismiss
  void _onDismissPressed() {
    setState(() {
      successMessage = null;
      errorMessage = null;
    });
  }

  // called when user taps eye icon on password field
  void _onTogglePassword() {
    setState(() => showPassword = !showPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: 
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── HEADER ──
              const Text(
                'Decode',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Load the file or text you want to decode here.',
                style: TextStyle(fontSize: 13, color: AppTheme.labelColor),
              ),
              const SizedBox(height: 20),


              // ── TABS ──
              Row(
                children: [
                  _TabButton(
                    label: 'IMAGE',
                    isActive: activeTab == DecodeTab.image,
                    onTap: () => _onTabChanged(DecodeTab.image),
                  ),
                  _TabButton(
                    label: 'TEXT',
                    isActive: activeTab == DecodeTab.text,
                    onTap: () => _onTabChanged(DecodeTab.text),
                  ),
                  _TabButton(
                    label: 'AUDIO',
                    isActive: activeTab == DecodeTab.audio,
                    onTap: () => _onTabChanged(DecodeTab.audio),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── FILE LOADED ──
              Text(
                'FILE LOADED',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.labelColor,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),

              // text tab — paste area
              if (activeTab == DecodeTab.text)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.divider),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextField(
                    controller: textController,
                    maxLines: 4,
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(12),
                      hintText:
                          'Paste the encoded text here.\nDo not retype — hidden characters will be lost.',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),

              // image and audio — placeholder
              if (activeTab != DecodeTab.text)
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.divider),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      activeTab == DecodeTab.image
                          ? 'Image decode — coming in Step 3'
                          : 'Audio decode — coming in Step 3',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),


              // ── PASSWORD ──
              Text(
                'PASSWORD',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.labelColor,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: passwordController,
                obscureText: showPassword,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  letterSpacing: 2,
                ),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.divider),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.divider),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.green, width: 2),
                  ),
                  hintText: 'Enter password',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: _onTogglePassword,
                    child: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── EXTRACT BUTTON ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isDecoding ? null : _onExtractPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isDecoding
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_open,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'EXTRACT',
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

              // ── SUCCESS ──
              if (successMessage != null)
                SuccessBox(
                  title: 'Message recovered',
                  message: successMessage!,
                  onCopy: _onCopyPressed,
                  onDismiss: _onDismissPressed,
                ),

              // ── ERROR ──
              if (errorMessage != null)
                ErrorBox(error: errorMessage!, onRetry: _onRetryPressed),
            ],
          ),
        ),
    );
  }
}


class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Color(0xFFF7F1E3) : Colors.transparent,
            border: Border.all(color: const Color(0xFFD8D0B8)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: isActive ? Colors.black : const Color(0xFF9C9683),
            ),
          ),
        ),
      ),
    );
  }
}

