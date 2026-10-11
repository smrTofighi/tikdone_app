import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/task/view_model/task_view_model.dart';
import '../../../../core/values/colors.dart'; // حاوی ThemeHelper

class TaskNoteUnActive extends StatelessWidget {
  TaskNoteUnActive({super.key});

  final TaskViewModel taskVM = Get.find<TaskViewModel>();

  @override
  Widget build(BuildContext context) {
    final currentColor =
        ThemeHelper.parsePrimaryColor(taskVM.model.categoryModel.theme);

    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          taskVM.isActiveNote(true);
        },
        child: Text(
          taskVM.model.description.value.isEmpty
              ? 'افزودن توضیحات'
              : taskVM.model.description.value,
          style: TextStyle(
            color: taskVM.model.description.value.isEmpty
                ? Colors.grey
                : currentColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ).animate(delay: const Duration(milliseconds: 250)).fade();
  }
}
