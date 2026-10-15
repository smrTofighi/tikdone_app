import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/core/values/icons.dart';
import 'package:tikdone_app/features/category/view-model/categories_view_model.dart';
import 'package:tikdone_app/features/category/views/widgets/categories/category_card.dart';
// فرض می‌کنیم ThemeHelper و AppIcons را ایمپورت کرده‌اید
// import 'package:tikdone_app/core/utils/theme_helper.dart';
// import 'package:tikdone_app/core/utils/app_icons.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({super.key});

  final CategoriesViewModel controller = Get.put(CategoriesViewModel());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          _buildSummaryRibbon(),
          const SizedBox(height: 16),
          _buildSearchBar(),
          const SizedBox(height: 12),
          _buildFilterPills(),
          const SizedBox(height: 16),
          // لیست کارت‌ها
          Expanded(
            child: Obx(() {
              final list = controller.filteredCategories.obs;

              if (list.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 100), // فاصله برای باتم‌نویگیشن
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) =>
                    CategoryCard(category: list[index]),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('دسته‌بندی‌های من',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMainLight)),
              Text('مدیریت فضاها، کارها و روتین‌ها',
                  style:
                      TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
            ],
          ),
          InkWell(
            onTap: () {}, // TODO: انتقال به صفحه CreateCategoryPage
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20)),
              child: const Row(
                children: [
                  Icon(Icons.add_circle_outline_rounded,
                      color: AppColors.primary, size: 20),
                  SizedBox(width: 4),
                  Text('دسته جدید',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummaryRibbon() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: ShadowColor.black,
                blurRadius: 4,
                offset: const Offset(0, 2))
          ]),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: AppColors.primary),
              SizedBox(width: 8),
              Text('۶ دسته‌بندی فعال',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMainLight)),
            ],
          ),
          Row(
            children: [
              Icon(Icons.task_alt_rounded, size: 16, color: AppColors.primary),
              SizedBox(width: 4),
              Text('۲۱ تسک در جریان',
                  style:
                      TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: controller.updateSearch,
        decoration: InputDecoration(
          hintText: 'جستجو در بین دسته‌بندی‌ها...',
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
          filled: true,
          fillColor: AppColors.cardLight,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildFilterPills() {
    final filters = [
      {'key': 'all', 'label': 'همه'},
      {'key': 'active', 'label': 'دارای تسک فعال'},
      {'key': 'high-priority', 'label': 'پراولویت'},
      {'key': 'completed', 'label': 'تکمیل‌شده'},
    ];

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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_off_rounded,
              size: 64, color: AppColors.primary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text('دسته‌بندی پیدا نشد',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMainLight)),
          const SizedBox(height: 8),
          const Text('با این فیلتر یا جستجو نتیجه‌ای یافت نشد.',
              style: TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              controller.updateSearch('');
              controller.setFilter('all');
            },
            child: const Text('نمایش همه دسته‌ها'),
          )
        ],
      ),
    );
  }
}


