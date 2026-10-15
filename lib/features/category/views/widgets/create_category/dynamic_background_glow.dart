import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/category/view-model/create_category_view_model.dart';

class DynamicBackgroundGlow extends StatelessWidget {
  const DynamicBackgroundGlow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateCategoryViewModel>();
    return Obx(() {
      final color =
          ThemeHelper.parsePrimaryColor(controller.selectedTheme.value);

      return Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      color.withValues(alpha: 0.15)
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
