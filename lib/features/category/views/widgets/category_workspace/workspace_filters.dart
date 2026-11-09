import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/category/view-model/category_workspace_view_model.dart';
// import 'package:tikdone_app/core/utils/theme_helper.dart';

import '../../../../../core/values/colors.dart';

class WorkspaceFilters extends GetView<CategoryWorkspaceViewModel> {
  WorkspaceFilters({super.key});

  final List<Map<String, String>> filters = [
    {'key': 'all', 'title': 'همه'},
    {'key': 'in_progress', 'title': 'در انتظار'},
    {'key': 'completed', 'title': 'تکمیل شده'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      // فقط یک Obx کل این بخش را مدیریت می‌کند
      child: Obx(() {
        // ۱. خواندن رنگ زنده از دسته‌بندی
        // چون category.value را اینجا می‌خوانیم، هر بار که دسته ویرایش شود این ویجت آپدیت می‌شود
        final categoryColor = ThemeHelper.parsePrimaryColor(controller.category.value.theme);
        
        // ۲. خواندن فیلترِ فعال
        final activeFilter = controller.activeFilter.value;

        return Row(
          children: filters.map((filter) {
            // بررسی انتخاب بودن بر اساس متغیری که بالا خواندیم
            final isSelected = activeFilter == filter['key'];

            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: GestureDetector(
                onTap: () => controller.activeFilter.value = filter['key']!,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // استفاده از رنگِ زنده دسته‌بندی
                    color: isSelected ? categoryColor : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected ? null : Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    filter['title']!, 
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : AppColors.textMutedLight
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}