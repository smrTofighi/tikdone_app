import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/routes/pages.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/analytics/views/analytics_page.dart';
import 'package:tikdone_app/features/category/views/pages/categories_page.dart';
import 'package:tikdone_app/features/home/views/home_page.dart';
import 'package:tikdone_app/features/main/view_model/main_view_model.dart';
import 'package:tikdone_app/features/settings/views/settings_page.dart';

// کنترلر ساده برای مدیریت تب‌های نوار پایین


class MainPage extends StatelessWidget {

  MainPage({super.key});
  final controller = Get.find<MainViewModel>();
  final List<Widget> pages = [
    HomePage(),
    CategoriesPage(),
    AnalyticsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        // ExtendBody باعث می‌شود محتوای صفحه زیر نوار شیشه‌ای پایین هم برود
        extendBody: true,
        body: Obx(() => pages[controller.selectedIndex.value]),

        // قرار دادن نوار سفارشی ما در پایین صفحه
        bottomNavigationBar: const GlassmorphicBottomNav(),
      ),
    );
  }
}

class GlassmorphicBottomNav extends StatelessWidget {
  const GlassmorphicBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final MainViewModel controller = Get.find<MainViewModel>();

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        height: 70, // ارتفاع کپسول اصلی
        child: Stack(
          clipBehavior: Clip.none, // اجازه می‌دهد دکمه مثبت از کادر بیرون بزند
          children: [
            // پس‌زمینه شیشه‌ای
            ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardLight.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        blurRadius: 32,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(controller, 0, Icons.home_rounded, 'خانه'),
                      _buildNavItem(
                          controller, 1, Icons.folder_open_rounded, 'دسته‌ها'),

                      // فضای خالی برای دکمه Add که وسط قرار می‌گیرد
                      const SizedBox(width: 60),

                      _buildNavItem(
                          controller, 2, Icons.donut_large_rounded, 'آمار'),
                      _buildNavItem(controller, 3,
                          Icons.manage_accounts_rounded, 'تنظیمات'),
                    ],
                  ),
                ),
              ),
            ),

            // دکمه FAB (تسک جدید) در مرکز و کمی بالاتر
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: const Offset(0, -20), // بالا کشیدن دکمه
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppPages.createCategory);
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary,
                          AppColors.secondary
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // متد سازنده آیتم‌های تب با انیمیشن‌های ترکیبی
  Widget _buildNavItem(
      MainViewModel controller, int index, IconData icon, String label) {
    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior:
          HitTestBehavior.opaque, // باعث میشه کل فضای SizedBox قابل کلیک باشه
      child: Obx(() {
        final isSelected = controller.selectedIndex.value == index;

        return SizedBox(
          width: 52,
          // لایه اول انیمیشن: شناور شدن آیتم انتخاب شده به سمت بالا
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack, // افکت فنری
            transform: Matrix4.translationValues(0, isSelected ? -4.0 : 0.0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // لایه دوم انیمیشن: بزرگ شدن (Scale) و پرش آیکون
                AnimatedScale(
                  scale: isSelected ? 1.25 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  child: Icon(
                    icon,
                    size:
                        24, // سایز پایه را کمی کوچک کردیم که جا برای Scale باشد
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textMutedLight,
                  ),
                ),
                const SizedBox(height: 4),

                // لایه سوم انیمیشن: تغییر شفافیت متن
                AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textMutedLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
