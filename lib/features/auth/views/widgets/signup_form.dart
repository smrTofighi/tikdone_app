import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/auth/view_model/auth_view_model.dart';
import 'package:tikdone_app/features/auth/views/widgets/auth_button.dart';
import 'package:tikdone_app/features/auth/views/widgets/custom_textfield.dart';

class SignupForm extends StatelessWidget {
  final AuthViewModel authVM;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final RxBool isPasswordHidden;
  final RxBool agreeTerms;

  const SignupForm({
    super.key,
    required this.authVM,
    required this.formKey,
    required this.emailCtrl,
    required this.passCtrl,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.isPasswordHidden,
    required this.agreeTerms,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                  child: CustomTextField(
                      label: 'نام',
                      icon: Icons.badge_outlined,
                      controller: firstNameCtrl)),
              const SizedBox(width: 12),
              Expanded(
                  child: CustomTextField(
                      label: 'نام خانوادگی',
                      icon: Icons.person_outline,
                      controller: lastNameCtrl)),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
              label: 'پست الکترونیکی',
              icon: Icons.alternate_email_rounded,
              controller: emailCtrl),
          const SizedBox(height: 16),
          CustomTextField(
              label: 'رمز عبور (حداقل ۸ کاراکتر)',
              icon: Icons.lock_outline_rounded,
              controller: passCtrl,
              isPassword: true,
              isPasswordHidden: isPasswordHidden),
          const SizedBox(height: 12),
          Row(
            children: [
              Obx(() {
                final checked = agreeTerms.value;
                return Checkbox(
                  value: checked,
                  onChanged: (val) => agreeTerms.value = val!,
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                );
              }),
              const Text('قوانین و حریم خصوصی را می‌پذیرم',
                  style: TextStyle(fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          AuthButton(
            text: 'ایجاد حساب کاربری',
            isLoading: authVM.isLoading,
            onTap: () {
              if (formKey.currentState!.validate() && agreeTerms.value) {
                authVM.signUpUser(
                  email: emailCtrl.text.trim(),
                  password: passCtrl.text.trim(),
                  firstName: firstNameCtrl.text.trim(),
                  lastName: lastNameCtrl.text.trim(),
                  context: context,
                );
              } else if (!agreeTerms.value) {
                Get.snackbar('خطا', 'پذیرش قوانین الزامی است',
                    backgroundColor: Colors.redAccent, colorText: Colors.white);
              }
            },
          ),
        ],
      ),
    );
  }
}
