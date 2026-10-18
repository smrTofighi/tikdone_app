import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:tikdone_app/core/values/colors.dart';

import '../view_model/home_view_model.dart';
// import 'home_view_model.dart'; // مسیر کنترلر بالا را اینجا قرار دهید

class HomePage extends GetView<HomeViewModel> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          // حاشیه پایین 100 برای جلوگیری از رفتن محتوا زیر Bottom Navigation
          padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildGreetingBanner(context),
              const SizedBox(height: 24),
              _buildCategoriesSlider(),
              const SizedBox(height: 24),
              _buildActiveTasksHeader(),
              const SizedBox(height: 12),
              _buildActiveTasksList(),
              const SizedBox(height: 24),
              _buildCompletedTasksSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // ۱. بنر خوش‌آمدگویی و پروگرس روزانه
  // ==========================================
  Widget _buildGreetingBanner(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Stack(
        children: [
          // هاله‌های نوری پس‌زمینه
          Positioned(
            top: -40, left: -40,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.15))),
            ),
          ),
          Positioned(
            bottom: -30, right: -30,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.purpleAccent.withValues(alpha: 0.15))),
            ),
          ),

          // محتوای اصلی بنر
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('سلام، ${controller.userName} عزیز', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
                        const SizedBox(width: 6),
                        const Text('👋', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(controller.todayDate, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('روز پرانرژی و موفقی داشته باشی! برنامه‌ات آماده است:', style: TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
                const SizedBox(height: 16),

                // کارتِ پروگرس داخلی
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.backgroundLight.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.verified_rounded, size: 16, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: '${controller.completedTasksCount}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                                    const TextSpan(text: ' تسک انجام شده از '),
                                    TextSpan(text: '${controller.totalTasksCount} کار امروز'),
                                  ],
                                ),
                                style: const TextStyle(fontSize: 11, color: AppColors.textMainLight),
                              ),
                            ],
                          ),
                          Text('${controller.progressPercentInt}٪', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // نوار پیشرفت سفارشی با گرادیانت
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                        child: Align(
                          alignment: Alignment.centerRight, // چون راست‌چین است
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOut,
                            width: (MediaQuery.of(context).size.width - 90) * controller.progressPercent,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [AppColors.primary, Colors.blueAccent]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
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

  // ==========================================
  // ۲. اسلایدر دسته‌بندی‌ها
  // ==========================================
  Widget _buildCategoriesSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(width: 4, height: 16, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: 6),
                const Text('دسته‌بندی‌ها', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
              ],
            ),
            InkWell(
              onTap: () {}, // رفتن به تب دسته‌ها
              child: const Row(
                children: [
                  Text('مشاهده همه', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
                  Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          // استفاده از ListView افقی برای اسکرول دسته‌ها
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none, // برای بریده نشدن سایه‌ها
            children: [
              _buildCategoryCard('سرویس ماشین', '۲ تسک', FluentIcons.vehicle_car_24_regular, Colors.blue),
              const SizedBox(width: 12),
              _buildCategoryCard('خرید روزمره', '۱ تسک', FluentIcons.cart_24_regular, Colors.red),
              const SizedBox(width: 12),
              _buildCategoryCard('ایده‌ها و کار', '۳ تسک', FluentIcons.lightbulb_24_regular, Colors.teal),
              const SizedBox(width: 12),
              _buildCategoryCard('کارهای منزل', '۱ تسک', FluentIcons.home_24_regular, Colors.purple),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, String subtitle, IconData icon, MaterialColor color) {
    return Container(
      width: 120,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Stack(
        children: [
          // هاله رنگی پایین
          Positioned(
            bottom: -20, left: -20,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(width: 60, height: 60, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.3))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: color.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: color, size: 20),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMainLight), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textMutedLight)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ۳. لیست تسک‌های در انتظار
  // ==========================================
  Widget _buildActiveTasksHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 4, height: 16, decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4))),
            const SizedBox(width: 6),
            const Text('وظایف در انتظار', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
              child: const Text('۳', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange)),
            )
          ],
        ),
        IconButton(
          icon: const Icon(Icons.tune_rounded, size: 20, color: AppColors.textMutedLight),
          onPressed: () {},
          constraints: const BoxConstraints(),
          padding: EdgeInsets.zero,
        )
      ],
    );
  }

  Widget _buildActiveTasksList() {
    return Column(
      children: [
        _buildActiveTaskItem('بررسی روغن ترمز و لنت', 'سرویس ماشین', 'فوری', '۱۰:۳۰', Colors.blue, isHighPriority: true),
        const SizedBox(height: 10),
        _buildActiveTaskItem('خرید میوه تازه و نان', 'خرید روزمره', null, '۱۶:۰۰', Colors.red),
        const SizedBox(height: 10),
        _buildActiveTaskItem('طراحی ساختار داشبورد', 'ایده‌ها و کار', null, '۱۸:۴۵', Colors.teal),
      ],
    );
  }

  Widget _buildActiveTaskItem(String title, String catName, String? priority, String time, Color catColor, {bool isHighPriority = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // دکمه تیک
          InkWell(
            onTap: () {},
            child: Container(
              width: 24, height: 24,
              decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.check_rounded, size: 16, color: Colors.transparent),
            ),
          ),
          const SizedBox(width: 12),
          // متن و تگ‌ها
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMainLight), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: [
                    _buildTag(catName, catColor),
                    if (priority != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.priority_high_rounded, size: 10, color: Colors.red),
                            const SizedBox(width: 2),
                            Text(priority, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red)),
                          ],
                        ),
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.schedule_rounded, size: 12, color: AppColors.textMutedLight),
                        const SizedBox(width: 4),
                        Text(time, style: const TextStyle(fontSize: 10, color: AppColors.textMutedLight)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert_rounded, size: 20, color: AppColors.textMutedLight),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 6, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // ==========================================
  // ۴. تسک‌های تکمیل شده (Collapsible)
  // ==========================================
  Widget _buildCompletedTasksSection() {
    return Column(
      children: [
        InkWell(
          onTap: controller.toggleCompleted,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 20, color: AppColors.primary),
                    const SizedBox(width: 8),
                    const Text('تسک‌های انجام‌شده امروز', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMutedLight)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
                      child: Text('${controller.completedTasksCount}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
                    )
                  ],
                ),
                Obx(() => AnimatedRotation(
                  turns: controller.isCompletedExpanded.value ? 0 : -0.25,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.expand_more_rounded, size: 20, color: AppColors.textMutedLight),
                )),
              ],
            ),
          ),
        ),
        Obx(() => AnimatedCrossFade(
          firstChild: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                _buildCompletedTaskItem('مطالعه ۲۰ صفحه کتاب', '۰۸:۱۵'),
                const SizedBox(height: 8),
                _buildCompletedTaskItem('آبیاری گلدان‌ها', '۰۹:۰۰'),
              ],
            ),
          ),
          secondChild: const SizedBox(width: double.infinity, height: 0),
          crossFadeState: controller.isCompletedExpanded.value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        )),
      ],
    );
  }

  Widget _buildCompletedTaskItem(String title, String time) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.cardLight.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.check_rounded, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, decoration: TextDecoration.lineThrough, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.done_all_rounded, size: 18, color: AppColors.primary),
        ],
      ),
    );
  }
}