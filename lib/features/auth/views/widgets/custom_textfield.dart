import 'package:flutter/material.dart';
import 'package:tikdone_app/core/styles/text_styles.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/core/values/dimens.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.type = TextInputType.text,
    required this.validator,
  });
  final TextEditingController controller;
  final String hint;
  final TextInputType? type;
  final String? Function(String? val) validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.high),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        style: AppTextStyles.normal14(AppColors.blackText),
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
        ),
      ),
    );
  }
}
