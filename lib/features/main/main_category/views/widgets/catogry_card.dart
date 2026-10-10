import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo_infinity_app/core/gen/fonts.gen.dart';
import 'package:todo_infinity_app/core/values/colors.dart';
import 'package:todo_infinity_app/core/values/icons.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.title,
    required this.index,
    required this.iconIndex,
    required this.colorIndex,
    required this.onTap,
    required this.totalTodos,
    required this.percentage,
    required this.completedTodos,
  });

  final String title;
  final int index;
  final int iconIndex;
  final int colorIndex;
  final Function() onTap;
  final int totalTodos;
  final double percentage;
  final int completedTodos;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // width و height ثابت حذف شدند تا GridView ابعاد را مدیریت کند
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18), // گوشه‌های نرم‌تر و مدرن
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black26
                  : Colors.black
                      .withOpacity(0.04), // سایه نرم و هماهنگ با دارک مود
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 16),
              child: Hero(
                tag: 'tag $title',
                child: ImageIcon(
                  iconList[iconIndex].image,
                  color: colorList[colorIndex],
                  size: 36,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // رنگ داینامیک برای متن اصلی
                      color: isDark ? Colors.white : Colors.black87,
                      fontFamily: FontFamily.samim,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${totalTodos - completedTodos} مأموریت', // خطای منطقی برطرف شد
                    style: TextStyle(
                      fontSize: 13,
                      // رنگ داینامیک برای متن راهنما
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                      decoration: TextDecoration.none,
                      fontFamily: FontFamily.samim,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              child: StepProgressIndicator(
                totalSteps: totalTodos == 0 ? 1 : totalTodos,
                currentStep: completedTodos == 0 ? 0 : completedTodos,
                size: 6, // کمی ضخیم‌تر برای دید بهتر
                padding: 0,
                selectedGradientColor: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorList[colorIndex],
                    colorList[colorIndex].withOpacity(0.6),
                  ],
                ),
                unselectedColor:
                    isDark ? Colors.white10 : Colors.black.withOpacity(0.03),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
