import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/category/view-model/category_workspace_view_model.dart';

import '../../../../../core/values/colors.dart';
import '../../../../../core/values/icons.dart';

class HeroCard extends GetView<CategoryWorkspaceViewModel> {
  const HeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cat = controller
          .category; // اصلاح: value باید قبل از متغیرها خوانده شود
      final icon = AppIcons.getIconFromCode(cat.value.icon);
      final color = ThemeHelper.parsePrimaryColor(cat.value.theme);

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardLight.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16)),
                    child: Icon(icon, color: color, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cat.value.title,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMainLight),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text('${cat.value.activeTasks} تسک فعال',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: color)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // =====================================
            // حلقه پیشرفت انیمیشنی (Animated Progress Ring)
            // =====================================
            SizedBox(
              width: 64,
              height: 64,
              // TweenAnimationBuilder انیمیشن را به صورت خودکار مدیریت می‌کند
              child: TweenAnimationBuilder<double>(
                // تغییرات از 0.0 شروع می‌شود و به درصد فعلی ختم می‌شود
                tween: Tween<double>(begin: 0.0, end: cat.value.percentage),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic, // یک افکت نرم و استاندارد
                builder: (context, animatedValue, child) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      // دایره پس‌زمینه (طوسی/خالی)
                      const CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 6,
                        color: AppColors.backgroundLight,
                      ),
                      // دایره اصلی که پر می‌شود (متحرک)
                      CircularProgressIndicator(
                        value:
                            animatedValue, // استفاده از مقدار انیمیشن به جای مقدار ثابت
                        strokeWidth: 6,
                        color: color,
                        strokeCap: StrokeCap.round,
                      ),
                      // عدد درصد که هماهنگ با دایره تغییر می‌کند
                      Center(
                        child: Text(
                          '${(animatedValue * 100).toInt()}٪',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMainLight,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
