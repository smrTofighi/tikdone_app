import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/task/repository/task_repository.dart';

import '../../../data/models/category_model.dart';
import '../../../data/models/todo_model.dart';
import '../../category/view-model/category_workspace_view_model.dart';
// import 'package:tikdone_app/features/category/view-model/categories_view_model.dart';

class CreateTaskViewModel extends GetxController {
  late TaskRepository _taskRepository;
  TaskRepository get taskRepository => _taskRepository;
  CreateTaskViewModel(){
    _taskRepository = TaskRepository();
  }
  final titleController = TextEditingController();
  final descController = TextEditingController();

  final RxString selectedCategoryId = ''.obs;
  final Rx<DateTime?> dueDate = Rx<DateTime?>(null);

  final RxBool pickDateEnabled = false.obs;

  final RxBool reminderEnabled = false.obs;
  final RxString reminderPreset = 'on_time'.obs; // on_time, 10m, 30m, 1h

  final RxInt priorityLevel = 0.obs;

  final RxBool isLoading = false.obs;

  final RxList<CategoryModel> availableCategories = <CategoryModel>[].obs;


  void selectCategory(String id) => selectedCategoryId.value = id;
  void selectPriority(int level) => priorityLevel.value = level;
  void toggleReminder(bool val) {
    if (val && (!pickDateEnabled.value || dueDate.value == null)) {
      // اگر کاربر خواست یادآور رو روشن کنه ولی تاریخی نبود، جلوش رو می‌گیریم
      Get.snackbar(
          'توجه',
          'برای تنظیم یادآور، ابتدا باید "موعد انجام تسک" را فعال کنید.',
          backgroundColor: Colors.orange.withValues(alpha: 0.9),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16)
      );
      return; // توقف عملیات، سوییچ روشن نمیشه
    }
    reminderEnabled.value = val;
  }
  void selectReminderPreset(String preset) => reminderPreset.value = preset;
  void togglePickDate(bool val) {
    pickDateEnabled.value = val;
    if (val) {
      if (dueDate.value == null) setDateToday();
    } else {
      toggleReminder(false);
      clearDate();
    }
  }  // تنظیم روی امروز
  void setDateToday() {
    final now = DateTime.now();
    dueDate.value = DateTime(now.year, now.month, now.day, 23, 59);
  }

  // تنظیم روی فردا (ساعت ۰۹:۰۰ صبح)
  void setDateTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    dueDate.value = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0);
  }

  // تنظیم روی آخر هفته (جمعه ساعت ۰۹:۰۰ صبح)
  void setDateWeekend() {
    final now = DateTime.now();
    int daysToFriday = DateTime.friday - now.weekday;
    if (daysToFriday <= 0) daysToFriday += 7;

    final friday = now.add(Duration(days: daysToFriday));
    dueDate.value = DateTime(friday.year, friday.month, friday.day, 9, 0);
  }
  void clearDate() {
    dueDate.value = null;
    reminderEnabled.value = false; // اگر تاریخی نیست، یادآور هم بی‌معنی است
  }
  Future<void> pickDate(BuildContext context) async {
    // ۱. اول تاریخ را می‌گیریم
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      // ۲. اگر تاریخ انتخاب شد، بلافاصله ساعت را می‌پرسیم
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        confirmText: 'تایید ساعت',
        cancelText: 'بدون ساعت', // اگر کاربر نخواست ساعت تنظیم کند
      );

      if (pickedTime != null) {
        // ترکیب تاریخ و ساعت انتخاب شده
        dueDate.value = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      } else {
        // اگر کاربر تقویم رو انتخاب کرد ولی ساعت رو لغو کرد، همون 9 صبح دیفالت رو میذاریم
        dueDate.value = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          9,
          0,
        );
      }
    }
  }
  void saveTask() async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar('خطا', 'لطفاً عنوان تسک را وارد کنید.');
      return;
    }

    isLoading.value = true;

    // ۱. محاسبه زمان یادآور (بر اساس تاریخ سررسید و گزینه انتخاب شده)
    DateTime? finalRemindAt;
    if (reminderEnabled.value && dueDate.value != null) {
      if (reminderPreset.value == '10m') {
        finalRemindAt = dueDate.value!.subtract(const Duration(minutes: 10));
      } else if (reminderPreset.value == '30m') {
        finalRemindAt = dueDate.value!.subtract(const Duration(minutes: 30));
      } else {
        finalRemindAt = dueDate.value; // on_time
      }
    }

    // ۲. ارسال درخواست به ریپازیتوری
    final result = await _taskRepository.createTask(
      title: title,
      description: descController.text.trim(),
      categoryId: Get.find<CategoryWorkspaceViewModel>().category.value.id,
      priority: priorityLevel.value, // از 1 تا 3
      dueDate: dueDate.value,
      remindAt: finalRemindAt,
    );

    result.fold(
          (failure) {
        Get.snackbar('خطا', failure.message);
      },
          (document) {
        // ۳. آپدیت موفقیت‌آمیز و بازگشت به صفحه قبل (آپدیت لوکال)
        final newTodo = TodoModel.fromJson(document.data);

        // اضافه کردن مستقیم به لیستِ فضای کاری برای نمایش زنده بدون رفرش
        //Get.find<CategoryWorkspaceViewModel>().addTodoLocal(newTodo);

        Get.back();
        Get.snackbar('موفق', 'تسک با موفقیت ذخیره شد');
      },
    );

    isLoading.value = false;
  }

  @override
  void onClose() {
    titleController.dispose();
    descController.dispose();
    super.onClose();
  }
}