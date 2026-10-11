import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tikdone_app/core/styles/text_styles.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/core/values/dimens.dart';

class AuthTile extends StatelessWidget {
  const AuthTile({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: AppTextStyles.bigTitle,
        ),
        Gap(AppDimens.small),
        Text(
          subtitle,
          style: AppTextStyles.normal12(AppColors.greyText),
        ),
      ],
    );
  }
}
