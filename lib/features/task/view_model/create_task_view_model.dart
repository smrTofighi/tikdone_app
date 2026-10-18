import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/category_model.dart';
// import 'package:tikdone_app/features/category/view-model/categories_view_model.dart';

class CreateTaskViewModel extends GetxController {
  // --- کنترلرهای متنی ---
  final titleController = TextEditingController();
  final descController = TextEditingController();

  // --- استیت‌های مربوط به تنظیمات تسک ---
  final RxString selectedCategoryId = ''.obs;
  final Rx<DateTime?> dueDate = Rx<DateTime?>(null);

  // یادآور
  final RxBool reminderEnabled = true.obs;
  final RxString reminderPreset = 'on_time'.obs; // on_time, 10m, 30m, 1h

  // اولویت (1: کم، 2: معمولی، 3: فوری)
  final RxInt priorityLevel = 2.obs;

  final RxBool isLoading = false.obs;

  // لیست دسته‌بندی‌ها (این را باید از کنترلر دسته‌ها یا دیتابیس بگیرید)
  // فعلاً چند دیتای تستی برای نمایش UI قرار دادیم
  final RxList<CategoryModel> availableCategories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  void _loadCategories() {
    // TODO: دریافت لیست دسته‌ها از دیتابیس یا CategoriesViewModel
    // Get.find<CategoriesViewModel>().allCategories;
    availableCategories.assignAll([
      CategoryModel(id: '1', userId: 'u1', title: 'پروژه‌های کاری', theme: 'solid_#00677D', icon: 58272),
      CategoryModel(id: '2', userId: 'u1', title: 'سلامت و ورزش', theme: 'solid_#EF4444', icon: 58273),
    ]);
    if (availableCategories.isNotEmpty) {
      selectedCategoryId.value = availableCategories.first.id;
    }
  }

  // --- متدهای تغییر استیت ---
  void selectCategory(String id) => selectedCategoryId.value = id;
  void selectPriority(int level) => priorityLevel.value = level;
  void toggleReminder(bool val) => reminderEnabled.value = val;
  void selectReminderPreset(String preset) => reminderPreset.value = preset;

  // انتخاب تاریخ (می‌توانید بعداً به تقویم شمسی متصل کنید)
  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) dueDate.value = picked;
  }

  void saveTask() {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar('خطا', 'لطفاً عنوان تسک را وارد کنید.');
      return;
    }

    isLoading.value = true;
    // TODO: ارسال اطلاعات به Appwrite (TodoRepository)
    // - title
    // - description: descController.text
    // - categoryId: selectedCategoryId.value
    // - priority: priorityLevel.value
    // - dueDate: dueDate.value

    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.back(); // بازگشت به صفحه قبل بعد از ذخیره
      Get.snackbar('موفق', 'تسک با موفقیت ذخیره شد');
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    descController.dispose();
    super.onClose();
  }
}