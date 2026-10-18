import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/values/colors.dart';
import '../../../view-model/categories_view_model.dart';

class CategoriesSearchBar extends GetView<CategoriesViewModel> {
  const CategoriesSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: controller.updateSearch,
        decoration: InputDecoration(
          hintText: 'جستجو در بین دسته‌بندی‌ها...',
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
          filled: true,
          fillColor: AppColors.cardLight,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
