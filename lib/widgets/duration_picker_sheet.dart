import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DurationPickerSheet extends StatefulWidget {
  final int initialFocus;
  final int initialBreak;
  final void Function(int focus, int breaks) onConfirm;

  const DurationPickerSheet({
    super.key,
    required this.initialFocus,
    required this.initialBreak,
    required this.onConfirm,
  });

  @override
  State<DurationPickerSheet> createState() => _DurationPickerSheetState();
}

class _DurationPickerSheetState extends State<DurationPickerSheet> {
  late int focusMinutes;
  late int breakMinutes;

  @override
  void initState() {
    super.initState();
    focusMinutes = widget.initialFocus;
    breakMinutes = widget.initialBreak;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use theme colors instead of fixed purple
    final primaryColor = theme.colorScheme.primary; // warm orange
    final secondaryColor = theme.colorScheme.secondary; // teal
    final cardColor = theme.cardColor;
    final textColor = isDark ? Colors.white : Colors.black87;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: theme.scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Set durations',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),

            // Focus and Break pickers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Focus column
                Column(
                  children: [
                    Text(
                      'Focus',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      width: 80,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: focusMinutes - 1,
                        ),
                        itemExtent: 44,
                        selectionOverlay: Container(
                          alignment: Alignment.center,
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.3),
                            ),
                          ),
                        ),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            focusMinutes = index + 1;
                          });
                        },
                        children: List.generate(
                          60,
                          (i) => Center(
                            child: Text(
                              '${i + 1} min',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    (i + 1 == focusMinutes)
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    (i + 1 == focusMinutes)
                                        ? primaryColor
                                        : textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Break column
                Column(
                  children: [
                    Text(
                      'Break',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      width: 80,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: breakMinutes - 1,
                        ),
                        itemExtent: 44,
                        selectionOverlay: Container(
                          alignment: Alignment.center,
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.3),
                            ),
                          ),
                        ),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            breakMinutes = index + 1;
                          });
                        },
                        children: List.generate(
                          30,
                          (i) => Center(
                            child: Text(
                              '${i + 1} min',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    (i + 1 == breakMinutes)
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    (i + 1 == breakMinutes)
                                        ? primaryColor
                                        : textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Confirm button uses primaryColor
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                widget.onConfirm(focusMinutes, breakMinutes);
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
