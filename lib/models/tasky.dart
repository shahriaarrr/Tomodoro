// create enum for Priority of tasks
enum TaskyPriority { low, medium, high }

class Tasky {
  final int taskyId;
  final String content;
  final TaskyPriority priority;
  final bool isDone;

  Tasky({
    required this.taskyId,
    required this.content,
    required this.priority,
    required this.isDone,
  });
}
