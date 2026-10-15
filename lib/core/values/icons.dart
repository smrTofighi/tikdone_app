import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class AppIcons {
  // ۱. لیست تمام آیکون‌های در دسترس (برای نمایش در فرم ساخت/ویرایش دسته‌بندی)
  static const List<IconData> availableIcons = [
    FluentIcons.home_24_regular,
    FluentIcons.briefcase_24_regular,
    FluentIcons.hat_graduation_24_regular,
    FluentIcons.cart_24_regular,
    FluentIcons.dumbbell_24_regular,
    FluentIcons.heart_24_regular,
    FluentIcons.money_24_regular,
    FluentIcons.airplane_24_regular,
    FluentIcons.music_note_2_24_regular,
    FluentIcons.lightbulb_24_regular,
    FluentIcons.gift_24_regular,
    FluentIcons.code_24_regular,
    FluentIcons.weather_sunny_24_regular,
    FluentIcons.weather_moon_24_regular,
    FluentIcons.star_24_regular,
    FluentIcons.vehicle_car_24_regular,
    FluentIcons.book_24_regular,
    FluentIcons.sport_soccer_24_regular,
    FluentIcons.bed_24_regular,
    FluentIcons.tree_deciduous_24_regular,
    FluentIcons.globe_24_regular,
    FluentIcons.drink_wine_24_regular,
    FluentIcons.camera_24_regular,
    FluentIcons.games_24_regular,
    FluentIcons.list_24_regular,
  ];

  // ۲. گرفتن آیکون با استفاده از عدد (codePoint) ذخیره شده در دیتابیس
  static IconData getIconFromCode(int codePoint) {
    // در لیست می‌گردد؛ اگر آیکونی با این کد پیدا کرد آن را برمی‌گرداند.
    // در غیر این صورت (مثلاً دیتای اشتباه) آیکون پیش‌فرض را نمایش می‌دهد.
    return availableIcons.firstWhere(
      (icon) => icon.codePoint == codePoint,
      orElse: () => FluentIcons.list_24_regular, // آیکون پیش‌فرض
    );
  }
}
