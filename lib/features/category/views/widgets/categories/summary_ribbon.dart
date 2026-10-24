import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/category/view-model/categories_view_model.dart';
import '../../../../../core/values/colors.dart';

class SummaryRibbon extends GetView<CategoriesViewModel> {
  const SummaryRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ShadowColor.black,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),

      // ۱. مدیریت وضعیت لودینگ با controller.obx
      child: controller.obx(

        // حالت Success (زمانی که دیتا از سرور دریافت شده)
            (state) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.circle, size: 10, color: AppColors.primary),
                const SizedBox(width: 8),
                // ۲. استفاده از Obx داخلی فقط برای آپدیت اعداد
                // نکته: length به جای متغیر اضافی استفاده شد تا خطا ندهد
                Obx(() => Text(
                  '${controller.allCategories.length} دسته‌بندی فعال',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMainLight,
                  ),
                )),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.task_alt_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                // حذف .value چون totalActiveTasksCount یک Getter است
                Obx(() => Text(
                  '${controller.totalActiveTasksCount} تسک در جریان',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMutedLight,
                  ),
                )),
              ],
            ),
          ],
        ),

        // ۳. حالت Loading (زمانی که منتظر سرور هستیم)
        onLoading: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('درحال دریافت دسته‌ها...', style: TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
            Text('درحال محاسبه تسک‌ها...', style: TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
          ],
        ),
      ),
    );
  }
}