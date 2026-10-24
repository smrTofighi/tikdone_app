import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/values/colors.dart';
import '../../../../category/view-model/category_workspace_view_model.dart';
import '../../../view_model/create_task_view_model.dart';

class CreateTaskButtonActions extends GetView<CreateTaskViewModel> {
  const CreateTaskButtonActions({super.key});

  @override
  Widget build(BuildContext context) {
    final color = ThemeHelper.parsePrimaryColor(
        Get.find<CategoryWorkspaceViewModel>().category.value.theme);
    return Column(
      children: [
        Obx(() => InkWell(
          onTap: controller.isLoading.value
              ? null
              : () => controller.saveTask(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                color,
                color.withAlpha(50)
              ]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8))
              ],
            ),
            child: Center(
              child: controller.isLoading.value
                  ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 3))
                  : GestureDetector(
                onTap: () => controller.saveTask(),
                child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                    Icon(Icons.task_alt_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Text('ثبت و ذخیره تسک',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                                    ],
                                  ),
                  ),
            ),
          ),
        )),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close_rounded, color: Colors.grey),
          label: const Text('انصراف', style: TextStyle(color: Colors.grey)),
        )
      ],
    );
  }
}
