import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class AppIcons {
  // نقشه‌برداری کلیدهای متنی (String) به آیکون‌های واقعی (IconData)
  static Map<String, IconData> iconMap = {
    'home': IonIcons.home,
    'work': IonIcons.briefcase,
    'school': IonIcons.school,
    'shopping': IonIcons.cart,
    'fitness': IonIcons.barbell,
    'health': IonIcons.heart,
    'finance': IonIcons.cash,
    'travel': IonIcons.airplane,
    'music': IonIcons.musical_notes,
    'idea': IonIcons.bulb,
    'gift': IonIcons.gift,
    'code': IonIcons.code_slash,
    'sun': IonIcons.sunny,
    'moon': IonIcons.moon,
    'star': IonIcons.star,
    'car': IonIcons.car,
    'book': IonIcons.book,
    'football': IonIcons.football,
    'bed': IonIcons.bed,
    'tree': IonIcons.leaf,
    'world': IonIcons.globe,
    'drink': IonIcons.wine,
    'camera': IonIcons.camera,
    'game': IonIcons.game_controller,
    'list': IonIcons.list_circle,
  };

  // گرفتن لیست تمام کلیدها (برای ساخت لیست آیکون‌ها در باتم‌شیت)
  static List<String> get iconKeys => iconMap.keys.toList();

  // گرفتن آیکون با استفاده از کلید ذخیره شده در دیتابیس
  static IconData getIcon(String iconKey) {
    // اگر کلید پیدا نشد، آیکون پیش‌فرض (لیست) رو برگردون
    return iconMap[iconKey] ?? IonIcons.list_circle;
  }
}
