import 'package:hive_flutter/hive_flutter.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String name;

  @HiveField(1)
  bool isCompleted;

  Task({required this.name, this.isCompleted = false});
}
