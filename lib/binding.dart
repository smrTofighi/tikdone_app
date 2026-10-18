import 'package:get/get.dart';
import 'package:tikdone_app/features/auth/view_model/auth_view_model.dart';
import 'package:tikdone_app/features/category/view-model/categories_view_model.dart';
import 'package:tikdone_app/features/category/view-model/category_workspace_view_model.dart';
import 'package:tikdone_app/features/category/view-model/main_category_view_model.dart';
import 'package:tikdone_app/features/profile/view_model/profile_view_model.dart';

import 'features/analytics/view_model/analytics_view_model.dart';
import 'features/home/view_model/home_view_model.dart';
import 'features/main/view_model/main_view_model.dart';
import 'features/settings/view_model/setting_view_model.dart';
import 'features/task/view_model/create_task_view_model.dart';

class CategoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CategoryWorkspaceViewModel(),
    );
  }
}

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(MainViewModel());
    Get.lazyPut(() => CategoriesViewModel(), fenix: true);
    Get.lazyPut(() => HomeViewModel(), fenix: true);
    Get.lazyPut(() => AnalyticsViewModel(), fenix: true);
    Get.lazyPut(() => SettingsViewModel(), fenix: true);
  }
}



class TaskBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CreateTaskViewModel(),
    );
  }
}

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ProfileViewModel(),
    );
  }
}

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthViewModel());
  }
}
