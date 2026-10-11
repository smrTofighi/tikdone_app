import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/dimens.dart';

class TaskSinglePageCategory extends StatelessWidget {
  const TaskSinglePageCategory({
    super.key,
    required this.title,
    required this.bgColor,
    required this.isEmpty,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final Color bgColor;
  final RxBool isEmpty;
  final IconData icon; // تغییر از ImageProvider به IconData
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(
      () => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radius),
            color: isEmpty.value
                ? (isDark ? Colors.white10 : Colors.grey.shade200)
                : bgColor.withOpacity(0.18),
            border: Border.all(
              color:
                  isEmpty.value ? Colors.transparent : bgColor.withOpacity(0.4),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize:
                MainAxisSize.min, // حذف عرض ثابت ۱۰۰ برای جلوگیری از Overflow
            children: [
              Icon(
                isEmpty.value ? Icons.label_outline_rounded : icon,
                size: 18,
                color: isEmpty.value
                    ? (isDark ? Colors.white54 : Colors.grey.shade600)
                    : bgColor,
              ),
              const SizedBox(width: 8),
              Text(
                isEmpty.value ? 'انتخاب دسته‌بندی' : title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isEmpty.value
                      ? (isDark ? Colors.white54 : Colors.grey.shade600)
                      : (isDark ? Colors.white : bgColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
