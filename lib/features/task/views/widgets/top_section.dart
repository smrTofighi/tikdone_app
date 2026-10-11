import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/gen/fonts.gen.dart';
import 'package:tikdone_app/core/values/colors.dart'; // حاوی ThemeHelper
import 'package:tikdone_app/core/values/icons.dart'; // حاوی AppIcons
import 'package:tikdone_app/features/task/view_model/task_view_model.dart';
import 'package:tikdone_app/features/task/views/widgets/task_list_app_bar.dart';

class TopSection extends StatelessWidget {
  TopSection({super.key});
  final TaskViewModel taskListWM = Get.find<TaskViewModel>();

  @override
  Widget build(BuildContext context) {
    final category = taskListWM.model.categoryModel;
    // استفاده از تم استرینگ
    final categoryColor = ThemeHelper.parsePrimaryColor(category.theme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TaskListAppBar(),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Row(
            children: [
              // آیکون دسته‌بندی با هاله سفید شیشه‌ای
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Hero(
                  tag: 'tag_${category.title}',
                  // استفاده از آیکون وکتوری جدید
                  child: Icon(
                    AppIcons.getIcon(category.icon),
                    color: categoryColor,
                    size: 30,
                  ),
                ),
              ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack),

              const SizedBox(width: 16),

              // عنوان و تعداد تسک‌های فعال
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontFamily.samim,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GetBuilder<TaskViewModel>(
                      builder: (vm) {
                        final count =
                            vm.model.categoryModel.activeTodos?.length ?? 0;
                        return Text(
                          count == 0
                              ? 'همه کارها انجام شده 🎉'
                              : '$count مأموریت مانده',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 13,
                            fontFamily: FontFamily.samim,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
