class TodoModel {
  String id;
  String categoryId;
  String userId;
  String title;
  String? description;
  bool completed;
  int priority;
  DateTime? dueDate; // جدید: تاریخ سررسید
  DateTime? remindAt; // جدید: ساعت یادآوری

  TodoModel({
    required this.id,
    required this.categoryId,
    required this.userId,
    required this.title,
    this.description,
    required this.completed,
    this.priority = 0,
    this.dueDate,
    this.remindAt,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] ?? json['\$id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      completed: json['completed'] ?? false,
      priority: json['priority'] ?? 0,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      remindAt:
          json['remindAt'] != null ? DateTime.parse(json['remindAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'userId': userId,
      'title': title,
      'description': description,
      'completed': completed,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'remindAt': remindAt?.toIso8601String(),
    };
  }
}
