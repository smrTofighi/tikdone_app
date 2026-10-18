import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/values/colors.dart';
import '../../../../../core/values/dimens.dart';
import '../../../view-model/category_workspace_view_model.dart';

class QuickAddTask extends GetView<CategoryWorkspaceViewModel> {
  const QuickAddTask({super.key});

  @override
  Widget build(BuildContext context) {
    final color =
        ThemeHelper.parsePrimaryColor(controller.category.value.theme);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        spacing: AppDimens.small,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(14)),
            child: Icon(Icons.add_task_rounded, color: color, size: 20),
          ),
          Expanded(
            child: TextField(
              controller: controller.taskController,
              decoration: const InputDecoration(
                hintText: 'افزودن سریع تسک...',
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => controller.quickAddTask(),
            ),
          ),
          InkWell(
            onTap: controller.quickAddTask,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.8)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.send_rounded, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
