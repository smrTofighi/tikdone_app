import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  // مدیریت باز و بسته شدن تسک‌های تکمیل شده
  final RxBool isCompletedExpanded = true.obs;

  void toggleCompleted() {
    isCompletedExpanded.value = !isCompletedExpanded.value;
  }

  // دیتاهای موقت برای نمایش در UI (بعداً از دیتابیس خوانده می‌شوند)
  final String userName = "سارا";
  final String todayDate = "امروز، ۱۸ اردیبهشت";

  final int completedTasksCount = 4;
  final int totalTasksCount = 7;

  double get progressPercent => totalTasksCount == 0 ? 0 : completedTasksCount / totalTasksCount;
  int get progressPercentInt => (progressPercent * 100).toInt();
}