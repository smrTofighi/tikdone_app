import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/values/colors.dart';
import '../../../view-model/categories_view_model.dart';

class CategoryStateEmpty extends GetView<CategoriesViewModel> {
  const CategoryStateEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_off_rounded,
              size: 64, color: AppColors.primary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text('دسته‌بندی پیدا نشد',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMainLight)),
          const SizedBox(height: 8),
          const Text('با این فیلتر یا جستجو نتیجه‌ای یافت نشد.',
              style: TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              controller.updateSearch('');
              controller.setFilter('all');
            },
            child: const Text('نمایش همه دسته‌ها'),
          )
        ],
      ),
    );
  }
}
