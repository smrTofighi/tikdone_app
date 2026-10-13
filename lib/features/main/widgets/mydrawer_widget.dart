import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:tikdone_app/core/routes/pages.dart';
import '../../../../../core/values/colors.dart';
import '../../../../../core/values/dimens.dart';

// ignore: must_be_immutable
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DrawerWidget(
              title: 'حساب کاربری',
              icon: FluentIcons.person_24_regular,
              color: AppColors.primary,
              onTap: () {
                Get.toNamed(PageName.profile);
              },
            ),
            const Divider(
              color: Colors.grey,
            ),
            DrawerWidget(
              title: 'درباره ما',
              icon: FluentIcons.info_20_regular,
              color: AppColors.primary,
              onTap: () {},
            ),
            DrawerWidget(
              title: 'معرفی به دوستان',
              icon: FluentIcons.share_20_regular,
              color: AppColors.primary,
              onTap: () {},
            ),
            const Divider(
              color: Colors.grey,
            ),
            DrawerWidget(
              title: 'خروج',
              icon: FluentIcons.sign_out_20_regular,
              color: AppColors.error,
              onTap: () {},
            ),
          ],
        ),
      )),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      required this.onTap});
  final String title;
  final IconData icon;
  final Color color;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        width: AppDimens.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: color,
                ),
                const Gap(
                  12,
                ),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
