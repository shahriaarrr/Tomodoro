import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomodoro/models/tasky.dart';

final taskyProvider = StateNotifierProvider<TaskyListNotifier, List<Tasky>>((
  ref,
) {
  return TaskyListNotifier();
});

class TaskyListNotifier extends StateNotifier<List<Tasky>> {
  TaskyListNotifier() : super([]);

  void addTask(String content, TaskyPriority priority) {
    state = [
      ...state,
      Tasky(
        taskyId: state.isEmpty ? 0 : state[state.length - 1].taskyId + 1,
        content: content,
        priority: priority,
        isDone: false,
      ),
    ];
  }

  void completeTask(int taskyId) {
    state = [
      for (final task in state)
        if (task.taskyId == taskyId)
          Tasky(
            taskyId: task.taskyId,
            content: task.content,
            priority: task.priority,
            isDone: true,
          )
        else
          task,
    ];
  }

  void deleteTask(int taskyId) {
    state = state.where((task) => task.taskyId != taskyId).toList();
  }
}
