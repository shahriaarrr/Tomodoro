import 'package:flutter/material.dart';
import 'package:tomodoro/models/tasky.dart';

class TaskTile extends StatelessWidget {
  final Tasky task;
  final Color color;
  final bool completed;
  final VoidCallback? onDone;
  final VoidCallback? onDelete;

  const TaskTile({
    required this.task,
    required this.color,
    this.completed = false,
    this.onDone,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      color: theme.cardColor,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, radius: 10),
        title: Text(
          task.content,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            decoration: completed ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!completed && onDone != null)
              IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.greenAccent),
                onPressed: onDone,
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
