import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/category_model.dart';
// import 'package:tikdone_app/data/models/todo_model.dart'; // مدل تسک‌های شما

class CategoryWorkspaceViewModel extends GetxController with StateMixin<List<dynamic>> {
  // گرفتن اطلاعات دسته‌بندی از صفحه‌ی لیست دسته‌ها
  late Rx<CategoryModel> category;

  final taskController = TextEditingController();
  final activeFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    // دریافت دیتای پاس داده شده از صفحه قبل
    final CategoryModel args = Get.arguments;
    category = args.obs;

    fetchCategoryTasks();
  }

  void fetchCategoryTasks() {
    change(null, status: RxStatus.loading());

    // TODO: اینجا باید ریکوئست به دیتابیس بزنید تا تسک‌های مربوط به category.value.id را بگیرید
    // فعلاً برای تست UI یک لیست خالیِ موفق (یا چند دیتای تستی) برمی‌گردانیم
    Future.delayed(const Duration(milliseconds: 500), () {
      final mockTasks = [
        {'id': '1', 'title': 'طراحی پیش‌نمایش اتاق کار', 'completed': false},
        {'id': '2', 'title': 'ارسال گزارش مالی', 'completed': true},
      ];
      change(mockTasks, status: RxStatus.success());
    });
  }

  void quickAddTask() {
    final title = taskController.text.trim();
    if (title.isEmpty) return;

    // TODO: ارسال به Appwrite و سپس آپدیت لوکال لیست
    taskController.clear();
    Get.snackbar('موفق', 'تسک جدید به ${category.value.title} اضافه شد');
  }

  void deleteCategory() {
    // TODO: نمایش دیالوگ تایید و سپس حذف از Appwrite و بازگشت به صفحه قبل
    Get.back();
  }

  @override
  void onClose() {
    taskController.dispose();
    super.onClose();
  }
}