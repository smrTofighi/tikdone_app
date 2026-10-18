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
                offset: const Offset(0, 2))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: AppColors.primary),
              SizedBox(width: 8),
              Obx(() {
                if (controller.status.isLoading) {
                  return const Text('درحال محاسبه',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMainLight));
                }
                return Text('${controller.totalCategories.value} دسته‌بندی فعال',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMainLight));
              })
            ],
          ),
          Row(
            children: [
              Icon(Icons.task_alt_rounded, size: 16, color: AppColors.primary),
              SizedBox(width: 4),
              Obx(() {
                if (controller.status.isLoading) {
                  return const Text('درحال محاسبه',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMainLight));
                }
                return Text('${controller.totalActiveTasksCount.value} تسک در جریان',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textMutedLight));
              })
            ],
          ),
        ],
      ),
    );
  }
}
