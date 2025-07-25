import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomodoro/providers/theme_provider.dart';
import 'package:tomodoro/providers/timer_provider.dart';
import 'package:tomodoro/widgets/duration_picker_sheet.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final timerController = ref.read(tomodoroTimerProvider.notifier);

    // Extract theme colors
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary; // warm orange
    final secondaryColor = theme.colorScheme.secondary; // teal
    final cardColor = theme.cardColor;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;
    final switchActiveThumb = primaryColor;
    final switchActiveTrack = primaryColor.withOpacity(0.3);
    final switchInactiveThumb =
        isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final switchInactiveTrack =
        isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Page title
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 40),

              // Settings card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Theme row
                    Row(
                      children: [
                        Icon(
                          Icons.palette_outlined,
                          color: primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'App Theme',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Dark Mode toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dark Mode',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Toggle between light and dark theme',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: currentTheme == AppThemeMode.dark,
                          onChanged: (value) {
                            themeNotifier.setTheme(
                              value ? AppThemeMode.dark : AppThemeMode.light,
                            );
                          },
                          activeColor: switchActiveThumb,
                          activeTrackColor: switchActiveTrack,
                          inactiveThumbColor: switchInactiveThumb,
                          inactiveTrackColor: switchInactiveTrack,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Timer Durations row
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Timer Durations',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Set custom durations button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Focus & Break',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Set custom durations for focus and break',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await showModalBottomSheet(
                              context: context,
                              backgroundColor: theme.scaffoldBackgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                              ),
                              builder:
                                  (context) => DurationPickerSheet(
                                    initialFocus: timerController.focusMinutes,
                                    initialBreak: timerController.breakMinutes,
                                    onConfirm: (focus, breaks) {
                                      timerController.setDurations(
                                        focus: focus,
                                        breaks: breaks,
                                      );
                                    },
                                  ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Set'),
                        ),
                      ],
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
