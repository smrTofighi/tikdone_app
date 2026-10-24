import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/values/colors.dart';
import '../../../view-model/categories_view_model.dart';

class FilterPills extends GetView<CategoriesViewModel> {
  FilterPills({super.key});

  final filters = [
    {'key': 'all', 'label': 'همه'},
    {'key': 'active', 'label': 'دارای تسک فعال'},
    {'key': 'high-priority', 'label': 'پراولویت'},
    {'key': 'completed', 'label': 'تکمیل‌شده'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          return Obx(() {
            final isActive = controller.activeFilter.value == filter['key'];
            return GestureDetector(
              onTap: () => controller.setFilter(filter['key']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      isActive ? AppColors.primary : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(20),
                  border:
                      isActive ? null : Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  filter['label']!,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                      color:
                          isActive ? Colors.white : AppColors.textMutedLight),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
