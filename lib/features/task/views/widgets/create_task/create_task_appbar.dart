import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/values/colors.dart';
import '../../../view_model/create_task_view_model.dart'; // اضافه کردن ویومدل

class CreateTaskAppBar extends GetView<CreateTaskViewModel> {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // تغییر هوشمند عنوان
                  Text(controller.isEditing ? 'ویرایش تسک' : 'افزودن تسک جدید',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMainLight)),
                  // تغییر هوشمند زیرنویس
                  Text(
                      controller.isEditing
                          ? 'جزئیات تسک رو به‌روزرسانی کن!'
                          : 'انجامش بده و ذهنت رو آزاد کن!',
                      style: const TextStyle(
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
