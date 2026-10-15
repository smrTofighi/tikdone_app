import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';

class CreateCategoryHeader extends StatelessWidget {
  const CreateCategoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded,
                color: AppColors.textMutedLight),
            onPressed: () => Get.back(),
          ),
          const Text(
            'ساخت دسته‌بندی جدید',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textMainLight,
            ),
          ),
          const SizedBox(width: 48), // برای وسط‌چین ماندن تایتل
        ],
      ),
    );
    
  }
}