import 'package:flutter/material.dart';

import '../../../../../core/values/colors.dart';

class CategoriesAppBar extends StatelessWidget {
  const CategoriesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('دسته‌بندی‌های من',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMainLight)),
              Text('مدیریت فضاها، کارها و روتین‌ها',
                  style:
                  TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
            ],
          ),

        ],
      ),
    );
  }
}
