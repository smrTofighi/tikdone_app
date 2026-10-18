import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/category/view-model/category_workspace_view_model.dart';

import '../../../../../core/values/colors.dart';
import '../../../../../core/values/icons.dart';

class HeroCard extends GetView<CategoryWorkspaceViewModel> {
  const HeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cat = controller.category.value;
    final icon = AppIcons.getIconFromCode(cat.icon);
    final color = ThemeHelper.parsePrimaryColor(cat.theme);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardLight.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cat.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMainLight), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                        child: Text('${cat.activeTasks} تسک فعال', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // حلقه پیشرفت (Progress Ring)
          SizedBox(
            width: 64, height: 64,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 6,
                  color: AppColors.backgroundLight,
                ),
                CircularProgressIndicator(
                  value: cat.percentage, // از 0.0 تا 1.0
                  strokeWidth: 6,
                  color: color,
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${cat.progressPercent}٪', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
