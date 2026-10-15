import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/core/values/icons.dart';
import 'package:tikdone_app/data/models/category_model.dart';
import 'package:tikdone_app/features/category/view-model/categories_view_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // تبدیل دیتای مدل به رنگ و آیکون فلاتر
    final color = ThemeHelper.parsePrimaryColor(category.theme);
    final icon = AppIcons.getIconFromCode(category.icon);

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ],
      ),
      child: Stack(
        children: [
          // هاله رنگی گوشه کارت
          Positioned(
            top: -30,
            left: -30, // در راست‌چین (RTL) این می‌افتد سمت چپ بالا
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: color.withValues(alpha: 0.25)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16)),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (category.pinToTop) ...[
                                Icon(Icons.push_pin_rounded,
                                    size: 14, color: color),
                                const SizedBox(width: 4),
                              ],
                              Expanded(
                                child: Text(
                                  category.title,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textMainLight,
                                      decoration: category.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (category.isCompleted)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: const Text('تکمیل شده',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                )
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  children: [
                                    Icon(Icons.circle, size: 6, color: color),
                                    const SizedBox(width: 4),
                                    Text('${category.activeTasks} تسک فعال',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: color,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_left_rounded,
                        color: AppColors.textMutedLight),
                  ],
                ),

                const SizedBox(height: 16),

                // پروگرس بار
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('میزان پیشرفت',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textMutedLight,
                            fontWeight: FontWeight.bold)),
                    Text('${category.progressPercent}٪',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: color)),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(10)),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: MediaQuery.of(context).size.width *
                          (category.progressPercent / 100),
                      height: 6,
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
