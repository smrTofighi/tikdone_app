import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class AppIcons {
  // نقشه‌برداری کلیدهای متنی (String) به آیکون‌های واقعی (IconData)
  static Map<String, IconData> iconMap = {
    'home': FluentIcons.home_24_regular,
    'work': FluentIcons.briefcase_24_regular,
    'school': FluentIcons.hat_graduation_24_regular,
    'shopping': FluentIcons.cart_24_regular,
    'fitness': FluentIcons.dumbbell_24_regular,
    'health': FluentIcons.heart_24_regular,
    'finance': FluentIcons.money_24_regular,
    'travel': FluentIcons.airplane_24_regular,
    'music': FluentIcons.music_note_2_24_regular,
    'idea': FluentIcons.lightbulb_24_regular,
    'gift': FluentIcons.gift_24_regular,
    'code': FluentIcons.code_24_regular,
    'sun': FluentIcons.weather_sunny_24_regular,
    'moon': FluentIcons.weather_moon_24_regular,
    'star': FluentIcons.star_24_regular,
    'car': FluentIcons.vehicle_car_24_regular,
    'book': FluentIcons.book_24_regular,
    'football': FluentIcons.sport_soccer_24_regular,
    'bed': FluentIcons.bed_24_regular,
    'tree': FluentIcons.tree_deciduous_24_regular,
    'world': FluentIcons.globe_24_regular,
    'drink': FluentIcons.drink_wine_24_regular,
    'camera': FluentIcons.camera_24_regular,
    'game': FluentIcons.games_24_regular,
    'list': FluentIcons.list_24_regular,
  };

  // گرفتن لیست تمام کلیدها (برای ساخت لیست آیکون‌ها در باتم‌شیت)
  static List<String> get iconKeys => iconMap.keys.toList();

  // گرفتن آیکون با استفاده از کلید ذخیره شده در دیتابیس
  static IconData getIcon(String iconKey) {
    // اگر کلید پیدا نشد، آیکون پیش‌فرض (لیست) رو برگردون
    return iconMap[iconKey] ?? FluentIcons.list_24_regular;
  }
}
