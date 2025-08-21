import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomodoro/widgets/add_task_sheet.dart';
import 'package:tomodoro/widgets/info_card.dart';
import 'package:tomodoro/widgets/task_tile.dart';
import 'package:tomodoro/models/tasky.dart';
import 'package:tomodoro/providers/tasky_provider.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  Color _priorityColor(BuildContext context, TaskyPriority priority) {
    // You can keep distinct colors for priorities, or
    // tie them into your main theme if desired.
    final theme = Theme.of(context);
    switch (priority) {
      case TaskyPriority.high:
        // Use a richer red for high priority
        return Colors.redAccent;
      case TaskyPriority.medium:
        // Use theme.secondary (teal) for medium
        return theme.colorScheme.secondary;
      case TaskyPriority.low:
        // Use theme.primary (warm orange) for low
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskyProvider);
    final completed = tasks.where((t) => t.isDone).toList();
    final active = tasks.where((t) => !t.isDone).toList();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Retrieve primary/secondary for button styling
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    // Text styles based on theme
    final headerTextStyle = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : Colors.black,
    );
    final sectionTitleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : Colors.black,
    );
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Today', style: headerTextStyle),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info cards row
            Row(
              children: [
                InfoCard(title: "All Tasks", value: "${active.length}"),
                const SizedBox(width: 12),
                InfoCard(title: "Done", value: "${completed.length}"),
              ],
            ),
            const SizedBox(height: 24),

            // Section title: All Tasks
            Text("All Tasks", style: sectionTitleStyle),
            const SizedBox(height: 8),

            // Active and Completed tasks list
            Expanded(
              child: ListView(
                children: [
                  // Active tasks
                  ...active.map(
                    (task) => TaskTile(
                      task: task,
                      color: _priorityColor(context, task.priority),
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
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...completed.map(
                      (task) => TaskTile(
                        task: task,
                        color: _priorityColor(context, task.priority),
                        completed: true,
                        onDone:
                            () => ref
                                .read(taskyProvider.notifier)
                                .uncompleteTask(task.taskyId),
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

            // Add New Task button
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                width: 240,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text(
                    "Add new task",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
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
