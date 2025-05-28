import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:tomodoro/models/tasky.dart';

final taskyProvider = StateNotifierProvider<TaskyListNotifier, List<Tasky>>((
  ref,
) {
  return TaskyListNotifier();
});

class TaskyListNotifier extends StateNotifier<List<Tasky>> {
  TaskyListNotifier() : super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    if (!Hive.isBoxOpen('taskyBox')) {
      await Tasky.openBox();
    }
    final box = Tasky.taskyBox;
    state = box.values.toList();
  }

  Future<void> addTask(String content, TaskyPriority priority) async {
    final box = Tasky.taskyBox;

    final newId =
        box.isEmpty
            ? 0
            : (box.values
                    .map((t) => t.taskyId)
                    .fold<int>(0, (prev, el) => el > prev ? el : prev) +
                1);
    final task = Tasky(
      taskyId: newId,
      content: content,
      priority: priority,
      isDone: false,
    );
    await box.add(task);
    state = box.values.toList();
  }

  Future<void> completeTask(int taskyId) async {
    final box = Tasky.taskyBox;
    final key = box.keys.firstWhere(
      (k) => box.get(k)!.taskyId == taskyId,
      orElse: () => null,
    );
    if (key != null) {
      final oldTask = box.get(key)!;
      final updatedTask = Tasky(
        taskyId: oldTask.taskyId,
        content: oldTask.content,
        priority: oldTask.priority,
        isDone: true,
      );
      await box.put(key, updatedTask);
      state = box.values.toList();
    }
  }

  Future<void> uncompleteTask(int taskyId) async {
    final box = Tasky.taskyBox;
    final key = box.keys.firstWhere(
      (k) => box.get(k)!.taskyId == taskyId,
      orElse: () => null,
    );
    if (key != null) {
      final oldTask = box.get(key)!;
      final updatedTask = Tasky(
        taskyId: oldTask.taskyId,
        content: oldTask.content,
        priority: oldTask.priority,
        isDone: false,
      );
      await box.put(key, updatedTask);
      state = box.values.toList();
    }
  }

  Future<void> deleteTask(int taskyId) async {
    final box = Tasky.taskyBox;
    final key = box.keys.firstWhere(
      (k) => box.get(k)!.taskyId == taskyId,
      orElse: () => null,
    );
    if (key != null) {
      await box.delete(key);
      state = box.values.toList();
    }
  }
}
