import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/values/colors.dart';

class CreateTaskAppBar extends StatelessWidget {
  const CreateTaskAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('افزودن تسک جدید',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMainLight)),
                  Text('انجامش بده و ذهنت رو آزاد کن!',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textMutedLight)),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded,
                color: AppColors.textMutedLight),
            onPressed: () => Get.back(),
            style: IconButton.styleFrom(backgroundColor: AppColors.cardLight),
          ),
        ],
      ),
    );
  }
}
