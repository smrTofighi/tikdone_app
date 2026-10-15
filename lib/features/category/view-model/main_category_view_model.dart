import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/config/storage_key.dart';
import 'package:tikdone_app/core/locator/locator.dart';
import 'package:tikdone_app/core/routes/pages.dart';
import 'package:tikdone_app/core/utils/custom_snackbar.dart';
import 'package:tikdone_app/data/models/category_model.dart';
import 'package:tikdone_app/data/services/storage_service.dart';
import 'package:tikdone_app/features/category/repository/category_repository.dart';
import 'package:tikdone_app/features/task/view_model/task_view_model.dart';

class MainCategoryViewModel extends GetxController {
  late CategoryRepository _model;
  CategoryRepository get model => _model;
  MainCategoryViewModel() {
    _model = CategoryRepository();
  }
  final _storageService = locator<StorageService>();

  RxInt allCountItemsCategories = 0.obs;
  RxInt completeCountItemsCategories = 0.obs;
  RxBool isEditing = false.obs;
  RxBool deleting = false.obs;
  RxBool loading = false.obs;
  final TextEditingController _categoryController = TextEditingController();
  RxBool isLoadingBottomSheet = RxBool(false);
  RxBool isLoading = RxBool(false);
  RxBool isError = RxBool(false);

  

  @override
  void onInit() {
    getCategories();
    super.onInit();
  }

  void deleteCategory(
      String categoryId, int index, BuildContext context) async {
    isLoading(true);
    var response =
        await _model.deleteCategory(categoryId: categoryId, index: index);
    response.fold(
      (l) {
        isLoading(false);
        CustomSnackbar.showError(context, l.message);
      },
      (r) {
        isLoading(false);
        update();
      },
    );
  }

  void addCategory(
      {required String title,
      required int iconString,
      required String themeString,
      required bool pinToTop,
      required BuildContext context}) async {
    isLoadingBottomSheet(true);
    var userId = _storageService.getValue(StorageKey.userId);
    var res = await _model.addCategory(
      title: title,
      theme: themeString,
      icon: iconString,
      userId: userId,
      pinToTop: pinToTop
    );
    res.fold(
      (failure) {
        CustomSnackbar.showError(context, failure.message);
        isLoadingBottomSheet(false);
      },
      (document) {
        isLoadingBottomSheet(false);
        update();
        //getCategories();
        Get.back();
      },
    );
  }


  void getCategories() async {
    isLoading(true);
    var userId = _storageService.getValue(StorageKey.userId);
    var res = await _model.getCategory(userId: userId);
    res.fold(
      (failure) {
        _model.errorMessage = failure.message;
        isLoading(false);
      },
      (category) {
        isLoading(false);
        update();
      },
    );
  }

  void goToTaskListPage(
    CategoryModel category,
  ) {
    final TaskViewModel taskVM = Get.put(TaskViewModel());
    taskVM.setCategory(category);
    taskVM.getTodos();
    Get.toNamed(PageName.taskList);
  }

  
  void editCategory() {}

  void changeThemeCategory() {
    Get.offAllNamed(PageName.main);
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }
}
