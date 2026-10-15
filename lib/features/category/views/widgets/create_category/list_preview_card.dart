import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/category/view-model/create_category_view_model.dart';

class LivePreviewCard extends StatelessWidget {
  const LivePreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateCategoryViewModel>();

    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('پیش‌نمایش زنده کارت',
                style:
                    TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          final color =
              ThemeHelper.parsePrimaryColor(controller.selectedTheme.value);
          final icon = controller.selectedIcon.value;
          final title = controller.categoryTitle.value;

          return Container(
            // پدینگ از اینجا حذف شد تا Stack کل فضا را پر کند
            clipBehavior: Clip
                .hardEdge, // برای جلوگیری از بیرون زدن هاله و نوار از گوشه‌های گرد
            decoration: BoxDecoration(
              color: AppColors.cardLight,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Stack(
              children: [
                // هاله رنگی (حالا لبه‌به‌لبه‌ی کارت می‌چسبد)
                Positioned(
                  top: -20,
                  left: -20,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 120, // کمی بزرگتر برای پوشش بهتر لبه‌ها
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withValues(alpha: 0.25), // شفافیت کمی بیشتر شد
                      ),
                    ),
                  ),
                ),

                // نوار کناری رنگی
                Positioned(
                  top: 0,
                  right: 0, // به لبه راست چسبید (چون پدینگ حذف شده)
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 4,
                    color: color,
                  ),
                ),

                // محتوای اصلی (پدینگ به اینجا منتقل شد)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(icon, color: color, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textMainLight),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle)),
                                    const SizedBox(width: 4),
                                    const Text('۰ تسک فعال',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textMutedLight)),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              color: AppColors.textMutedLight),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // مینی پروگرس‌بار
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('میزان پیشرفت',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMutedLight)),
                          Text('۰٪',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textMainLight)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 20, // عرض دمو
                            height: 6,
                            decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
