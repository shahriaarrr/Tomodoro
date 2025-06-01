import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  const InfoCard({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Extract primary and secondary from theme
    final primaryColor = theme.colorScheme.primary; // warm orange
    final secondaryColor = theme.colorScheme.secondary; // teal
    // Determine subtitle color based on brightness
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Display the numeric value in primaryColor
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Display the title in a muted secondary/subtitle color
            Text(title, style: TextStyle(fontSize: 13, color: subtitleColor)),
          ],
        ),
      ),
    );
  }
}
