import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/category/view-model/category_workspace_view_model.dart';

import '../../../../../core/values/colors.dart';

class WorkspaceFilters extends GetView<CategoryWorkspaceViewModel> {
  WorkspaceFilters({super.key});
  final filters = ['همه', 'در انتظار', 'تکمیل شده'];

  @override
  Widget build(BuildContext context) {
    final color = ThemeHelper.parsePrimaryColor(controller.category.value.theme);
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == 0; // متصل به Obx می‌شود
          return GestureDetector(
            
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? color : AppColors.cardLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filters[index],
                style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : AppColors.textMutedLight),
              ),
            ),
          );
        },
      ),
    );
  }
}
