import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SettingsViewModel extends GetxController {
  // --- اطلاعات کاربر (بعدا از دیتابیس خوانده می‌شود) ---
  final userName = 'محمد'.obs;
  final userEmail = 'mohammad@tickdone.com'.obs;

  // آمار خلاصه برای کارت پروفایل
  final completedTasks = 128;
  final currentStreak = 14;
  final productivityScore = 94;

  // --- تنظیمات ظاهر (Appearance) ---
  // حالت تم: light, dark, auto
  final themeMode = 'light'.obs;

  // رنگ اصلی اپلیکیشن
  final accentColor = 'blue'.obs;

  // --- تنظیمات اعلان‌ها ---
  final dailyBriefingEnabled = true.obs;
  final taskRemindersEnabled = true.obs;

  // --- متدهای تغییر استیت ---
  void changeTheme(String mode) {
    themeMode.value = mode;
    // TODO: پیاده‌سازی تغییر تم واقعی فلاتر (Get.changeThemeMode)
  }

  void changeAccentColor(String colorKey) {
    accentColor.value = colorKey;
    // TODO: تغییر رنگ اصلی اپلیکیشن و ذخیره در GetStorage
  }

  void toggleDailyBriefing(bool value) => dailyBriefingEnabled.value = value;
  void toggleTaskReminders(bool value) => taskRemindersEnabled.value = value;

  // خروج از حساب
  void logout() {
    // TODO: پاک کردن توکن از GetStorage و خروج از Appwrite
    // _authRepository.logout();
    // Get.offAllNamed(Routes.LOGIN);
    Get.snackbar('خروج', 'شما از حساب کاربری خارج شدید.');
  }
}