import 'package:get/get.dart';
import 'package:tikdone_app/binding.dart';
import 'package:tikdone_app/core/routes/pages.dart';
import 'package:tikdone_app/features/auth/views/pages/auth_page.dart';
import 'package:tikdone_app/features/category/views/pages/create_category_page.dart';
import 'package:tikdone_app/features/main/views/main_page.dart';
import 'package:tikdone_app/features/profile/views/pages/profile_page.dart';
import 'package:tikdone_app/features/search/search_view.dart';
import 'package:tikdone_app/features/splash/splash_page.dart';
import 'package:tikdone_app/features/auth/views/pages/login_page.dart';
import 'package:tikdone_app/features/auth/views/pages/signup_page.dart';

import '../../features/category/views/pages/category_workspace_page.dart';
import '../../features/task/views/create_task_page.dart';

List<GetPage> routes = [
  GetPage(
    name: AppPages.signUp,
    page: () => const SignUpPage(),
  ),
  GetPage(
    name: AppPages.logIn,
    page: () => const LogInPage(),
  ),
  GetPage(
    name: AppPages.splash,
    page: () => const SplashPage(),
  ),
  GetPage(
    name: AppPages.auth,
    page: () => AuthPage(),
  ),
  GetPage(
    name: AppPages.main,
    page: () => MainPage(),
    bindings: [MainBinding()],
  ),
  GetPage(
    name: AppPages.categoryWorkspace,
    page: () => CategoryWorkspacePage(),
    binding: CategoryBinding()

  ),
  GetPage(
    name: AppPages.createTask,
    page: () => CreateTaskPage(),
    binding: TaskBinding(),
  ),
  GetPage(
    name: AppPages.search,
    page: () => const SearchView(),
  ),
  GetPage(
      name: AppPages.profile,
      page: () => ProfilePage(),
      binding: ProfileBinding()),
      GetPage(
        name: AppPages.createCategory,
        page: () => CreateCategoryPage(),
      )
];
