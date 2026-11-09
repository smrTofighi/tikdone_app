import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/routes/pages.dart';
import 'package:tikdone_app/features/category/view-model/category_workspace_view_model.dart';

import '../../../../../core/values/colors.dart';

class WorkspaceAppBar extends GetView<CategoryWorkspaceViewModel> {
  const WorkspaceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded,
                    color: AppColors.textMainLight),
                onPressed: () => Get.back(),
              ),
              Obx(
                () =>  Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.cardLight.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: ThemeHelper.parsePrimaryColor(controller.category.value.theme)),
                      const SizedBox(width: 6),
                      const Text('فضای اختصاصی',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMutedLight)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // منوی ویرایش و حذف
          Obx(
            () =>  PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded, color: ThemeHelper.parsePrimaryColor(controller.category.value.theme)),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onSelected: (value) {
                if (value == 'edit') {
                  Get.toNamed(AppPages.createCategory,
                      arguments: controller.category.value);
                } else if (value == 'delete') {
                  controller.deleteCategory();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: 'edit',
                    child: Row(children: [
                      Icon(Icons.edit_rounded, size: 20),
                      SizedBox(width: 8),
                      Text('ویرایش دسته')
                    ])),
                const PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      Icon(Icons.delete_rounded, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('حذف دسته', style: TextStyle(color: Colors.red))
                    ])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
