import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:tikdone_app/features/main/main_category/view_model/main_category_view_model.dart';
import 'package:tikdone_app/features/task/view_model/task_view_model.dart';

class TaskListAppBar extends StatelessWidget {
  const TaskListAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 46),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Get.find<MainCategoryViewModel>().getCategories();
              //Get.find<TaskViewModel>().clearTodos();
              Get.delete<TaskViewModel>();
              Get.back();
            },
            icon: Icon(
              FluentIcons.arrow_left_24_regular,
              color: Colors.white,
            ),
          ),
          //DropdownTaskList()
        ],
      ),
    );
  }
}
