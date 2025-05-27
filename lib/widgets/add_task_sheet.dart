import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomodoro/models/tasky.dart';
import 'package:tomodoro/providers/tasky_provider.dart';
import 'priority_chip.dart';

class AddTaskSheet extends ConsumerStatefulWidget {
  const AddTaskSheet({super.key});

  @override
  ConsumerState<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<AddTaskSheet> {
  final _controller = TextEditingController();
  TaskyPriority _priority = TaskyPriority.low;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 32,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Task",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _controller,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: "Task name",
              hintStyle: TextStyle(
                color: isDark ? Colors.white54 : Colors.black54,
              ),
              filled: true,
              fillColor: theme.cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            "Task priority",
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              PriorityChip(
                label: "High",
                selected: _priority == TaskyPriority.high,
                color: Colors.redAccent,
                onTap: () => setState(() => _priority = TaskyPriority.high),
              ),
              const SizedBox(width: 8),
              PriorityChip(
                label: "Medium",
                selected: _priority == TaskyPriority.medium,
                color: Colors.amber,
                onTap: () => setState(() => _priority = TaskyPriority.medium),
              ),
              const SizedBox(width: 8),
              PriorityChip(
                label: "Low",
                selected: _priority == TaskyPriority.low,
                color: Colors.green,
                onTap: () => setState(() => _priority = TaskyPriority.low),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              width: 240,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_controller.text.trim().isEmpty) return;
                  ref
                      .read(taskyProvider.notifier)
                      .addTask(_controller.text.trim(), _priority);
                  Navigator.pop(context);
                },
                child: const Text("Add Task", style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
