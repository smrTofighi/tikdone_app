import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/routes/pages.dart';
import 'package:tikdone_app/core/values/colors.dart'; // حاوی ThemeHelper
import 'package:tikdone_app/features/task/view_model/task_view_model.dart';
import 'package:tikdone_app/features/task/views/widgets/bottom_sheet.dart'; // یا bottom_section بر اساس تغییرات قبلی
import 'package:tikdone_app/features/task/views/widgets/top_section.dart';
import '../../../main/widgets/floating_action_button.dart';

class TaskListPage extends StatelessWidget {
  TaskListPage({super.key});

  final TaskViewModel taskVM = Get.find<TaskViewModel>();

  @override
  Widget build(BuildContext context) {
    // گرفتن رنگ از استرینگ ذخیره شده در دیتابیس
    final categoryColor =
        ThemeHelper.parsePrimaryColor(taskVM.model.categoryModel.theme);

    return Scaffold(
      backgroundColor: categoryColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopSection(),
            const Expanded(
              child: BottomSection(),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => MyFloatingActionButton(
          onPressed: () {
            taskVM.isEditing(false);
            Get.toNamed(PageName.taskSingle);
          },
          icon: FontAwesomeIcons.plus,
          isLoading: taskVM.isLoadingUpdate.value,
          color: categoryColor,
        ),
      ),
    );
  }
}
