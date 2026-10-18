import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/category/view-model/category_workspace_view_model.dart';

import '../../../../../core/values/colors.dart';

class WorkspaceAppBar extends GetView<CategoryWorkspaceViewModel> {
  const WorkspaceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final color = ThemeHelper.parsePrimaryColor(controller.category.value.theme);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textMainLight),
                onPressed: () => Get.back(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.cardLight.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: color),
                    const SizedBox(width: 6),
                    const Text('فضای اختصاصی', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMutedLight)),
                  ],
                ),
              ),
            ],
          ),
          // منوی ویرایش و حذف
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: color),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onSelected: (value) {
              if (value == 'edit') {
                // TODO: رفتن به صفحه ویرایش
              } else if (value == 'delete') {
                controller.deleteCategory();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_rounded, size: 20), SizedBox(width: 8), Text('ویرایش دسته')])),
              const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_rounded, size: 20, color: Colors.red), SizedBox(width: 8), Text('حذف دسته', style: TextStyle(color: Colors.red))])),
            ],
          ),
        ],
      ),
    );
  }
}
