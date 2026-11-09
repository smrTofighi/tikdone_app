import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/config/storage_key.dart';
import 'package:tikdone_app/core/locator/locator.dart';
import 'package:tikdone_app/core/utils/custom_snackbar.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/core/values/icons.dart'; // فرض می‌کنیم متد AppIcons.getIconFromCode اینجاست
import 'package:tikdone_app/data/models/category_model.dart';
import 'package:tikdone_app/data/services/storage_service.dart';
import 'package:tikdone_app/features/category/repository/category_repository.dart';
import 'package:tikdone_app/features/category/view-model/category_workspace_view_model.dart';

import 'categories_view_model.dart';

class CreateCategoryViewModel extends GetxController {
  late CategoryRepository _categoryRepository;

  CategoryRepository get model => _categoryRepository;

  CreateCategoryViewModel() {
    _categoryRepository = CategoryRepository();
  }

  final _storageService = locator<StorageService>();
  final RxBool isLoading = false.obs;
  final titleController = TextEditingController();
  final RxString categoryTitle = 'پروژه و اهداف جدید'.obs;
  final Rx<IconData> selectedIcon = AppIcons.availableIcons[0].obs;
  final RxString selectedTheme = 'solid_#00B4D8'.obs;

  Color get currentColor => ThemeHelper.parsePrimaryColor(selectedTheme.value);

  final RxBool pinToTop = false.obs;

  // ==========================================
  // متغیرهای مدیریت حالت ویرایش (Dual-Mode)
  // ==========================================
  bool isEditing = false;
  CategoryModel? existingCategory;

  void updateColor(String themeStr) {
    selectedTheme.value = themeStr;
  }

  @override
  void onInit() {
    super.onInit();

    // بررسی اینکه آیا دیتایی از صفحه قبل (Workspace) پاس داده شده یا خیر
    if (Get.arguments != null && Get.arguments is CategoryModel) {
      isEditing = true;
      existingCategory = Get.arguments;

      // پر کردن فیلدها با دیتای دسته قبلی
      titleController.text = existingCategory!.title;
      categoryTitle.value = existingCategory!.title;
      selectedTheme.value = existingCategory!.theme;
      pinToTop.value = existingCategory!.pinToTop;

      // تبدیل کدِ عددیِ آیکون به IconData
      selectedIcon.value = AppIcons.getIconFromCode(existingCategory!.icon);
    }

    // لیسنر برای آپدیت زنده عنوان روی کارتِ پیش‌نمایش
    titleController.addListener(() {
      final text = titleController.text.trim();
      categoryTitle.value = text.isEmpty ? 'پروژه و اهداف جدید' : text;
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }

  // نام متد از createCategory به saveCategory تغییر کرد چون حالا هر دو کار را انجام می‌دهد
  void saveCategory(BuildContext context) async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      CustomSnackbar.showError(context, 'لطفاً عنوان دسته‌بندی را وارد کنید.');
      return;
    }

    isLoading(true);
    var userId = _storageService.getValue(StorageKey.userId);

    if (isEditing) {
      // ------------------------------------
      // حالت اول: ویرایش دسته‌بندی موجود
      // ------------------------------------
      var res = await _categoryRepository.updateCategory(
          categoryId: existingCategory!.id,
          title: title,
          theme: selectedTheme.value,
          icon: selectedIcon.value.codePoint,
          pinToTop: pinToTop.value);

      res.fold(
        (failure) {
          CustomSnackbar.showError(context, failure.message);
        },
        (document) {
          final updatedCategory = CategoryModel.fromJson(document.data);

          // نکته طلایی: انتقال تسک‌های لوکال از مدل قدیمی به مدل آپدیت شده
          // تا تعداد تسک‌های فعال در UI صفر نشود!
          updatedCategory.activeTodos = existingCategory?.activeTodos;
          updatedCategory.unActiveTodos = existingCategory?.unActiveTodos;
          updatedCategory.totalTodos = existingCategory?.totalTodos ?? 0;
          updatedCategory.completedTodos =
              existingCategory?.completedTodos ?? 0;

          // آپدیت زنده لیست در صفحه اصلی
          if (Get.isRegistered<CategoriesViewModel>()) {
            final categoriesVM = Get.find<CategoriesViewModel>();
            final categoryworkVM = Get.find<CategoryWorkspaceViewModel>();
            categoryworkVM.category.value = updatedCategory; // آپدیت زنده مدل در Workspace
            
            final index = categoriesVM.allCategories
                .indexWhere((c) => c.id == existingCategory!.id);
            if (index != -1) {
              categoriesVM.allCategories[index] = updatedCategory;
            }
          }

          // بازگشت به صفحه Workspace و پاس دادن مدل جدید
          // Get.back(result: ...) باعث می‌شود کدی که در Workspace نوشته بودیم فعال شود
          Get.back(result: updatedCategory);
          CustomSnackbar.showSuccess(context, 'دسته‌بندی با موفقیت ویرایش شد.');
        },
      );
    } else {
      // ------------------------------------
      // حالت دوم: ساخت دسته‌بندی جدید
      // ------------------------------------
      var res = await _categoryRepository.addCategory(
          title: title,
          theme: selectedTheme.value,
          icon: selectedIcon.value.codePoint,
          userId: userId,
          pinToTop: pinToTop.value);

      res.fold(
        (failure) {
          CustomSnackbar.showError(context, failure.message);
        },
        (document) {
          final newCategory = CategoryModel.fromJson(document.data);

          if (Get.isRegistered<CategoriesViewModel>()) {
            Get.find<CategoriesViewModel>()
                .allCategories
                .insert(0, newCategory);
          }

          Get.back();
          CustomSnackbar.showSuccess(context, 'دسته‌بندی با موفقیت ساخته شد.');
        },
      );
    }

    isLoading(false);
  }
}
