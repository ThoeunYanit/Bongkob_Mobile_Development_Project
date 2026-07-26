import 'package:flutter/material.dart';
import '../../../../data/services/session_service.dart';
import '../../../../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void onClearAll() {
    SessionService.instance.clearAll();
    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Session history cleared')));
  }

  @override
  Widget build(BuildContext context) {
    final sessions = SessionService.instance.sessions;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Container(height: 1, color: AppTheme.divider),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'SESSION HISTORY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        color: AppTheme.labelColor,
                      ),
                    ),
                    if (sessions.isNotEmpty)
                      GestureDetector(
                        onTap: onClearAll,
                        child: const Text(
                          'Clear all',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // ── SESSION LIST ──
          Expanded(
            child: sessions.isEmpty
                ? Center(
                    child: Text(
                      'No sessions yet',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.labelColor,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final s = sessions[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppTheme.divider),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              s.mode == 'encode'
                                  ? Icons.lock_outline
                                  : Icons.lock_open_outlined,
                              color: AppTheme.labelColor,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.mode,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${s.time.day}/${s.time.month}/${s.time.year}  ${s.time.hour.toString().padLeft(2, '0')}:${s.time.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.labelColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              s.result,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: s.result == 'success'
                                    ? AppTheme.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
