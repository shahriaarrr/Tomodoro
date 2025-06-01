import 'package:flutter/material.dart';
import 'package:tomodoro/models/tasky.dart';

class TaskTile extends StatelessWidget {
  final Tasky task;
  final Color color;
  final bool completed;
  final VoidCallback? onDone;
  final VoidCallback? onDelete;
  final Widget? trailing;

  const TaskTile({
    Key? key,
    required this.task,
    required this.color,
    this.completed = false,
    this.onDone,
    this.onDelete,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Retrieve primary color (warm orange) from theme
    final primaryColor = theme.colorScheme.primary;
    // Define a fixed green color for the "done" check
    const doneIconColor = Colors.green;
    // Use primaryColor (warm orange) for the "undo" cancel icon
    final undoIconColor = primaryColor;
    // Error color for delete
    final errorColor = theme.colorScheme.error;
    // Text color based on theme
    final textColor = theme.textTheme.bodyLarge?.color;

    return Card(
      color: theme.cardColor,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        // Priority indicator circle
        leading: CircleAvatar(backgroundColor: color, radius: 10),

        // Task content text
        title: Text(
          task.content,
          style: TextStyle(
            color: textColor,
            decoration: completed ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // If task is not completed, show green check
            if (!completed && onDone != null)
              IconButton(
                icon: const Icon(Icons.check_circle, color: doneIconColor),
                onPressed: onDone,
                tooltip: 'Mark as done',
              ),
            // If task is completed, show orange cancel (undo)
            if (completed && onDone != null)
              IconButton(
                icon: Icon(Icons.cancel, color: undoIconColor),
                onPressed: onDone,
                tooltip: 'Mark as not done',
              ),
            // Delete button uses theme's error color
            IconButton(
              icon: Icon(Icons.delete_outline, color: errorColor),
              onPressed: onDelete,
              tooltip: 'Delete task',
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
