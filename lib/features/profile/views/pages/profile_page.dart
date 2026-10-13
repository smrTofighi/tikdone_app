import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:tikdone_app/core/styles/text_styles.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/core/values/dimens.dart';
import 'package:tikdone_app/features/profile/view_model/profile_view_model.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final ProfileViewModel profileVM = Get.find<ProfileViewModel>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'حساب کاربری',
            style: AppTextStyles.titleOfAppBar,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            color: Colors.black,
            icon: const Icon(
              FluentIcons.arrow_left_24_regular,
              size: 22,
            ),
          ),
        ),
        body: SizedBox(
          width: AppDimens.sizeOfDevice(context).width,
          child: Column(
            children: [
              Gap(AppDimens.high * 3),
              Obx(() =>
                  profileVM.isEditing.value ? ProfileEdit() : ProfileInfo()),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileEdit extends StatelessWidget {
  ProfileEdit({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProfileViewModel profileVM = Get.find<ProfileViewModel>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Obx(
              () => ProfileImageFile(
                image: profileVM.model.image.value,
                onTap: () {
                  profileVM.setImage();
                },
              ),
            ),
            Gap(AppDimens.high * 3),
            // TextFormField(
            //   controller: profileVM.nameEditingController,
            // ),
            // Gap(AppDimens.high * 3),
            ProfileButton(
              title: 'ذخیره',
              color: Colors.green,
              onTap: () {
                profileVM.isEditing(false);
              },
            ),
          ],
        ),
      ),
    ).animate(delay: const Duration(milliseconds: 250)).fadeIn();
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileViewModel>(
      builder: (profileVM) => Column(
        children: [
          ProfileImage(
            image: profileVM.model.userModel.image ?? '',
          ),
          Gap(AppDimens.high),
          ProfileName(
            name: profileVM.model.userModel.name,
          ),
          Gap(AppDimens.medium),
          ProfileEmail(
            email: profileVM.model.userModel.email,
          ),
          Gap(AppDimens.high * 2),
          ProfileButton(
            title: 'ویرایش',
            color: AppColors.primary,
            onTap: () {
              profileVM.isEditing.value = true;
            },
          ),
          Gap(AppDimens.high * 2),
          ProfileButton(
            title: 'خروج از حساب کاربری',
            color: Colors.red,
            onTap: () {},
          ),
        ],
      ).animate(delay: const Duration(milliseconds: 250)).fadeIn(),
    );
  }
}

class ProfileEmail extends StatelessWidget {
  const ProfileEmail({
    super.key,
    required this.email,
  });
  final String email;
  @override
  Widget build(BuildContext context) {
    return Text(
      email,
      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
    );
  }
}

class ProfileName extends StatelessWidget {
  const ProfileName({
    super.key,
    required this.name,
  });
  final String name;
  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    required this.image,
  });
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      height: 85,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.primary)),
      child: image.isEmpty
          ? const Icon(
              Icons.person,
              color: AppColors.primary,
              size: 75,
            )
          : Image.network(image),
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.title,
    required this.color,
    required this.onTap,
  });
  final String title;
  final Color color;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileImageFile extends StatelessWidget {
  const ProfileImageFile({
    super.key,
    required this.image,
    required this.onTap,
  });
  final File? image;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 85,
        height: 85,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.primary)),
        child: image!.path == ''
            ? const Icon(
                Icons.person,
                color: AppColors.primary,
                size: 75,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.file(
                  image!,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
