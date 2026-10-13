import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/auth/view_model/auth_view_model.dart';
import 'package:tikdone_app/features/auth/views/widgets/login_form.dart';
import 'package:tikdone_app/features/auth/views/widgets/signup_form.dart';
import 'package:tikdone_app/features/auth/views/widgets/social_login_button.dart';

class AuthCard extends StatefulWidget {

  const AuthCard({
    super.key,
  });

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final AuthViewModel authVM = Get.put(AuthViewModel());
  final RxBool isLogin = true.obs;

  final RxBool isPasswordHidden = true.obs;

  final RxBool rememberMe = false.obs;

  final RxBool agreeTerms = true.obs;

  // کنترلرها و کلیدهای فرم
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  final TextEditingController emailCtrl = TextEditingController();

  final TextEditingController passCtrl = TextEditingController();

  final TextEditingController firstNameCtrl = TextEditingController();

  final TextEditingController lastNameCtrl = TextEditingController();


  
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardLight.withOpacity(0.85),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.05),
                blurRadius: 30,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabSwitcher(isLogin: isLogin),
              const SizedBox(height: 24),
              Obx(() {
                // متغیر کمکی برای اطمینان از خوانده شدن RxBool
                final loginMode = isLogin.value;
                return AnimatedCrossFade(
                  firstChild: LoginForm(
                    authVM: authVM,
                    formKey: loginFormKey,
                    emailCtrl: emailCtrl,
                    passCtrl: passCtrl,
                    isPasswordHidden: isPasswordHidden,
                    rememberMe: rememberMe,
                  ),
                  secondChild: SignupForm(
                    authVM: authVM,
                    formKey: signupFormKey,
                    emailCtrl: emailCtrl,
                    passCtrl: passCtrl,
                    firstNameCtrl: firstNameCtrl,
                    lastNameCtrl: lastNameCtrl,
                    isPasswordHidden: isPasswordHidden,
                    agreeTerms: agreeTerms,
                  ),
                  crossFadeState: loginMode
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                  sizeCurve: Curves.easeOutCubic,
                );
              }),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider(color: Colors.black12)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('یا ادامه از طریق',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600)),
                  ),
                  const Expanded(child: Divider(color: Colors.black12)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: SocialLoginButton(
                        icon: Icons.g_mobiledata_rounded,
                        title: 'گوگل',
                        iconColor: Colors.redAccent),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: SocialLoginButton(
                        icon: Icons.apple_rounded,
                        title: 'اپل آیدی',
                        iconColor: Colors.black),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TabSwitcher extends StatelessWidget {
  final RxBool isLogin;
  const TabSwitcher({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(() {
        // متغیر کمکی برای اطمینان از خوانده شدن در GetX
        final loginMode = isLogin.value;
        return Stack(
          children: [
            AnimatedAlign(
              alignment: loginMode
                  ? AlignmentDirectional.centerStart
                  : AlignmentDirectional.centerEnd,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: Container(
                width: (MediaQuery.of(context).size.width - 48 - 48 - 8) / 2,
                decoration: BoxDecoration(
                  color: AppColors.cardLight,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => isLogin.value = true,
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(
                        'ورود',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              loginMode ? FontWeight.bold : FontWeight.w500,
                          color: loginMode
                              ? AppColors.primary
                              : AppColors.textMutedLight,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => isLogin.value = false,
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(
                        'ثبت‌نام',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              !loginMode ? FontWeight.bold : FontWeight.w500,
                          color: !loginMode
                              ? AppColors.primary
                              : AppColors.textMutedLight,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
