import 'package:flutter/material.dart';
import '../../../../core/styles/input_decoration.dart';
import '../../../../core/values/colors.dart'; // حاوی ThemeHelper
import '../../../../core/values/dimens.dart';
import '../../../../data/models/category_model.dart';

class TaskSinglePageTextField extends StatelessWidget {
  const TaskSinglePageTextField({
    super.key,
    required this.controller,
    required this.categoryModel,
    this.icon = const SizedBox(),
    required this.validator,
    required this.onChanged,
  });

  final TextEditingController controller;
  final CategoryModel categoryModel;
  final String? Function(String?) validator;
  final Function(String) onChanged;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    // خواندن رنگ از روی تم ذخیره شده
    final currentColor = ThemeHelper.parsePrimaryColor(categoryModel.theme);

    return TextFormField(
      validator: validator,
      onChanged: onChanged,
      cursorColor: currentColor,
      controller: controller,
      decoration: AppInputDecoration.textFieldAddEditTaskPage.copyWith(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: currentColor, width: 2),
          borderRadius: BorderRadius.circular(AppDimens.radius),
        ),
        suffixIcon: icon,
      ),
    );
  }
}
