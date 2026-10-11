import 'package:get/get.dart';
import 'package:tikdone_app/binding.dart';
import 'package:tikdone_app/core/routes/pages.dart';
import 'package:tikdone_app/features/main/main_page.dart';
import 'package:tikdone_app/features/profile/views/pages/profile_page.dart';
import 'package:tikdone_app/features/search/search_view.dart';
import 'package:tikdone_app/features/splash/splash_page.dart';
import 'package:tikdone_app/features/task/views/pages/task_single_page.dart';
import 'package:tikdone_app/features/task/views/pages/task_list_page.dart';
import 'package:tikdone_app/features/auth/views/pages/login_page.dart';
import 'package:tikdone_app/features/auth/views/pages/signup_page.dart';

List<GetPage> routes = [
  GetPage(
    name: PageName.signUp,
    page: () => const SignUpPage(),
  ),
  GetPage(
    name: PageName.logIn,
    page: () => const LogInPage(),
  ),
  GetPage(
    name: PageName.splash,
    page: () => const SplashPage(),
  ),
  GetPage(
    name: PageName.main,
    page: () => MainPage(),
    bindings: [CategoryBinding(), TaskBinding(), ReportBinding()],
  ),
  GetPage(
      name: PageName.taskList,
      page: () => TaskListPage(),
      binding: TaskBinding()),
  GetPage(
    name: PageName.taskSingle,
    page: () => TaskSinglePage(),
  ),
  GetPage(
    name: PageName.search,
    page: () => const SearchView(),
  ),
  GetPage(
    name: PageName.profile,
    page: () =>  ProfilePage(),
    binding: ProfileBinding()
  ),
];
