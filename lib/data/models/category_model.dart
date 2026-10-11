class CategoryModel {
  String id;
  String userId;
  String title;
  String theme; // به جای colorIndex
  String icon; // به جای iconIndex

  // این فیلدها معمولاً لوکال محاسبه میشن یا از سمت سرور میان
  int totalTodos;
  int completedTodos;
  double get percentage => totalTodos == 0 ? 0.0 : completedTodos / totalTodos;

  // لیست تسک‌ها که داخل ویومدل پر میشه
  List<dynamic>? activeTodos;
  List<dynamic>? unActiveTodos;

  CategoryModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.theme,
    required this.icon,
    this.totalTodos = 0,
    this.completedTodos = 0,
    this.activeTodos,
    this.unActiveTodos,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? json['\$id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      theme: json['theme'] ??
          'solid_#3B82F6', // یک مقدار پیش‌فرض در صورت خالی بودن
      icon: json['icon'] ?? 'folder_rounded',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'theme': theme,
      'icon': icon,
    };
  }
}
