import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:todo_infinity_app/core/values/colors.dart';
import 'package:todo_infinity_app/core/values/strings.dart';
import 'package:todo_infinity_app/features/main/widgets/loading.dart';
import 'package:todo_infinity_app/features/main/main_category/views/widgets/catogry_card.dart';
import '../../view_model/main_category_view_model.dart';

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
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8), // پدینگ کلی برای گرید
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85, // تناسب بهتر برای کارت‌ها
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return LongPressDraggable(
                    data: index,
                    feedback: Opacity(
                      opacity: 0.8,
                      child: Material(
                        // برای جلوگیری از خطای Hero در Drag
                        color: Colors.transparent,
                        child: CategoryCard(
                          title: vm.model.categoryList[index].title,
                          index: index,
                          iconIndex: vm.model.categoryList[index].iconIndex,
                          colorIndex: vm.model.categoryList[index].colorIndex,
                          totalTodos: vm.model.categoryList[index].totalTodos,
                          percentage: vm.model.categoryList[index].percentage,
                          completedTodos:
                              vm.model.categoryList[index].completedTodos,
                          onTap: () {},
                        ),
                      ),
                    ),
                    onDragStarted: () => categoryVM.changeDeleting(true),
                    onDraggableCanceled: (_, __) =>
                        categoryVM.changeDeleting(false),
                    onDragEnd: (_) {
                      categoryVM.changeDeleting(false);
                      categoryVM.deleteCategory(
                          vm.model.categoryList[index].id, index, context);
                    },
                    child: CategoryCard(
                      title: vm.model.categoryList[index].title,
                      index: index,
                      iconIndex: vm.model.categoryList[index].iconIndex,
                      colorIndex: vm.model.categoryList[index].colorIndex,
                      totalTodos: vm.model.categoryList[index].totalTodos,
                      percentage: vm.model.categoryList[index].percentage,
                      completedTodos:
                          vm.model.categoryList[index].completedTodos,
                      onTap: () {
                        vm.goToTaskListPage(vm.model.categoryList[index]);
                      },
                    ),
                  )
                      // افکت آبشاری ظاهر شدن کارت‌ها
                      .animate(delay: (index * 100).ms)
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
