import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/settings/view_model/setting_view_model.dart';


class SettingsPage extends GetView<SettingsViewModel> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildProfileCard(),
              const SizedBox(height: 24),
              _buildAppearanceSection(),
              const SizedBox(height: 24),
              _buildNotificationsSection(),
              const SizedBox(height: 24),
              _buildAccountSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'تنظیمات',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textMainLight),
    );
  }

  // =====================================
  // ۱. کارت پروفایل کاربر
  // =====================================
  Widget _buildProfileCard() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: Stack(
        children: [
          // هاله‌های نوری پس‌زمینه
          Positioned(
            top: -40, left: -40,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(width: 150, height: 150, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.15))),
            ),
          ),
          Positioned(
            bottom: -30, right: -30,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent.withValues(alpha: 0.15))),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // عکس و مشخصات
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60, height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 2),
                            image: const DecorationImage(
                              image: NetworkImage('https://i.pravatar.cc/150?img=11'), // عکس پروفایل تستی
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Text(controller.userName.value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMainLight))),
                            Obx(() => Text(controller.userEmail.value, style: const TextStyle(fontSize: 12, color: AppColors.textMutedLight))),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, color: AppColors.primary),
                      onPressed: () {}, // ویرایش پروفایل
                      style: IconButton.styleFrom(backgroundColor: AppColors.backgroundLight),
                    )
                  ],
                ),
                const SizedBox(height: 20),

                // نوار آمار خلاصه
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(color: AppColors.backgroundLight.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('${controller.completedTasks}', 'تسک تکمیل‌شده', AppColors.primary),
                      Container(width: 1, height: 30, color: Colors.grey.shade300),
                      _buildStatItem('${controller.currentStreak} روز', 'زنجیره پیوسته', Colors.orange),
                      Container(width: 1, height: 30, color: Colors.grey.shade300),
                      _buildStatItem('${controller.productivityScore}٪', 'بهره‌وری', Colors.blue),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMutedLight)),
      ],
    );
  }

  // =====================================
  // ۲. بخش ظاهر و پوسته
  // =====================================
  Widget _buildAppearanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.palette_rounded, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('شخصی‌سازی ظاهر', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.cardLight, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('حالت نمایش کلی', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
              const SizedBox(height: 12),

              // انتخابگر تم (Light/Dark/Auto)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    _buildThemeButton('light', 'روشن', Icons.light_mode_rounded),
                    _buildThemeButton('dark', 'تاریک', Icons.dark_mode_rounded),
                    _buildThemeButton('auto', 'خودکار', Icons.devices_rounded),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('رنگ اصلی (Accent)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
              const SizedBox(height: 12),

              // پالت رنگی
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildColorSwatch('blue', const Color(0xFF00B4D8)),
                  _buildColorSwatch('indigo', const Color(0xFF4361EE)),
                  _buildColorSwatch('green', const Color(0xFF10B981)),
                  _buildColorSwatch('orange', const Color(0xFFF97316)),
                  _buildColorSwatch('pink', const Color(0xFFF72585)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeButton(String mode, String title, IconData icon) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.themeMode.value == mode;
        return InkWell(
          onTap: () => controller.changeTheme(mode),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.cardLight : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : [],
            ),
            child: Column(
              children: [
                Icon(icon, size: 20, color: isSelected ? AppColors.primary : AppColors.textMutedLight),
                const SizedBox(height: 4),
                Text(title, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primary : AppColors.textMutedLight)),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildColorSwatch(String colorKey, Color colorValue) {
    return Obx(() {
      final isSelected = controller.accentColor.value == colorKey;
      return GestureDetector(
        onTap: () => controller.changeAccentColor(colorKey),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isSelected ? 44 : 36,
          height: isSelected ? 44 : 36,
          decoration: BoxDecoration(
            color: colorValue,
            shape: BoxShape.circle,
            boxShadow: isSelected ? [BoxShadow(color: colorValue.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))] : [],
          ),
          child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 20) : null,
        ),
      );
    });
  }

  // =====================================
  // ۳. تنظیمات اعلان‌ها
  // =====================================
  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.notifications_rounded, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('اعلان‌ها و یادآورها', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(color: AppColors.cardLight, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              _buildToggleRow(
                icon: Icons.wb_sunny_rounded,
                iconColor: Colors.orange,
                title: 'برنامه صبحگاهی',
                subtitle: 'ارسال لیست کارهای امروز در ساعت ۸ صبح',
                rxValue: controller.dailyBriefingEnabled,
                onChanged: controller.toggleDailyBriefing,
              ),
              Divider(height: 1, color: Colors.grey.shade200, indent: 50, endIndent: 20),
              _buildToggleRow(
                icon: Icons.alarm_rounded,
                iconColor: Colors.blue,
                title: 'یادآور سررسید تسک‌ها',
                subtitle: 'ارسال اعلان قبل از پایان مهلت کارها',
                rxValue: controller.taskRemindersEnabled,
                onChanged: controller.toggleTaskReminders,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleRow({required IconData icon, required Color iconColor, required String title, required String subtitle, required RxBool rxValue, required Function(bool) onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textMutedLight)),
              ],
            ),
          ),
          Obx(() => CupertinoSwitch(
            value: rxValue.value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          )),
        ],
      ),
    );
  }

  // =====================================
  // ۴. مدیریت حساب کاربری (خروج)
  // =====================================
  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('حساب کاربری', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(color: AppColors.cardLight, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              _buildActionRow(Icons.download_rounded, 'دریافت خروجی اطلاعات', AppColors.textMainLight, () {}),
              Divider(height: 1, color: Colors.grey.shade200, indent: 50, endIndent: 20),
              _buildActionRow(Icons.logout_rounded, 'خروج از حساب کاربری', Colors.red, controller.logout),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
            const Spacer(),
            Icon(Icons.chevron_left_rounded, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }
}