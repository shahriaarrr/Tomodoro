import 'dart:ui';
import 'package:flutter/material.dart';

class PriorityChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const PriorityChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter:
              selected
                  ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                  : ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Chip(
            label: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : color,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor:
                selected
                    ? color
                    : (isDark ? const Color(0xFF23232A) : Colors.grey[200]),
            shape: StadiumBorder(side: BorderSide(color: color, width: 1.5)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          ),
        ),
      ),
    );
  }
}
