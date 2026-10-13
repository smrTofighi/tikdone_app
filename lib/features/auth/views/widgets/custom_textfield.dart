import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final RxBool? isPasswordHidden;

  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.isPasswordHidden,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textMainLight),
        ),
        const SizedBox(height: 8),
        isPassword && isPasswordHidden != null
            ? Obx(() {
                // متغیر کمکی برای اطمینان از رجیستر شدن استیت پسورد
                final obscure = isPasswordHidden!.value;
                return _buildInput(obscure, true);
              })
            : _buildInput(false, false),
      ],
    );
  }

  Widget _buildInput(bool obscure, bool showEyeIcon) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (value) =>
          value == null || value.isEmpty ? 'این فیلد الزامی است' : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.backgroundLight,
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
        suffixIcon: showEyeIcon
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey.shade500,
                  size: 20,
                ),
                onPressed: () {
                  if (isPasswordHidden != null) {
                    isPasswordHidden!.toggle();
                  }
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
