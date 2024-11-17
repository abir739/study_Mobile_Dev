class Task {
  final String description;
  bool isCompleted;

  Task({required this.description, this.isCompleted = false});

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      description: map['description'] ?? '', 
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
