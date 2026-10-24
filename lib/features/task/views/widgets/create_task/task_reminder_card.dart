import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/task/view_model/create_task_view_model.dart';
// import 'package:tikdone_app/core/utils/theme_helper.dart';

import '../../../../../core/values/colors.dart';
import '../../../../category/view-model/category_workspace_view_model.dart';

class TaskReminderCard extends GetView<CreateTaskViewModel> {
  const TaskReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    // دریافت رنگ اختصاصی دسته‌بندی
    final color = ThemeHelper.parsePrimaryColor(
        Get.find<CategoryWorkspaceViewModel>().category.value.theme);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.cardLight, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.notifications_active_rounded,
                      size: 18, color: Colors.amber),
                  SizedBox(width: 6),
                  Text('یادآور هوشمند',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMainLight)),
                ],
              ),
              Obx(() => Switch(
                value: controller.reminderEnabled.value,
                onChanged: controller.toggleReminder,
                activeColor: color, // هماهنگی رنگ سوییچ با تم
              )),
            ],
          ),

          // استفاده از AnimatedCrossFade برای باز و بسته شدن نرم
          Obx(() {
            final presets = [
              {'key': 'on_time', 'label': 'در زمان سررسید'},
              {'key': '10m', 'label': '۱۰ دقیقه قبل'},
              {'key': '30m', 'label': '۳۰ دقیقه قبل'},
            ];

            return AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity, height: 0),
              secondChild: Padding(
                padding: const EdgeInsets.only(top:12),
                child: SingleChildScrollView( // برای جلوگیری از بیرون زدن در گوشی‌های کوچک
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    // جایگزین ListView با Row و map
                    children: presets.map((item) {
                      final isSelected = controller.reminderPreset.value == item['key'];

                      return Padding(
                        padding: const EdgeInsets.only(left: 8), // فاصله بین آیتم‌ها
                        child: InkWell(
                          onTap: () => controller.selectReminderPreset(item['key']!),
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.amber.withValues(alpha: 0.15)
                                  : AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item['label']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? Colors.amber.shade700
                                    : AppColors.textMainLight,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              crossFadeState: controller.reminderEnabled.value
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            );
          }),
        ],
      ),
    );
  }
}