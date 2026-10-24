import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/category/view-model/categories_view_model.dart';
import 'package:tikdone_app/features/category/views/widgets/categories/categories_appbar.dart';
import 'package:tikdone_app/features/category/views/widgets/categories/categories_searchbar.dart';
import 'package:tikdone_app/features/category/views/widgets/categories/category_card.dart';
import 'package:tikdone_app/features/main/widgets/loading.dart';

import '../widgets/categories/category_state_empty.dart';
import '../widgets/categories/summary_ribbon.dart';
import '../widgets/categories/filter_pills.dart';

class CategoriesPage extends GetView<CategoriesViewModel> {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          CategoriesAppBar(),
          SummaryRibbon(),
          const SizedBox(height: 16),
          CategoriesSearchBar(),
          const SizedBox(height: 12),
          FilterPills(),
          const SizedBox(height: 16),
          Expanded(
            child: controller.obx(
              (state) {
                return Obx(() {
                  final list = controller.filteredCategories;
                  if (list.isEmpty) {
                    return CategoryStateEmpty();
                  }
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(
                          category: list[index]);
                    },
                  );
                });
              },
              onLoading: const Loading(color: AppColors.primary),
              onError: (errorText) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(errorText ?? 'خطای نامشخص'),
                    ElevatedButton(
                      onPressed: () => controller.fetchCategories(),
                      child: const Text('تلاش مجدد'),
                    )
                  ],
                ),
              ),

              // حالت چهارم: Empty - زمانی که دیتابیس کلاً خالی است
              onEmpty: CategoryStateEmpty(),
            ),
          ),
        ],
      ),
    );
  }
}
