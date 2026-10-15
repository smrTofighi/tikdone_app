import 'package:flutter/material.dart';
import 'package:tikdone_app/core/values/colors.dart'; // برای ThemeHelper
import 'package:tikdone_app/core/values/icons.dart';
import 'package:tikdone_app/gen/fonts.gen.dart'; // برای AppIcons

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.title,
    required this.index,
    required this.icon,
    required this.theme,
    required this.onTap,
    required this.totalTodos,
    required this.percentage,
    required this.completedTodos,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final int index;
  final int icon;
  final String theme;
  final Function() onTap;
  final int totalTodos;
  final double percentage;
  final int completedTodos;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ۱. دریافت رنگ از سیستم استرینگ جدید
    final categoryColor = ThemeHelper.parsePrimaryColor(theme);
    final remainingTodos = totalTodos - completedTodos;

    // محاسبه درصد برای نوار پیشرفت سفارشی (بین 0.0 تا 1.0)
    final double safePercentage =
        totalTodos == 0 ? 0.0 : (completedTodos / totalTodos).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : categoryColor.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // هدر کارت: آیکون با پس‌زمینه محو + دکمه تنظیمات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Hero(
                    tag: 'tag_$title',
                    // ۲. استفاده از سیستم آیکون وکتوری جدید
                    child: Icon(
                      AppIcons.getIconFromCode(icon),
                      color: categoryColor,
                      size: 28,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz_rounded,
                    color: isDark ? Colors.white54 : Colors.black45,
                    size: 22,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('ویرایش', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded,
                              size: 18, color: Colors.redAccent),
                          SizedBox(width: 8),
                          Text(
                            'حذف',
                            style: TextStyle(
                                fontSize: 14, color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),

            const Spacer(),

            // اطلاعات متنی دسته‌بندی
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
                fontFamily: FontFamily.samim,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              totalTodos == 0
                  ? 'بدون مأموریت'
                  : '$remainingTodos مأموریت مانده',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
                fontFamily: FontFamily.samim,
              ),
            ),

            const SizedBox(height: 16),

            // نوار پیشرفت (Progress Bar) مینیمال و اختصاصی
            Row(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutCubic,
                            width: constraints.maxWidth * safePercentage,
                            decoration: BoxDecoration(
                              color: categoryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // ۳. اصلاح خطای سینتکسی فرمول درصد
                Text(
                  '${(safePercentage * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
