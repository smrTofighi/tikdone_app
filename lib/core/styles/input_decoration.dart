import 'package:flutter/material.dart';
import 'package:tikdone_app/core/values/dimens.dart';

import '../values/colors.dart';


class AppInputDecoration {
  AppInputDecoration._();
  static  InputDecoration textFieldAddEditTaskPage = InputDecoration(
    filled: true,
    fillColor: AppColors.backGround,
    labelText: 'چه برنامه ای داری؟',
    floatingLabelStyle: const TextStyle(
      color: AppColors.grey,
    ),
    labelStyle: const TextStyle(fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.radius)
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primary),
      borderRadius: BorderRadius.circular(AppDimens.radius)
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.radius)
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(AppDimens.radius)
    ),
    disabledBorder: InputBorder.none,
  );

  static InputDecoration textFieldDescription = InputDecoration(
    filled: true,
    fillColor: AppColors.backGround,
    labelText: 'توضیحات',
    floatingLabelStyle: const TextStyle(
      color: AppColors.grey,
    ),
    labelStyle: const TextStyle(fontSize: 14),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radius)
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(AppDimens.radius)
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radius)
    ),
    errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(AppDimens.radius)
    ),
    disabledBorder: InputBorder.none,
  );
}
