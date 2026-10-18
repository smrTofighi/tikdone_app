import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/routes/pages.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/core/values/strings.dart';
import 'package:tikdone_app/features/auth/view_model/auth_view_model.dart';
import 'package:tikdone_app/features/main/widgets/loading.dart';
import 'package:validators/validators.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthViewModel authVM = Get.find<AuthViewModel>();

  bool _isPasswordObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // --- بخش هدر و لوگوی تیک‌دان ---
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.task_alt_rounded, // آیکون جدید و مرتبط با تیک‌دان
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ).animate().scale(
                        delay: 100.ms,
                        duration: 400.ms,
                        curve: Curves.easeOutBack),

                    const Gap(16),
                    Text(
                      'تیک‌دان',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ).animate().fade(delay: 200.ms).slideY(begin: 0.2, end: 0),

                    const Gap(8),
                    Text(
                      PersianStrings.welcomeBack,
                      style: TextStyle(
                        color: isDark
                            ? Colors.blueGrey.shade300
                            : Colors.grey.shade600,
                        fontSize: 15,
                      ),
                    ).animate().fade(delay: 300.ms).slideY(begin: 0.2, end: 0),

                    const Gap(40),

                    // --- بخش فرم ---
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color:
                              isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black26
                                  : AppColors.primary.withValues(alpha: 0.05),
                              blurRadius: 32,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  color:
                                      isDark ? Colors.white : Colors.black87),
                              decoration: InputDecoration(
                                labelText: 'ایمیل',
                                prefixIcon: Icon(Icons.alternate_email_rounded,
                                    color: AppColors.primary),
                                filled: true,
                                fillColor: isDark
                                    ? const Color(0xFF0F172A)
                                    : const Color(0xFFF1F5F9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return PersianStrings.requiredText;
                                }
                                if (!isEmail(val.trim())) {
                                  return PersianStrings.emailFormatIsNotTrue;
                                }
                                return null;
                              },
                            ),
                            const Gap(20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _isPasswordObscure,
                              style: TextStyle(
                                  color:
                                      isDark ? Colors.white : Colors.black87),
                              decoration: InputDecoration(
                                labelText: 'رمز عبور',
                                prefixIcon: Icon(Icons.lock_outline_rounded,
                                    color: AppColors.primary),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordObscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.black45,
                                  ),
                                  onPressed: () => setState(() =>
                                      _isPasswordObscure = !_isPasswordObscure),
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? const Color(0xFF0F172A)
                                    : const Color(0xFFF1F5F9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return PersianStrings.requiredText;
                                }
                                return null;
                              },
                            ),
                            const Gap(32),
                            SizedBox(
                              height: 54,
                              child: Obx(
                                () => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: authVM.isLoading.value
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            authVM.logInUser(
                                              email:
                                                  _emailController.text.trim(),
                                              password:
                                                  _passwordController.text,
                                              context: context,
                                            );
                                          }
                                        },
                                  child: authVM.isLoading.value
                                      ? const Loading(
                                          color: Colors.white, size: 24)
                                      : const Text(
                                          PersianStrings.signin,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fade(delay: 400.ms, duration: 500.ms).slideY(
                          begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                    ),

                    const Spacer(),

                    // --- فوتر ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          PersianStrings.dontHaveAnAccount,
                          style: TextStyle(
                              color: isDark
                                  ? Colors.white60
                                  : Colors.grey.shade600),
                        ),
                        TextButton(
                          onPressed: () => Get.offNamed(AppPages.signUp),
                          child: Text(
                            PersianStrings.signup,
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ).animate().fade(delay: 600.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
