import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'text_encode_screen.dart';

class EncodeHomeScreen extends StatelessWidget {
  const EncodeHomeScreen({super.key});

  void onTextTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TextEncodeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Encode',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose any types of steganography',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: AppTheme.divider),
            const SizedBox(height: 20),
            OptionCard(
              color: AppTheme.green,
              icon: Icons.notes_rounded,
              title: 'Text steganography',
              subtitle: 'Hide message in paragraph using invisible characters',
              onTap: () => onTextTap(context),
            ),
            const SizedBox(height: 16),
            OptionCard(
              color: const Color(0xFF2B6CB0),
              icon: Icons.image_outlined,
              title: 'Image steganography',
              subtitle: 'Hide text or file inside photo pixels using LSB',
              onTap: (){}, // to do
            ),
            const SizedBox(height: 16),
            OptionCard(
              color: const Color(0xFFB7791F),
              icon: Icons.graphic_eq_rounded,
              title: 'Audio steganography',
              subtitle: 'Hide message in WAV audio sample bits',
              onTap: () {} // // to do
            ),
          ],
        ),
      ),
    );
  }
}


class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(14),
          border: Border(
            left: BorderSide(color: color, width: 4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 1.5),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}