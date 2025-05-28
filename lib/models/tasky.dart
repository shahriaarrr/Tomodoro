import 'package:hive/hive.dart';

part 'tasky.g.dart'; // Needed for code generation

// create enum for Priority of tasks
@HiveType(typeId: 1)
enum TaskyPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}

@HiveType(typeId: 0)
class Tasky extends HiveObject {
  @HiveField(0)
  final int taskyId;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final TaskyPriority priority;

  @HiveField(3)
  final bool isDone;

  Tasky({
    required this.taskyId,
    required this.content,
    required this.priority,
    required this.isDone,
  });

  // Static Hive box variable
  static late Box<Tasky> _mybox;

  static Future<void> openBox() async {
    _mybox = await Hive.openBox<Tasky>('taskyBox');
  }

  static Box<Tasky> get taskyBox => _mybox;
}
