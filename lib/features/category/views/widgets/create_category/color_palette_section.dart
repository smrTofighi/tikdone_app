import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/category/view-model/create_category_view_model.dart';

class ColorPaletteSection extends StatelessWidget {
  const ColorPaletteSection({super.key});

  // دیتای رنگ‌ها (فقط کد تم و رنگ)
  final List<Map<String, dynamic>> colors = const [
    {'theme': 'solid_#00B4D8', 'color': AppColors.primary},
    {'theme': 'solid_#3B82F6', 'color': Colors.blueAccent},
    {'theme': 'solid_#8B5CF6', 'color': Colors.purpleAccent},
    {'theme': 'solid_#EF4444', 'color': Colors.redAccent},
    {'theme': 'solid_#F97316', 'color': Colors.orange},
    {'theme': 'solid_#10B981', 'color': Colors.green},
    {'theme': 'solid_#EC4899', 'color': Colors.pinkAccent},
    {'theme': 'solid_#6366F1', 'color': Colors.indigoAccent},
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateCategoryViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('رنگ اختصاصی',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMainLight)),
            Text('هنگام ورود، هاله با این رنگ جان می‌گیرد',
                style:
                    TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors.map((c) {
            final themeString = c['theme'] as String;
            final color = c['color'] as Color;
            return Obx(() {
              final isSelected = controller.selectedTheme.value == themeString;
              return GestureDetector(
                onTap: () => controller.updateColor(themeString),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                                color: color.withValues(alpha: 0.5),
                                blurRadius: 8,
                                offset: const Offset(0, 4))
                          ]
                        : [],
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }
}
