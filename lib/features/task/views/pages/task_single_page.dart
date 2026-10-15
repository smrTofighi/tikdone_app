import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart'; // حاوی ThemeHelper
import 'package:tikdone_app/core/values/dimens.dart';
import 'package:tikdone_app/core/values/icons.dart'; // حاوی AppIcons
import 'package:tikdone_app/core/values/strings.dart';
import 'package:tikdone_app/features/category/view-model/main_category_view_model.dart';
import 'package:tikdone_app/features/task/view_model/task_view_model.dart';
import 'package:tikdone_app/features/task/views/widgets/task_single_text_field.dart';
import 'package:tikdone_app/features/task/views/widgets/todo_category.dart';
import '../../../../../core/styles/text_styles.dart';
import '../widgets/task_note_unactiove.dart';

class TaskSinglePage extends StatefulWidget {
  const TaskSinglePage({super.key});

  @override
  State<TaskSinglePage> createState() => _TaskSinglePageState();
}

class _TaskSinglePageState extends State<TaskSinglePage> {
  final TaskViewModel taskVM = Get.find<TaskViewModel>();
  final MainCategoryViewModel categoryVM = Get.find<MainCategoryViewModel>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentColor =
        ThemeHelper.parsePrimaryColor(taskVM.model.categoryModel.theme);

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0F172A) : AppColors.backGround,
        appBar: AppBar(
          title: Text(
            taskVM.isEditing.value
                ? PersianStrings.editTask
                : PersianStrings.newTask,
            style: AppTextStyles.titleOfAppBar.copyWith(
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              taskVM.clearSingleTodoAfterAdd();
              Get.back();
            },
            color: isDark ? Colors.white : Colors.black87,
            icon: const Icon(Icons.arrow_back_rounded, size: 24),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gap(AppDimens.high * 2),
                TaskSinglePageTextField(
                  controller: taskVM.todoEditingController,
                  categoryModel: taskVM.model.categoryModel,
                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return PersianStrings.requiredText;
                    }
                    return null;
                  },
                ),
                Gap(AppDimens.medium * 2),
                Obx(
                  () => taskVM.isActiveNote.value
                      ? TaskSinglePageTextField(
                          controller: taskVM.descEditingController,
                          categoryModel: taskVM.model.categoryModel,
                          onChanged: (value) {
                            taskVM.model.description(value);
                          },
                          validator: (value) {
                            return null;
                          },
                          icon: GestureDetector(
                            onTap: () => taskVM.isActiveNote(false),
                            child: Icon(Icons.close_rounded,
                                color: Colors.grey.shade400),
                          ),
                        )
                          .animate(delay: const Duration(milliseconds: 250))
                          .fade()
                      : TaskNoteUnActive(),
                ),
                Gap(AppDimens.medium * 2),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'دسته بندی :',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
                Gap(AppDimens.high),
                Align(
                  alignment: Alignment.centerRight,
                  child: TaskSinglePageCategory(
                    title: taskVM.model.categoryModel.title,
                    bgColor: currentColor,
                    isEmpty: taskVM.model.categoryModel.title.isEmpty.obs,
                    // ارسال آیکون جدید وکتوری به ویجت دسته بندی
                    icon: AppIcons.getIconFromCode(taskVM.model.categoryModel.icon),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: AddEditTaskBottomNavigation(
          formKey: _formKey,
        ),
      ),
    );
  }
}

class AddEditTaskBottomNavigation extends StatelessWidget {
  AddEditTaskBottomNavigation({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;
  final TaskViewModel taskVM = Get.find<TaskViewModel>();

  @override
  Widget build(BuildContext context) {
    final currentColor =
        ThemeHelper.parsePrimaryColor(taskVM.model.categoryModel.theme);

    // تغییر ظاهر دکمه از حالت مستطیل چسبیده به حالت شناور و مدرن
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 8),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              if (taskVM.isEditing.value) {
                taskVM.updateTodo();
              } else {
                taskVM.addTodo();
              }
              Get.back();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: currentColor,
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: currentColor.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            taskVM.isEditing.value ? PersianStrings.edit : PersianStrings.add,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
