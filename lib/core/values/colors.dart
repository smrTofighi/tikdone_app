import 'package:flutter/material.dart';

class AppColors {
  // ==========================================
  // رنگ‌های برند (گرفته شده از پالت Design System)
  // ==========================================
  static const Color primary = Color(0xFF00B4D8); // آبی فیروزه‌ای روشن
  static const Color secondary = Color(0xFF0077B6); // آبی اقیانوسی عمیق
  static const Color tertiary = Color(0xFF4361EE); // نیلی / بنفش-آبی
  static const Color neutral =
      Color(0xFF0F172A); // سرمه‌ای بسیار تیره (جایگزین مشکی خالص)

  // ==========================================
  // رنگ‌های ساختاری (پس‌زمینه و کارت‌ها)
  // ==========================================
  static const Color backgroundLight =
      Color(0xFFF1F5F9); // پس‌زمینه ملایم برای تم روشن
  static const Color backgroundDark =
      neutral; // استفاده از Neutral برای تم تاریک
  static const Color cardLight = Colors.white;
  static const Color cardDark =
      Color(0xFF1E293B); // کمی روشن‌تر از Neutral برای کارت‌ها

  // ==========================================
  // رنگ‌های متن (Typography)
  // ==========================================
  static const Color textMainLight =
      neutral; // به جای مشکی خالص، از Neutral استفاده می‌کنیم
  static const Color textMutedLight = Color(0xFF64748B);
  static const Color textMainDark = Colors.white;
  static const Color textMutedDark = Color(0xFF94A3B8);

  // ==========================================
  // رنگ‌های کاربردی (Status)
  // ==========================================
  static const Color error =
      Color(0xFFDC2626); // رنگ قرمز استاندارد برای دکمه‌های حذف
  static const Color success = Color(0xFF10B981);

  // ==========================================
  // متغیرهای قدیمی (جهت جلوگیری از ارور در سایر صفحات)
  // ==========================================
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color backGround = backgroundLight;
}

class ShadowColor {
  static Color black = Colors.black.withOpacity(0.08);
  static Color primary =
      AppColors.primary.withOpacity(0.25); // سایه نرم همرنگ تم اصلی
}

// ==========================================
// سیستم مدیریت تم‌ها و رنگ‌های داینامیک دیتابیس
// ==========================================

class ThemeHelper {
  // لیست پالت‌های پیش‌فرض برای نمایش در باتم‌شیت (فرمت استرینگ برای ارسال به دیتابیس)
  static List<String> defaultThemes = [
    'solid_#00B4D8', // Primary (از پالت جدید)
    'solid_#0077B6', // Secondary (از پالت جدید)
    'solid_#4361EE', // Tertiary (از پالت جدید)
    'solid_#0F172A', // Neutral (از پالت جدید)
    'solid_#10B981', // Emerald Green
    'solid_#F59E0B', // Amber
    'solid_#EF4444', // Red
    'solid_#8B5CF6', // Violet
    'solid_#EC4899', // Pink
    'solid_#14B8A6', // Teal
    'solid_#F97316', // Orange
    'solid_#64748B', // Slate Grey
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
        // در صورت گرادیان، فعلاً رنگ اول را برمی‌گردانیم
        return _hexToColor(themeString.split('_')[1]);
      }
    } catch (e) {
      debugPrint('Error parsing theme: $e');
    }
    // رنگ پیش‌فرض در صورت بروز خطا (همان رنگ Primary جدید)
    return AppColors.primary;
  }

  // تبدیل شئ Color به رشته برای ذخیره در دیتابیس (برای ساخت رنگ کاستوم)
  static String colorToThemeString(Color color) {
    return 'solid_#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}
