import 'package:get/get.dart';

class AnalyticsViewModel extends GetxController {
  // فیلتر بازه زمانی: today, week, month, year
  final RxString activeTimeRange = 'week'.obs;

  void setTimeRange(String range) {
    activeTimeRange.value = range;
    // TODO: واکشی مجدد دیتای نمودارها بر اساس بازه انتخابی از Appwrite
  }

  // دیتاهای موقت (Mock Data) برای UI
  final int totalTasks = 48;
  final int completedTasks = 42;
  double get completionRate => (completedTasks / totalTasks) * 100;

  final int currentStreak = 16;
  final int currentLevel = 4;
  final int averageTasksPerDay = 6;

  // دیتای نمودار میله‌ای (۷ روز هفته)
  final List<double> weeklyData = [5, 7, 4, 10, 8, 5, 3]; // از شنبه تا جمعه

  // دیتای نمودار دایره‌ای (دسته‌بندی‌ها)
  final List<Map<String, dynamic>> categoryStats = [
    {'title': 'پروژه‌های کاری', 'tasks': 15, 'percent': 35, 'color': 0xFF00B4D8},
    {'title': 'ورزش و سلامت', 'tasks': 11, 'percent': 25, 'color': 0xFF22C55E},
    {'title': 'خرید و لوازم', 'tasks': 8, 'percent': 20, 'color': 0xFFF97316},
    {'title': 'توسعه فردی', 'tasks': 8, 'percent': 20, 'color': 0xFFA855F7},
  ];
}