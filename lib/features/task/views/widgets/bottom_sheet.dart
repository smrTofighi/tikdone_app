import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/task/views/widgets/task_list_widget.dart';
import '../../../../core/values/colors.dart'; // حاوی ThemeHelper
import '../../../main/widgets/loading.dart';
import '../../view_model/task_view_model.dart';

class BottomSection extends StatelessWidget {
  const BottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    final taskVM = Get.find<TaskViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        child: Obx(
          () => taskVM.isLoading.value
              ? Center(
                  child: Loading(
                    // استفاده از استرینگ تم
                    color: ThemeHelper.parsePrimaryColor(
                        taskVM.model.categoryModel.theme),
                    size: 36,
                  ),
                )
              : GetBuilder<TaskViewModel>(
                  builder: (vm) {
                    final activeList = vm.model.categoryModel.activeTodos ?? [];
                    final doneList = vm.model.categoryModel.unActiveTodos ?? [];

                    return ListView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        TodoListWidget(
                          topTitle: 'مأموریت‌های فعال',
                          todoList: activeList.obs,
                          badgeCount: activeList.length,
                          isCompletedGroup: false,
                        ),
                        if (doneList.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          TodoListWidget(
                            topTitle: 'انجام‌شده‌ها',
                            todoList: doneList.obs,
                            badgeCount: doneList.length,
                            isCompletedGroup: true,
                          ),
                        ],
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
