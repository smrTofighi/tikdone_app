import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/auth/view_model/auth_view_model.dart';
import 'package:tikdone_app/gen/assets.gen.dart';
import '../main/widgets/loading.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // متغیر کنترل‌کننده انیمیشن محوشونده
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    AuthViewModel authVM = Get.find<AuthViewModel>();

    // استارت انیمیشن بلافاصله بعد از رندر شدن فریم اول
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });

    // بعد از ۳ ثانیه بررسی سشن و انتقال به صفحه بعد
    Future.delayed(const Duration(seconds: 3))
        .then((value) => authVM.checkSession());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // ==========================================
          // 1. هاله‌های نوری پس‌زمینه (Ambient Glows)
          // ==========================================
          Positioned(
            top: -150,
            right: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.35),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.tertiary.withValues(alpha: 0.25),
                ),
              ),
            ),
          ),

          // ==========================================
          // 2. محتوای اصلی (لوگو و نام اپلیکیشن)
          // ==========================================
          AnimatedOpacity(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            opacity: _opacity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // لوگوی اپلیکیشن با سایه ملایم
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(38),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 40,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(38),
                      // فراخوانی لوگو از طریق کلاس جنریت شده FlutterGen
                      child: Assets.images.logo.image(fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // تایپوگرافی نام اپلیکیشن
                  const Text(
                    'TickDone',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textMainLight,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'تیک‌دان',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ==========================================
          // 3. لودینگ و متن وضعیت در پایین صفحه
          // ==========================================
          AnimatedOpacity(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInExpo,
            opacity: _opacity,
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 48.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Loading(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text(
                      'در حال همگام‌سازی...',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
