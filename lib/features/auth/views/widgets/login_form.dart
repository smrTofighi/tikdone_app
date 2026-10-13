import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/auth/view_model/auth_view_model.dart';
import 'package:tikdone_app/features/auth/views/widgets/auth_button.dart';
import 'package:tikdone_app/features/auth/views/widgets/custom_textfield.dart';

class LoginForm extends StatelessWidget {
  final AuthViewModel authVM;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final RxBool isPasswordHidden;
  final RxBool rememberMe;

  const LoginForm({
    super.key,
    required this.authVM,
    required this.formKey,
    required this.emailCtrl,
    required this.passCtrl,
    required this.isPasswordHidden,
    required this.rememberMe,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
              label: 'پست الکترونیکی',
              icon: Icons.alternate_email_rounded,
              controller: emailCtrl),
          const SizedBox(height: 16),
          CustomTextField(
              label: 'رمز عبور',
              icon: Icons.lock_outline_rounded,
              controller: passCtrl,
              isPassword: true,
              isPasswordHidden: isPasswordHidden),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Obx(() {
                    final checked = rememberMe.value;
                    return Checkbox(
                      value: checked,
                      onChanged: (val) => rememberMe.value = val!,
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    );
                  }),
                  const Text('مرا به خاطر بسپار',
                      style: TextStyle(fontSize: 13)),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('فراموشی رمز؟',
                    style: TextStyle(fontSize: 13, color: AppColors.secondary)),
              )
            ],
          ),
          const SizedBox(height: 16),
          AuthButton(
            text: 'ورود به تیک‌دان',
            isLoading: authVM.isLoading,
            onTap: () {
              if (formKey.currentState!.validate()) {
                authVM.logInUser(
                  email: emailCtrl.text.trim(),
                  password: passCtrl.text.trim(),
                  context: context,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
