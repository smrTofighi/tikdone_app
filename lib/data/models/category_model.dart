class CategoryModel {
  String id;
  String userId;
  String title;
  String theme;
  int icon;
  bool pinToTop; // اضافه شدن فیلد پین

  int totalTodos;
  int completedTodos;
  List<dynamic>? activeTodos;
  List<dynamic>? unActiveTodos;

  CategoryModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.theme,
    required this.icon,
    this.pinToTop = false,
    this.totalTodos = 0,
    this.completedTodos = 0,
    this.activeTodos,
    this.unActiveTodos,
  });

  // ==========================================
  // متغیرهای کمکی محاسبه‌شونده برای رابط کاربری (UI)
  // ==========================================

  // درصد پیشرفت (اعشاری)
  double get percentage => totalTodos == 0 ? 0.0 : completedTodos / totalTodos;

  // درصد پیشرفت (صحیح - برای نمایش در UI)
  int get progressPercent => (percentage * 100).toInt();

  // تعداد تسک‌های فعال
  int get activeTasks =>
      totalTodos > completedTodos ? totalTodos - completedTodos : 0;

  // بررسی تکمیل بودن دسته
  bool get isCompleted => totalTodos > 0 && completedTodos == totalTodos;

  // وضعیت اولویت بالا (اگر در آینده فیلدی در دیتابیس زدید اینجا متصل کنید، فعلاً false)
  bool get isHighPriority => false;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? json['\$id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      theme: json['theme'] ?? 'solid_#00B4D8', // فیروزه‌ای پیش‌فرض
      // اصلاح خطای تایپ: تبدیل امن به int
      icon: json['icon'] != null
          ? int.tryParse(json['icon'].toString()) ?? 58272
          : 58272,
      pinToTop: json['pinToTop'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'theme': theme,
      'icon': icon,
      'pinToTop': pinToTop,
    };
  }
}
