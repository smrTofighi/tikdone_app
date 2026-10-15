import 'dart:developer';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/routes/pages.dart';
import 'package:tikdone_app/core/values/colors.dart'; // حاوی ThemeHelper
import 'package:tikdone_app/data/models/todo_model.dart';
import 'package:tikdone_app/features/task/view_model/task_view_model.dart';
import 'package:tikdone_app/features/task/views/widgets/no_todo_here.dart';
import 'package:tikdone_app/features/task/views/widgets/task_widget.dart';

class TodoListWidget extends StatelessWidget {
  TodoListWidget({
    super.key,
    required this.topTitle,
    required this.todoList,
    required this.badgeCount,
    this.isCompletedGroup = false,
  });

  final TaskViewModel taskVM = Get.find<TaskViewModel>();
  final String topTitle;
  final RxList todoList;
  final int badgeCount;
  final bool isCompletedGroup;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // استفاده از استرینگ تم
    final categoryColor =
        ThemeHelper.parsePrimaryColor(taskVM.model.categoryModel.theme);

    return Obx(
      () => ExpandablePanel(
        theme: ExpandableThemeData(
          hasIcon: true,
          iconColor: isDark ? Colors.white60 : Colors.black45,
          headerAlignment: ExpandablePanelHeaderAlignment.center,
        ),
        header: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text(
                topTitle,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isCompletedGroup
                      ? (isDark ? Colors.white10 : Colors.grey.shade200)
                      : categoryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isCompletedGroup
                        ? (isDark ? Colors.white54 : Colors.grey.shade600)
                        : categoryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        collapsed: const SizedBox(),
        expanded: todoList.isEmpty
            ? const NoTodoHere()
            : ListView.separated(
                itemCount: todoList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return TodoItemWidget(
                    todo: todoList[index],
                    color: categoryColor,
                    onChanged: (value) {
                      final id = todoList[index].id;
                      final bool isCompleted = value ?? false;
                      log("Task State: $isCompleted");
                      taskVM.updateIsCompleted(id, isCompleted);
                    },
                    onDelete: (_) => taskVM.deleteTodo(todoList[index]),
                    onEdit: (_) {
                      taskVM.isEditing(true);
                      taskVM.setTodo(todoList[index], index);
                      Get.toNamed(PageName.taskSingle);
                    },
                  );
                },
              ),
      ),
    );
  }
}
