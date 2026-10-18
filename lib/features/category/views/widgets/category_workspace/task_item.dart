import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/category/view-model/category_workspace_view_model.dart';

import '../../../../../core/values/colors.dart';

class TaskItem extends GetView<CategoryWorkspaceViewModel> {
  const TaskItem({super.key, required this.task});
  final Map<String, dynamic> task;
  @override
  Widget build(BuildContext context) {
    final completed = task['completed'] == true;
    final color = ThemeHelper.parsePrimaryColor(controller.category.value.theme);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardLight.withValues(alpha: completed ? 0.0 : 1.0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {}, // تغییر وضعیت تسک
            child: Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: completed ? color : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8),
                border: completed ? null : Border.all(color: Colors.grey.shade300),
              ),
              child: completed ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task['title'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: completed ? FontWeight.normal : FontWeight.bold,
                color: completed ? AppColors.textMutedLight : AppColors.textMainLight,
                decoration: completed ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: 20, color: Colors.grey),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
