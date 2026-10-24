import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/category/view-model/category_workspace_view_model.dart';
import 'package:tikdone_app/features/task/views/widgets/create_task/create_task_appbar.dart';
import 'package:tikdone_app/features/task/views/widgets/create_task/due_date_task_card.dart';
import 'package:tikdone_app/features/task/views/widgets/create_task/input_card.dart';
import 'package:tikdone_app/features/task/views/widgets/create_task/task_priority_card.dart';

import '../../view_model/create_task_view_model.dart';
import '../widgets/create_task/create_task_button_actions.dart';
import '../widgets/create_task/task_reminder_card.dart';

class CreateTaskPage extends GetView<CreateTaskViewModel> {
  const CreateTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = ThemeHelper.parsePrimaryColor(
        Get.find<CategoryWorkspaceViewModel>().category.value.theme);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            CreateTaskAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InputCard(),
                    const SizedBox(height: 20),
                    DueDateTaskCard(),
                    const SizedBox(height: 20),
                    TaskReminderCard(),
                    const SizedBox(height: 20),
                    TaskPriorityCard(),
                    const SizedBox(height: 32),
                    CreateTaskButtonActions(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
