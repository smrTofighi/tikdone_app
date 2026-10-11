import 'package:flutter/material.dart';

class AppColors {
  static const Color white54Text = Colors.white54;
  static Color greyText = Colors.grey.shade600;
  static const Color whiteText = Colors.white;
  static const Color blackText = Colors.black;
  static const Color redText = Colors.red;

  static const Color backGround = Color(0xfffcfcfc);
  static const Color primary = Color(0xff5786ff);
  static const Color card = Color(0xffffffff);
  static const Color backGroundTaskListPage = Color(0xffffffff);

  static const Color grey = Colors.grey;
  static const Color black = Colors.black;
  static const Color primaryBG = Color(0xff5786ff);
  static const Color white = Colors.white;
}

class ShadowColor {
  static Color black = Colors.black.withOpacity(0.1);
}

// ==========================================
// سیستم مدیریت تم‌ها و رنگ‌های داینامیک
// ==========================================

class ThemeHelper {
  // لیست پالت‌های پیش‌فرض برای نمایش در باتم‌شیت (فرمت استرینگ برای ارسال به دیتابیس)
  static List<String> defaultThemes = [
    'solid_#5786ff', // Primary
    'solid_#F44336', // Red
    'solid_#4CAF50', // Green
    'solid_#795548', // Brown
    'solid_#FF9800', // Orange
    'solid_#9C27B0', // Purple
    'solid_#FFC107', // Amber
    'solid_#00BCD4', // Cyan
    'solid_#E91E63', // Pink
    'solid_#009688', // Teal
    'solid_#607D8B', // BlueGrey
    'solid_#3F51B5', // Indigo
    // در آینده می‌تونی گرادیان هم اینجا اضافه کنی: 'gradient_#ff0000_#0000ff'
  ];

  // تبدیل کد Hex به شئ Color در فلاتر
  static Color _hexToColor(String hexCode) {
    String hex = hexCode.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // اضافه کردن آلفا (شفافیت) اگر نبود
    }
    return Color(int.parse(hex, radix: 16));
  }

  // گرفتن رنگ اصلی از رشته ذخیره شده در دیتابیس
  static Color parsePrimaryColor(String themeString) {
    try {
      if (themeString.startsWith('solid_')) {
        return _hexToColor(themeString.split('_')[1]);
      } else if (themeString.startsWith('gradient_')) {
        // در صورت گرادیان، رنگ اول را به عنوان رنگ اصلی برمی‌گردانیم
        return _hexToColor(themeString.split('_')[1]);
      }
    } catch (e) {
      debugPrint('Error parsing theme: $e');
    }
    // رنگ پیش‌فرض در صورت بروز خطا
    return AppColors.primary;
  }

  // تبدیل شئ Color به رشته برای ذخیره در دیتابیس (برای رنگ‌های کاستوم کاربر)
  static String colorToThemeString(Color color) {
    return 'solid_#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}
