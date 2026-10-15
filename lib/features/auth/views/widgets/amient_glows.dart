import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tikdone_app/core/values/colors.dart';
class AmbientGlows extends StatelessWidget {
  const AmbientGlows({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -80,
          // استفاده از ImageFiltered به جای BackdropFilter برای جلوگیری از باگ رندرینگ
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
        Positioned(
          top: 200,
          left: -100,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
