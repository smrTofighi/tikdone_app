import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/task/view_model/create_task_view_model.dart';
// import 'package:tikdone_app/core/utils/theme_helper.dart';

import '../../../../../core/values/colors.dart';
import '../../../../../core/values/dimens.dart';
import '../../../../category/view-model/category_workspace_view_model.dart';

class DueDateTaskCard extends GetView<CreateTaskViewModel> {
  const DueDateTaskCard({super.key});

  // متد کمکی برای تبدیل تاریخ به متن خوانا
  String _getFriendlyDateText(DateTime date) {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'امروز';
    } else if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return 'فردا';
    } else {
      // اینجا بعداً می‌تونی از پکیج‌های شمسی استفاده کنی (مثلاً shamsi_date)
      return '${date.year}/${date.month}/${date.day}';
    }
  }

  // توابع کمکی برای تشخیص انتخاب بودن دکمه‌ها
  bool _isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isTomorrow(DateTime? date) {
    if (date == null) return false;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;
  }

  @override
  Widget build(BuildContext context) {
    final color = ThemeHelper.parsePrimaryColor(
        Get.find<CategoryWorkspaceViewModel>().category.value.theme);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.cardLight, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 18, color: color),
                  const SizedBox(width: 6),
                  const Text('موعد انجام تسک',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMainLight)),
                ],
              ),
              Row(
                children: [
                  // ۱. نمایش متنی تاریخ انتخاب شده
                  Obx(() {
                    if (controller.pickDateEnabled.value && controller.dueDate.value != null) {
                      return Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                            _getFriendlyDateText(controller.dueDate.value!),
                            style: TextStyle(
                                fontSize: 11,
                                color: color,
                                fontWeight: FontWeight.bold)),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  // ۲. سوییچ فعال/غیرفعال کردن بخش تاریخ
                  Obx(() => Switch(
                    value: controller.pickDateEnabled.value,
                    onChanged: controller.togglePickDate,
                    activeColor: color,
                  )),
                ],
              )
            ],
          ),

          // ۳. مخفی یا ظاهر شدن نرمِ دکمه‌های انتخاب تاریخ
          Obx(() => AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.only(top:16),
              child: Row(
                spacing: AppDimens.small,
                children: [
                  DatePill(
                      title: 'امروز',
                      isSelected: _isToday(controller.dueDate.value),
                      onTap:  controller.setDateToday),
                  DatePill(
                      title: 'فردا',
                      isSelected: _isTomorrow(controller.dueDate.value),
                      onTap: controller.setDateTomorrow),
                  DatePill(
                      title: 'آخر هفته',
                      isSelected: controller.dueDate.value != null && !_isToday(controller.dueDate.value) && !_isTomorrow(controller.dueDate.value),
                      onTap: controller.setDateWeekend),
                  Expanded(
                    child: InkWell(
                      onTap: () => controller.pickDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit_calendar_rounded,
                                size: 14, color: AppColors.textMutedLight),
                            SizedBox(width: 4),
                            Text('تقویم',
                                style: TextStyle(
                                    fontSize: 12, color: AppColors.textMutedLight)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: controller.pickDateEnabled.value
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          )),
        ],
      ),
    );
  }
}

class DatePill extends StatelessWidget {
  const DatePill({super.key, required this.title, required this.isSelected, required this.onTap});

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // گرفتن رنگ از ویومدل فضای کاری
    final color = ThemeHelper.parsePrimaryColor(
        Get.find<CategoryWorkspaceViewModel>().category.value.theme);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200), // انیمیشن تغییر رنگ دکمه
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: isSelected ? color : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12)),
          child: Center(
              child: Text(title,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textMainLight))),
        ),
      ),
    );
  }
}