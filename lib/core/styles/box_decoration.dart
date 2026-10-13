import 'package:flutter/material.dart';

import '../values/colors.dart';
import '../values/dimens.dart';

class AppBoxDecoration {
  AppBoxDecoration._();

  static BoxDecoration whiteRadius = BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(AppDimens.radius),
      topRight: Radius.circular(AppDimens.radius),
    ),
    color: AppColors.backGround,
  );

  static BoxDecoration taskWidgetDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(AppDimens.radius),
    color: AppColors.cardLight,
    boxShadow: [
      BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 5,
          spreadRadius: 0.2)
    ],
  );
}
