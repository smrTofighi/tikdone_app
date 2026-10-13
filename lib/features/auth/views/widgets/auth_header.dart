import 'package:flutter/material.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/gen/assets.gen.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.secondary,
                AppColors.tertiary
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Image.asset(Assets.images.logo.path),
        ),
        const SizedBox(height: 16),
        const Text(
          'تیک‌دان',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.textMainLight,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'نظم هوشمند، ذهن آرام؛ همه کارهایت در یک تیک',
          style: TextStyle(fontSize: 14, color: AppColors.textMutedLight),
        ),
      ],
    );
  }
}
