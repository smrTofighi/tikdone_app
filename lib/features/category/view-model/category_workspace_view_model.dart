import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/task/repository/task_repository.dart';

import '../../../data/models/category_model.dart';
import '../../../data/models/todo_model.dart';
// import 'package:tikdone_app/data/models/todo_model.dart'; // مدل تسک‌های شما

class CategoryWorkspaceViewModel extends GetxController
    with StateMixin<List<TodoModel>> {
  late TaskRepository _taskRepository;
  TaskRepository get taskRepository => _taskRepository;
  CategoryWorkspaceViewModel() {
    _taskRepository = TaskRepository();
  }
  // استخراج تسک‌ها بر اساس فیلتر انتخاب شده
  final RxList<TodoModel> allTasks = <TodoModel>[].obs;

  // استخراج تسک‌ها بر اساس فیلتر انتخاب شده همراه با مرتب‌سازی هوشمند
  List<TodoModel> get filteredTasks {
    List<TodoModel> result;

    if (activeFilter.value == 'in_progress') {
      // فقط تسک‌های ناتمام
      result = allTasks.where((task) => !task.completed).toList();
    } else if (activeFilter.value == 'completed') {
      // فقط تسک‌های تمام‌شده
      result = allTasks.where((task) => task.completed).toList();
    } else {
      // حالت 'all' (همه موارد)
      result = allTasks.toList();
    }

    // بخش جادویی: مرتب‌سازی لیست در کسری از ثانیه
    result.sort((a, b) {
      if (!a.completed && b.completed) {
        return -1; // اگر a فعال و b تکمیل شده است، a باید بیاید بالاتر
      }
      if (a.completed && !b.completed) {
        return 1; // اگر a تکمیل و b فعال است، a باید برود پایین‌تر
      }
      return 0; // اگر وضعیت هر دو یکی است، تغییری در ترتیبشان نده
    });

    return result;
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

// تغییر وضعیت تسک (Optimistic Update)
  void toggleTaskStatus(TodoModel task) async {
    // ۱. ذخیره وضعیت قبلی برای حالت خطا (Rollback)
    final bool originalStatus = task.completed;

    // ۲. تغییر خوش‌بینانه در استیتِ لوکال
    task.completed = !originalStatus;

    // ۳. جابجایی تسک بین لیست‌ها و آپدیت عدد پیشرفت
    category.update((val) {
      if (val == null) return;

      // اطمینان از مقداردهی اولیه لیست‌ها
      val.activeTodos ??= [];
      val.unActiveTodos ??= [];

      if (task.completed) {
        // تسک تیک خورده: از لیست فعال حذف، به غیرفعال (تکمیل‌شده) اضافه
        val.activeTodos!.removeWhere((element) => element.id == task.id);
        val.unActiveTodos!.add(task);
        // آپدیت شمارنده
        val.completedTodos += 1;
      } else {
        // تیک تسک برداشته شده: از غیرفعال حذف، به فعال اضافه
        val.unActiveTodos!.removeWhere((element) => element.id == task.id);
        val.activeTodos!.add(task);
        // آپدیت شمارنده
        val.completedTodos =
            (val.completedTodos > 0) ? val.completedTodos - 1 : 0;
      }
    });

    // ۴. اعمال تغییرات در لیست تسک‌ها به صورت آنی
    allTasks.refresh();

    // ۵. ارسال درخواست واقعی به سرور در پس‌زمینه
    final result = await _taskRepository.updateCompleted(
      id: task.id,
      completed: task.completed,
    );

    // ۶. بررسی نتیجه سرور
    result.fold(
      (failure) {
        // اگر سرور خطا داد (اینترنت قطع بود)، تغییرات را برمی‌گردانیم (Rollback)
        task.completed = originalStatus;

        category.update((val) {
          if (val == null) return;
          val.activeTodos ??= [];
          val.unActiveTodos ??= [];

          if (originalStatus) {
            // در واقع تسک تکمیل‌شده بود، پس برش می‌گردونیم
            val.activeTodos!.removeWhere((element) => element.id == task.id);
            val.unActiveTodos!.add(task);
            val.completedTodos += 1;
          } else {
            // در واقع تسک فعال بود
            val.unActiveTodos!.removeWhere((element) => element.id == task.id);
            val.activeTodos!.add(task);
            val.completedTodos =
                (val.completedTodos > 0) ? val.completedTodos - 1 : 0;
          }
        });

        allTasks.refresh();

        // نمایش اخطار به کاربر
        Get.snackbar(
          'خطا در ارتباط',
          'وضعیت تسک در سرور ذخیره نشد. لطفاً اینترنت را بررسی کنید.',
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (success) {
        // موفقیت‌آمیز بود
      },
    );
  }

  void addTodoLocal(TodoModel newTodo) {
    category.update((val) {
      if (val == null) return;

      val.activeTodos ??= [];

      // ۱. اضافه کردن به لیست فعال‌های این دسته
      val.activeTodos!.insert(0, newTodo);

      // ۲. اضافه شدن به تعداد کل (باعث افتِ طبیعیِ درصد پیشرفت میشه چون کار جدید اضافه شده)
      val.totalTodos += 1;
    });

    // ۳. اضافه کردن به لیست اصلی برای رندر شدن در UI
    allTasks.insert(0, newTodo);
  }

  // آپدیت زنده تسکِ ویرایش شده در رابط کاربری
  void updateTodoLocal(TodoModel updatedTask) {
    // ۱. آپدیت در لیست اصلی (برای رندر شدن سریع در UI)
    final index = allTasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      allTasks[index] = updatedTask;
      allTasks.refresh();
    }

    // ۲. آپدیت در لیست‌های دسته‌بندی برای حفظ یکپارچگی اطلاعات
    category.update((val) {
      if (val == null) return;
      if (updatedTask.completed) {
        final i =
            val.unActiveTodos?.indexWhere((t) => t.id == updatedTask.id) ?? -1;
        if (i != -1) val.unActiveTodos![i] = updatedTask;
      } else {
        final i =
            val.activeTodos?.indexWhere((t) => t.id == updatedTask.id) ?? -1;
        if (i != -1) val.activeTodos![i] = updatedTask;
      }
    });
  }
}
