import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/gen/assets.gen.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/main/widgets/mydrawer_widget.dart';
import 'package:tikdone_app/features/main/main_category/views/pages/main_category_page.dart';
import 'package:tikdone_app/features/main/main_category/view_model/main_category_view_model.dart';
import 'package:tikdone_app/features/main/main_report/view_model/main_report_view_model.dart';
import 'package:tikdone_app/features/main/main_report/views/page/report_page.dart';
import 'widgets/floating_action_button.dart';

// ignore: must_be_immutable
class MainPage extends StatelessWidget {
  MainPage({super.key});
  final GlobalKey<ScaffoldState> _ourKey = GlobalKey<ScaffoldState>();
  final RxInt activeIndex = 0.obs;
  final MainCategoryViewModel categoryVM = Get.find<MainCategoryViewModel>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _ourKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(
              right: 12.0, top: 8.0, bottom: 8.0, left: 12.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  _ourKey.currentState!.openDrawer();
                },
                icon: ImageIcon(
                  Image.asset(Assets.icons.menu.path).image,
                  color: Theme.of(context).appBarTheme.iconTheme!.color,
                ),
              ),
              const Spacer(),
              
            ],
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Obx(
          () => IndexedStack(
            index: activeIndex.value,
            children: [
              const MainCategoryPage(),
              ReportPage(),
            ],
          ),
        ),
      ),
      floatingActionButton: DragTarget<int>(
        builder: (_, __, ___) => Obx(
          () => MyFloatingActionButton(
            onPressed: () {
              categoryVM.showBottomSheetCategory(context);
            },
            isLoading: false,
            icon: categoryVM.deleting.value
                ? FontAwesomeIcons.trash
                : FontAwesomeIcons.plus,
            color: categoryVM.deleting.value ? Colors.red : AppColors.primary,
          ),
        ),
        onAcceptWithDetails: (index) {},
      ),
      bottomNavigationBar: Obx(
        () => AnimatedBottomNavigationBar(
          icons: const [
            Icons.home_rounded,
            Icons.chat_rounded,
            
          ],
          inactiveColor: Theme.of(context).iconTheme.color,
          activeColor: AppColors.primary,
          backgroundColor: Theme.of(context).bottomAppBarTheme.color,
          activeIndex: activeIndex.value,
          onTap: (index) {
            activeIndex.value = index;
            if (index == 1) {
              Get.find<MainReportViewModel>().getCategoryAndTodos(context);
            }
          },
          gapLocation: GapLocation.center,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
