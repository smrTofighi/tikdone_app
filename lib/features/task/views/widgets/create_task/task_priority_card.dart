import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/dimens.dart';

import '../../../../../core/values/colors.dart';
import '../../../view_model/create_task_view_model.dart';

class TaskPriorityCard extends GetView<CreateTaskViewModel> {
  const TaskPriorityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.cardLight, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.flag_rounded, size: 18, color: Colors.red),
              SizedBox(width: 6),
              Text('سطح اولویت',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMainLight)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            spacing: AppDimens.small,
            children: [
              PriorityPill(level: 1, title: 'فوری', color: Colors.red, icon: Icons.keyboard_double_arrow_up_rounded),
              PriorityPill(level: 2, title: 'معمولی', color: Colors.blue, icon: Icons.drag_handle_rounded),
              PriorityPill(level: 3, title: 'کم‌اهمیت', color: Colors.grey, icon: Icons.keyboard_double_arrow_down_rounded),
            ],
          )
        ],
      ),
    );
  }
}

class PriorityPill extends GetView<CreateTaskViewModel> {
  const PriorityPill({super.key, required this.level, required this.title, required this.color, required this.icon});

  final int level;
  final String title;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.priorityLevel.value == level;
        return InkWell(
          onTap: () => controller.selectPriority(level),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.1)
                  : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: color.withValues(alpha: 0.5))
                  : Border.all(color: Colors.transparent),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 14, color: isSelected ? color : Colors.grey),
                const SizedBox(width: 4),
                Text(title,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? color : AppColors.textMutedLight)),
              ],
            ),
          ),
        );
      }),
    );
  }
}
