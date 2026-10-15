import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/category/view-model/create_category_view_model.dart';
import 'package:tikdone_app/features/category/views/widgets/create_category/color_palette_section.dart';
import 'package:tikdone_app/features/category/views/widgets/create_category/create_category_header.dart';
import 'package:tikdone_app/features/category/views/widgets/create_category/dynamic_background_glow.dart';
import 'package:tikdone_app/features/category/views/widgets/create_category/list_preview_card.dart';
import 'package:tikdone_app/features/category/views/widgets/create_category/toggle_section.dart';
import 'package:tikdone_app/features/main/widgets/loading.dart';

class CreateCategoryPage extends StatelessWidget {
  CreateCategoryPage({super.key});

  final CreateCategoryViewModel createVM = Get.put(CreateCategoryViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          const DynamicBackgroundGlow(),
          SafeArea(
            child: Column(
              children: [
                CreateCategoryHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const LivePreviewCard(),
                        const SizedBox(height: 24),
                        const TitleInputSection(),
                        const SizedBox(height: 24),
                        const IconSelectorSection(),
                        const SizedBox(height: 24),
                        const ColorPaletteSection(),
                        const SizedBox(height: 24),
                        const TogglesSection(),
                        const SizedBox(height: 32),
                        _buildActionButtons(context),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final color =
              ThemeHelper.parsePrimaryColor(createVM.selectedTheme.value);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: createVM.isLoading.value
                    ? null
                    : () {
                        createVM.createCategory(context);
                      },
                child: createVM.isLoading.value
                    ? SizedBox(
                        width: double.infinity,
                        child: Center(child: Loading(color: Colors.white)))
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ایجاد و ذخیره دسته‌بندی',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.check_circle_rounded, color: Colors.white),
                        ],
                      ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ==========================================
// کامپوننت‌های مستقل
// ==========================================

class TitleInputSection extends StatelessWidget {
  const TitleInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateCategoryViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.edit_square, size: 18, color: AppColors.primary),
            SizedBox(width: 6),
            Text('نام دسته‌بندی',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMainLight)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.titleController,
          maxLength: 30,
          decoration: InputDecoration(
            hintText: 'مثلاً: پروژه‌های کاری، امور مالی...',
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            filled: true,
            fillColor: AppColors.backgroundLight,
            counterText: '', // مخفی کردن شمارنده دیفالت
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5)),
            suffixIcon:
                Obx(() => controller.categoryTitle.value != 'پروژه و اهداف جدید'
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () => controller.titleController.clear(),
                      )
                    : const SizedBox.shrink()),
          ),
        ),
      ],
    );
  }
}

class IconSelectorSection extends StatelessWidget {
  const IconSelectorSection({super.key});

  // لیست آیکون‌های در دسترس
  final List<IconData> icons = const [
    Icons.folder_rounded,
    Icons.work_rounded,
    Icons.shopping_basket_rounded,
    Icons.favorite_rounded,
    Icons.fitness_center_rounded,
    Icons.menu_book_rounded,
    Icons.account_balance_wallet_rounded,
    Icons.terminal_rounded,
    Icons.cottage_rounded,
    Icons.flight_takeoff_rounded,
    Icons.headphones_rounded,
    Icons.lightbulb_rounded
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateCategoryViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('انتخاب نماد و آیکون',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textMainLight)),
        const Text('نماد مرتبط با ماهیت کارهایتان را لمس کنید',
            style: TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: icons.map((icon) {
            return Obx(() {
              final isSelected = controller.selectedIcon.value == icon;
              return GestureDetector(
                onTap: () => controller.selectedIcon.value = icon,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: AnimatedScale(
                    scale: isSelected ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(icon,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textMutedLight,
                        size: 24),
                  ),
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }
}
