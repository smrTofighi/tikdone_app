import 'package:get/get.dart';
import 'package:tikdone_app/core/config/storage_key.dart';
import 'package:tikdone_app/core/locator/locator.dart';
import 'package:tikdone_app/data/models/category_model.dart';
import 'package:tikdone_app/data/services/storage_service.dart';
import 'package:tikdone_app/features/category/repository/category_repository.dart';

// یک مدل موقت برای رندر کردن UI (بعداً مدل اصلی دیتابیس را جایگزین این کنید)

class CategoriesViewModel extends GetxController {
  late CategoryRepository _repository;
  CategoryRepository get model => _repository;
  CategoriesViewModel() {
    _repository = CategoryRepository();
  }

  final _storageService = locator<StorageService>();
  final searchText = ''.obs;
  final activeFilter = 'all'.obs;
  final isLoading = false.obs;

  // لیست واقعی متصل به دیتابیس
  final RxList<CategoryModel> allCategories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // به محض باز شدن صفحه، دسته‌ها را از دیتابیس بگیر
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;

    // گرفتن شناسه کاربر از استوریج
    final userId = _storageService.getValue(StorageKey.userId) ?? '';

    if (userId.isEmpty) {
      isLoading.value = false;
      return; // کاربر لاگین نیست
    }

    final result = await _repository.getCategory(userId: userId);

    result.fold(
      (failure) {
        // هندل کردن خطا (مثلا نمایش اسنک‌بار)
        Get.snackbar('خطا در دریافت اطلاعات', failure.message);
      },
      (categories) {
        // ریختن دیتای موفق داخل استیت
        allCategories.assignAll(categories);
      },
    );

    isLoading.value = false;
  }

  // گرفتن لیست فیلتر و مرتب شده برای نمایش در کارت‌ها
  List<CategoryModel> get filteredCategories {
    var list = allCategories.where((cat) {
      // ۱. اعمال فیلتر جستجو
      final matchSearch = cat.title.contains(searchText.value);

      // ۲. اعمال فیلتر دسته‌بندی‌ها
      bool matchFilter = true;
      if (activeFilter.value == 'active') {
        matchFilter = !cat.isCompleted && cat.activeTasks > 0;
      } else if (activeFilter.value == 'high-priority') {
        matchFilter = cat.isHighPriority;
      } else if (activeFilter.value == 'completed') {
        matchFilter = cat.isCompleted;
      }

      return matchSearch && matchFilter;
    }).toList();

    // ۳. مرتب‌سازی: پین‌شده‌ها بالاتر
    list.sort((a, b) {
      if (a.pinToTop && !b.pinToTop) return -1;
      if (!a.pinToTop && b.pinToTop) return 1;
      return 0;
    });

    return list;
  }

  void updateSearch(String query) => searchText.value = query;
  void setFilter(String filter) => activeFilter.value = filter;
}
