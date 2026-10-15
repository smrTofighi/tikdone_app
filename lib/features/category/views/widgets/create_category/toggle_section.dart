import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/category/view-model/create_category_view_model.dart';

class TogglesSection extends StatelessWidget {
  const TogglesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateCategoryViewModel>();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.cardLight, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildToggleItem(
            icon: Icons.push_pin_rounded,
            title: 'سنجاق به اول لیست',
            subtitle: 'دسترسی سریع‌تر در بالای دسته‌ها',
            rxValue: controller.pinToTop,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(
      {required IconData icon,
      required String title,
      required String subtitle,
      required RxBool rxValue}) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMainLight)),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textMutedLight)),
            ],
          ),
        ),
        Obx(() => Switch(
              value: rxValue.value,
              onChanged: (val) => rxValue.value = val,
              activeThumbColor: AppColors.primary,
            )),
      ],
    );
  }
}
