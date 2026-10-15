import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/core/values/strings.dart';
import 'package:tikdone_app/features/main/widgets/loading.dart';
import 'package:tikdone_app/features/main/main_category/views/widgets/catogry_card.dart';
import '../../../../category/view-model/main_category_view_model.dart';

// ignore: must_be_immutable
class MainCategoryPage extends StatelessWidget {
  const MainCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const CategoriesText(),
          Obx(
            () => Get.find<MainCategoryViewModel>().isLoading.value
                ? const Center(
                    child: Loading(
                      color: AppColors.primary,
                      size: 50,
                    ),
                  )
                : CategoryList(),
          )
        ],
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  CategoryList({
    super.key,
  });

  final MainCategoryViewModel categoryVM = Get.find<MainCategoryViewModel>();

  @override
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GetBuilder<MainCategoryViewModel>(
      builder: (vm) => SizedBox(
        width: Get.width,
        child: vm.model.categoryList.isEmpty
            ? SizedBox(
                width: size.width,
                height: size.height * 0.75,
                child: const Center(
                  child: Text(
                    'هنوز دسته‌بندی ساخته نشده است',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            : GridView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: vm.model.categoryList.length,
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final category = vm.model.categoryList[index];

                  return CategoryCard(
                    title: category.title,
                    index: index,
                    icon: category.icon,
                    theme: category.theme,
                    totalTodos: category.totalTodos,
                    percentage: category.percentage,
                    completedTodos: category.completedTodos,
                    onTap: () => vm.goToTaskListPage(category),
                    onEdit: () {
                      // باز کردن همان باتم‌شیت ساخت، ولی در حالت ویرایش با مقادیر فعلی
                    },
                    onDelete: () {
                      showDeleteCategoryDialog(
                        context,
                        category.id,
                        category.title,
                        category.totalTodos,
                        index,
                      );
                    },
                  )
                      .animate(delay: (index * 80).ms)
                      .fade(duration: 400.ms)
                      .scale(
                          begin: const Offset(0.9, 0.9),
                          curve: Curves.easeOutBack);
                },
              ),
      ),
    );
  }
}

class CategoriesText extends StatelessWidget {
  const CategoriesText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 12, 16, 12),
        child: Text(
          PersianStrings.categories,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
        ),
      ),
    );
  }
}

void showDeleteCategoryDialog(
  BuildContext context,
  String categoryId,
  String categoryTitle,
  int totalTodos,
  int index,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final categoryVM = Get.find<MainCategoryViewModel>();

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_forever_rounded,
              size: 36,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'حذف دسته‌بندی «$categoryTitle»؟',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            totalTodos > 0
                ? 'با حذف این دسته‌بندی، تمامی $totalTodos مأموریت داخل آن نیز پاک خواهند شد.'
                : 'آیا از حذف این دسته‌بندی اطمینان دارید؟',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white60 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text('انصراف'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Get.back();
                    categoryVM.deleteCategory(categoryId, index, context);
                  },
                  child: const Text('حذف شود'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
