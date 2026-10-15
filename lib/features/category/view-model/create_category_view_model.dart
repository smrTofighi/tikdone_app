import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/config/storage_key.dart';
import 'package:tikdone_app/core/locator/locator.dart';
import 'package:tikdone_app/core/utils/custom_snackbar.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/data/services/storage_service.dart';
import 'package:tikdone_app/features/category/repository/category_repository.dart';

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
  final Rx<IconData> selectedIcon = Icons.folder_rounded.obs;
  final RxString selectedTheme = 'solid_#00B4D8'.obs;
  Color get currentColor => ThemeHelper.parsePrimaryColor(selectedTheme.value);

  final RxBool pinToTop = false.obs;
  void updateColor(String themeStr) {
    selectedTheme.value = themeStr;
  }

  @override
  void onInit() {
    super.onInit();
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

  void createCategory(
     BuildContext context) async {
    isLoading(true);
    var userId = _storageService.getValue(StorageKey.userId);
    var res = await _categoryRepository.addCategory(
      title: categoryTitle.value,
      theme: selectedTheme.value,
      icon: selectedIcon.value.codePoint,
      userId: userId,
      pinToTop: pinToTop.value
    );
    res.fold(
      (failure) {
        CustomSnackbar.showError(context, failure.message);
        isLoading(false);
      },
      (document) {
        update();
        isLoading(false);
        Get.back();
      },
    );
  }
}
