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
  int focusMinutes = 25;
  int breakMinutes = 5;

  @override
  void initState() {
    super.initState();
    focusMinutes = widget.initialFocus;
    breakMinutes = widget.initialBreak;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Set durations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Focus'),
                    SizedBox(
                      height: 120,
                      width: 80,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: focusMinutes - 1,
                        ),
                        itemExtent: 60,
                        selectionOverlay: Container(
                          alignment: Alignment.center,
                          height: 44,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.2),
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
                                fontSize: 20,
                                fontWeight:
                                    i + 1 == focusMinutes
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    i + 1 == focusMinutes
                                        ? Colors.purple
                                        : Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Break'),
                    SizedBox(
                      height: 120,
                      width: 80,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: breakMinutes - 1,
                        ),
                        itemExtent: 60,
                        selectionOverlay: Container(
                          alignment: Alignment.center,
                          height: 44,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.2),
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
                                fontSize: 20,
                                fontWeight:
                                    i + 1 == breakMinutes
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    i + 1 == breakMinutes
                                        ? Colors.purple
                                        : Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black87,
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
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
