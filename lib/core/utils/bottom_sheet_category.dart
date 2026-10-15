import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart'; // حاوی ThemeHelper
import 'package:tikdone_app/core/values/icons.dart'; // حاوی AppIcons
import 'package:tikdone_app/core/values/strings.dart';
import 'package:tikdone_app/features/main/widgets/loading.dart';
import 'package:tikdone_app/features/category/view-model/main_category_view_model.dart';
import '../../features/main/main_category/views/widgets/color_widget.dart';


class IconWidget extends StatelessWidget {
  const IconWidget({
    super.key,
    required this.iconKey,
    required this.selectedIconKey,
    required this.selectedThemeString,
    required this.onTap,
  });

  final int iconKey;
  final String selectedIconKey;
  final String selectedThemeString;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = iconKey == selectedIconKey;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentColor = ThemeHelper.parsePrimaryColor(selectedThemeString);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: 46,
        height: 46,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: isSelected
              ? currentColor.withValues(alpha: 0.15)
              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? currentColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Icon(
            AppIcons.getIconFromCode(iconKey),
            size: 24,
            color: isSelected
                ? currentColor
                : (isDark ? Colors.white38 : Colors.grey.shade500),
          ),
        ),
      ),
    );
  }
}
