import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/task/repository/task_repository.dart';

import '../../../data/models/category_model.dart';
import '../../../data/models/todo_model.dart';
// import 'package:tikdone_app/data/models/todo_model.dart'; // مدل تسک‌های شما

class CategoryWorkspaceViewModel extends GetxController with StateMixin<List<TodoModel>> {
  late TaskRepository _taskRepository;
  TaskRepository get taskRepository => _taskRepository;
  CategoryWorkspaceViewModel() {
    _taskRepository = TaskRepository();
  }
  // استخراج تسک‌ها بر اساس فیلتر انتخاب شده
  final RxList<TodoModel> allTasks = <TodoModel>[].obs;

  List<TodoModel> get filteredTasks {
    if (activeFilter.value == 'in_progress') {
      // فقط تسک‌های ناتمام
      return allTasks.where((task) => !task.completed).toList();
    } else if (activeFilter.value == 'completed') {
      // فقط تسک‌های تمام‌شده
      return allTasks.where((task) => task.completed).toList();
    }
    // در غیر این صورت (حالت all)، همه را برگردان
    return allTasks;
  }
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



  void fetchCategoryTasks() async {
    change(null, status: RxStatus.loading());

    // درخواست به سرور با آیدی همین دسته‌بندی
    final result = await _taskRepository.getTasksByCategory(category.value.id);
    result.fold(
          (failure) {
        change(null, status: RxStatus.error(failure.message));
      },
          (tasks) {
        // ذخیره در لیست لوکال
        allTasks.assignAll(tasks);

        // مدیریت وضعیت UI بر اساس خالی بودن یا پر بودن لیست
        if (tasks.isEmpty) {
          change(tasks, status: RxStatus.empty());
        } else {
          change(tasks, status: RxStatus.success());
        }
      },
    );
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