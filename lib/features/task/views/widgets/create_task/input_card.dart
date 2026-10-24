import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/task/view_model/create_task_view_model.dart';
import '../../../../../core/values/colors.dart';
import '../../../../category/view-model/category_workspace_view_model.dart';

class InputCard extends GetView<CreateTaskViewModel> {
  const InputCard({super.key});

  @override
  Widget build(BuildContext context) {
    // دریافت رنگ اختصاصی دسته‌بندی
    final color = ThemeHelper.parsePrimaryColor(
        Get.find<CategoryWorkspaceViewModel>().category.value.theme);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // ۱. سایه کارت را هم یک هاله خیلی کمرنگ از رنگ دسته‌بندی دادیم!
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: controller.titleController,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textMainLight),
            cursorColor: color, // ۲. رنگ نشانگر چشمک‌زن تایپ
            decoration: InputDecoration(
              hintText: 'عنوان کار؛ مثلاً بازبینی قرارداد...',
              hintStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey),
              // ۳. وقتی روی فیلد کلیک شد، یک خط زیرین با رنگ دسته نمایش داده شود
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: color, width: 1.5),
              ),
              // بوردر دور تا دور کاملاً شفاف در حالت عادی
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // =====================================
          // فیلد دوم: توضیحات
          // =====================================
          TextField(
            controller: controller.descController,
            maxLines: 3,
            style: const TextStyle(fontSize: 13, color: AppColors.textMainLight),
            cursorColor: color,
            decoration: InputDecoration(
              hintText: 'توضیحات و جزییات، پیوندها یا یادداشت‌ها...',
              hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
              filled: true,
              fillColor: AppColors.backgroundLight.withValues(alpha: 0.5),
              contentPadding: const EdgeInsets.all(12),
              // ۴. بوردر دور تا دور با رنگ دسته در زمان فوکوس
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: color, width: 1.5),
              ),
              // بوردر دور تا دور کاملاً شفاف در حالت عادی
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}