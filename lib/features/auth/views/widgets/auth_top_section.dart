import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tikdone_app/core/styles/extensions.dart';
import 'package:tikdone_app/core/styles/text_styles.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/core/values/dimens.dart';
import 'package:tikdone_app/core/values/strings.dart';

class AuthTopSection extends StatelessWidget {
  const AuthTopSection({
    super.key, required this.message, required this.btnText, required this.onTap,
  });
  final String message;
  final String btnText;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          (AppDimens.high * 2).height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: AppTextStyles.normal12(AppColors.white),
              ),
              AppDimens.small.width,
              TextButton(
                onPressed: onTap,
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.white24),
                ),
                child:  Text(
                  btnText,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ).animate(delay: 350.milliseconds).fade().move(),
          (AppDimens.high * 4).height,
          Text(
            PersianStrings.doIt,
            style: AppTextStyles.bold28Fanavari(AppColors.white),
          ).animate(delay: 350.milliseconds).fadeIn(),
        ],
      ),
    );
  }
}
