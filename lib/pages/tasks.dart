import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomodoro/models/tasky.dart';
import 'package:tomodoro/providers/tasky_provider.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFF23232A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Today',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                _InfoCard(title: "َAll Tasks", value: "${active.length}"),
                const SizedBox(width: 12),
                _InfoCard(title: "Done", value: "${completed.length}"),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "All Tasks",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Active Tasks
            Expanded(
              child: ListView(
                children: [
                  ...active.map(
                    (task) => _TaskTile(
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
                    const Text(
                      "Completed",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...completed.map(
                      (task) => _TaskTile(
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
                        backgroundColor: const Color(0xFF23232A),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        builder: (ctx) => const _AddTaskSheet(),
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

class _TaskTile extends StatelessWidget {
  final Tasky task;
  final Color color;
  final bool completed;
  final VoidCallback? onDone;
  final VoidCallback? onDelete;

  const _TaskTile({
    required this.task,
    required this.color,
    this.completed = false,
    this.onDone,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2D2D36),
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, radius: 10),
        title: Text(
          task.content,
          style: TextStyle(
            color: Colors.white,
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

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  const _InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D36),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddTaskSheet extends ConsumerStatefulWidget {
  const _AddTaskSheet();

  @override
  ConsumerState<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<_AddTaskSheet> {
  final _controller = TextEditingController();
  TaskyPriority _priority = TaskyPriority.low;

  @override
  Widget build(BuildContext context) {
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
          const Text(
            "New Task",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Task name",
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF2D2D36),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text("Task priority", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Row(
            children: [
              _PriorityChip(
                label: "High",
                selected: _priority == TaskyPriority.high,
                color: Colors.redAccent,
                onTap: () => setState(() => _priority = TaskyPriority.high),
              ),
              const SizedBox(width: 8),
              _PriorityChip(
                label: "Medium",
                selected: _priority == TaskyPriority.medium,
                color: Colors.amber,
                onTap: () => setState(() => _priority = TaskyPriority.medium),
              ),
              const SizedBox(width: 8),
              _PriorityChip(
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

class _PriorityChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _PriorityChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: selected ? color : const Color(0xFF23232A),
            shape: StadiumBorder(side: BorderSide(color: color, width: 1.5)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          ),
        ),
      ),
    );
  }
}
