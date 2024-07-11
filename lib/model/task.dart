class Task {
  final int id;
  final int userId;
  String title;
  String description;
  bool completed;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.completed = false,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? 0,
      userId: map['user_id'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      completed: map['completed'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'completed': completed ? 1 : 0,
    };
  }
}
