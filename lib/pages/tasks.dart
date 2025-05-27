import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomodoro/models/tasky.dart';
import 'package:tomodoro/providers/tasky_provider.dart';
import 'package:tomodoro/widgets/task_tile.dart';
import 'package:tomodoro/widgets/info_card.dart';
import 'package:tomodoro/widgets/add_task_sheet.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  Color _priorityColor(TaskyPriority priority) {
    switch (priority) {
      case TaskyPriority.high:
        return Colors.redAccent;
      case TaskyPriority.medium:
        return Colors.amber;
      case TaskyPriority.low:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskyProvider);
    final completed = tasks.where((t) => t.isDone).toList();
    final active = tasks.where((t) => !t.isDone).toList();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Today',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: theme.appBarTheme.titleTextStyle?.color,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                InfoCard(title: "All Tasks", value: "${active.length}"),
                const SizedBox(width: 12),
                InfoCard(title: "Done", value: "${completed.length}"),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              "All Tasks",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Active Tasks
            Expanded(
              child: ListView(
                children: [
                  ...active.map(
                    (task) => TaskTile(
                      task: task,
                      color: _priorityColor(task.priority),
                      onDone:
                          () => ref
                              .read(taskyProvider.notifier)
                              .completeTask(task.taskyId),
                      onDelete:
                          () => ref
                              .read(taskyProvider.notifier)
                              .deleteTask(task.taskyId),
                    ),
                  ),
                  if (completed.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    Text(
                      "Completed",
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...completed.map(
                      (task) => TaskTile(
                        task: task,
                        color: _priorityColor(task.priority),
                        completed: true,
                        onDelete:
                            () => ref
                                .read(taskyProvider.notifier)
                                .deleteTask(task.taskyId),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                width: 240,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    "Add new task",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed:
                      () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: theme.scaffoldBackgroundColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        builder: (ctx) => const AddTaskSheet(),
                      ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
