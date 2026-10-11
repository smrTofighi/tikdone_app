import 'package:get/get.dart';
import 'package:tikdone_app/features/auth/view_model/auth_view_model.dart';
import 'package:tikdone_app/features/main/main_category/view_model/main_category_view_model.dart';
import 'package:tikdone_app/features/main/main_report/view_model/main_report_view_model.dart';
import 'package:tikdone_app/features/profile/view_model/profile_view_model.dart';

class CategoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(MainCategoryViewModel());
  }
}

class ReportBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(MainReportViewModel());
  }
}

class TaskBinding implements Bindings {
  @override
  void dependencies() {}
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
