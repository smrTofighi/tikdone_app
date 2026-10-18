import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart'; // پکیج رسم نمودار
import 'package:tikdone_app/core/values/colors.dart';

import '../view_model/analytics_view_model.dart';
// import 'package:tikdone_app/features/analytics/view-model/analytics_view_model.dart';

class AnalyticsPage extends GetView<AnalyticsViewModel> {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100), // فاصله برای باتم نویگیشن
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildTimeRangeSelector(),
              const SizedBox(height: 24),
              _buildHeroCard(),
              const SizedBox(height: 24),
              _buildBarChartSection(),
              const SizedBox(height: 24),
              _buildCategoryPieChart(),
              const SizedBox(height: 24),
              _buildSmartInsights(),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================
  // ۱. هدر و انتخاب بازه زمانی
  // =====================================
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('آمار و بهره‌وری', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
            Text('گزارش هفتگی و ماهانه تکمیل اهداف', style: TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
          ],
        ),
        Container(
          decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(20)),
          child: IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
            onPressed: () {},
          ),
        )
      ],
    );
  }

  Widget _buildTimeRangeSelector() {
    final ranges = [
      {'key': 'today', 'title': 'امروز'},
      {'key': 'week', 'title': 'این هفته'},
      {'key': 'month', 'title': 'این ماه'},
      {'key': 'year', 'title': 'کل سال'},
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: ranges.map((item) {
          return Expanded(
            child: Obx(() {
              final isSelected = controller.activeTimeRange.value == item['key'];
              return InkWell(
                onTap: () => controller.setTimeRange(item['key']!),
                borderRadius: BorderRadius.circular(24),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected ? LinearGradient(colors: [AppColors.primary, AppColors.primary.withAlpha(50)]) : null,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    item['title']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : AppColors.textMutedLight,
                    ),
                  ),
                ),
              );
            }),
          );
        }).toList(),
      ),
    );
  }

  // =====================================
  // ۲. کارت اصلی پروگرس و استریک
  // =====================================
  Widget _buildHeroCard() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Stack(
        children: [
          // هاله‌های نوری جذاب
          Positioned(
            top: -40, left: -40,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(width: 140, height: 140, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.2))),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                          child: const Row(
                            children: [
                              Icon(Icons.trending_up_rounded, size: 14, color: AppColors.primary),
                              SizedBox(width: 4),
                              Text('+۱۲٪ نسبت به هفته پیش', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('${controller.completionRate.toInt()}٪', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.textMainLight)),
                        Text('${controller.completedTasks} تسک از ${controller.totalTasks} کل', style: const TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
                      ],
                    ),

                    // حلقه پروگرس جذاب
                    SizedBox(
                      width: 90, height: 90,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(value: 1.0, strokeWidth: 8, color: AppColors.backgroundLight),
                          CircularProgressIndicator(value: controller.completionRate / 100, strokeWidth: 8, color: AppColors.primary, strokeCap: StrokeCap.round),
                          const Center(child: Icon(Icons.verified_rounded, size: 32, color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // نوار آتش استریک
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.backgroundLight, AppColors.backgroundLight.withValues(alpha: 0.5)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.15), shape: BoxShape.circle),
                            child: const Icon(Icons.local_fire_department_rounded, color: Colors.red, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${controller.currentStreak} روز متوالی', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
                              const Text('عالی، روی دور افتادی! 🔥', style: TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.cardLight, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]),
                        child: Text('سطح ${controller.currentLevel}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber)),
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

  // =====================================
  // ۳. نمودار میله‌ای (فعالیت هفتگی)
  // =====================================
  Widget _buildBarChartSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.cardLight, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16)]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.bar_chart_rounded, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text('فعالیت هفتگی', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(12)),
                child: Text('میانگین: ${controller.averageTasksPerDay} تسک', style: const TextStyle(fontSize: 10, color: AppColors.textMutedLight)),
              )
            ],
          ),
          const SizedBox(height: 24),

          // استفاده از پکیج fl_chart
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 12,
                barTouchData: BarTouchData(enabled: false), // ساده‌سازی برای دیزاین
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12);
                        Widget text;
                        switch (value.toInt()) {
                          case 0: text = const Text('ش', style: style); break;
                          case 1: text = const Text('ی', style: style); break;
                          case 2: text = const Text('د', style: style); break;
                          case 3: text = const Text('س', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)); break; // روز پیک
                          case 4: text = const Text('چ', style: style); break;
                          case 5: text = const Text('پ', style: style); break;
                          case 6: text = const Text('ج', style: style); break;
                          default: text = const Text('', style: style); break;
                        }
                        return SideTitleWidget(meta: meta, child: text);
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: controller.weeklyData.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value,
                        color: e.value == 10 ? AppColors.primary : AppColors.backgroundLight, // روز پیک رنگی است
                        width: 16,
                        borderRadius: BorderRadius.circular(8),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 12,
                          color: AppColors.backgroundLight.withValues(alpha: 0.3),
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================
  // ۴. نمودار دایره‌ای (تفکیک موضوعی)
  // =====================================
  Widget _buildCategoryPieChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.cardLight, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16)]),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.pie_chart_rounded, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text('تفکیک موضوعی دسته‌ها', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
                ],
              ),
              Text('۴ دسته فعال', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: 180,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 60,
                    startDegreeOffset: -90,
                    sections: controller.categoryStats.map((item) {
                      return PieChartSectionData(
                        color: Color(item['color']),
                        value: item['percent'].toDouble(),
                        title: '', // تایتل داخل نمودار نشان داده نمی‌شود تا شلوغ نشود
                        radius: 16, // ضخامت حلقه
                      );
                    }).toList(),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${controller.completedTasks}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
                      const Text('تسک تکمیل‌شده', style: TextStyle(fontSize: 10, color: AppColors.textMutedLight)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          // لیست راهنما (Legends)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: controller.categoryStats.length,
            itemBuilder: (context, index) {
              final item = controller.categoryStats[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(width: 12, height: 12, decoration: BoxDecoration(color: Color(item['color']), shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item['title'], style: const TextStyle(fontSize: 11, color: AppColors.textMainLight, fontWeight: FontWeight.bold), maxLines: 1),
                            Text('${item['tasks']} تسک', style: const TextStyle(fontSize: 9, color: AppColors.textMutedLight)),
                          ],
                        ),
                      ],
                    ),
                    Text('${item['percent']}٪', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(item['color']))),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // =====================================
  // ۵. بینش‌های هوشمند تیک‌دان
  // =====================================
  Widget _buildSmartInsights() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('بینش‌های هوشمند تیک‌دان', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
            Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
          ],
        ),
        const SizedBox(height: 16),
        _buildInsightCard(Icons.light_mode_rounded, 'پربازده‌ترین بازه زمانی', 'صبح‌ها بین ساعت ۹ تا ۱۲ بیشترین تمرکز را دارید.', Colors.amber),
        const SizedBox(height: 12),
        _buildInsightCard(Icons.timer_rounded, 'سرعت اجرای برنامه‌ها', 'میانگین ۴۵ دقیقه زمان برای تکمیل هر مأموریت.', Colors.blue),
        const SizedBox(height: 12),
        _buildInsightCard(Icons.workspace_premium_rounded, 'دسته‌بندی طلایی', 'پروژه‌های کاری با ۹۴٪ تحقق در صدر قرار دارد.', Colors.purple),
      ],
    );
  }

  Widget _buildInsightCard(IconData icon, String title, String desc, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.cardLight, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)]),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // =====================================
  // ۶. دکمه‌های اشتراک و خروجی
  // =====================================
  Widget _buildActionButtons() {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient:  LinearGradient(colors: [AppColors.primary, AppColors.primary.withAlpha(50)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8))],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.ios_share_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('اشتراک‌گذاری کارنامه موفقیت', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download_rounded, color: Colors.blue),
          label: const Text('دریافت خروجی گزارش PDF', style: TextStyle(color: Colors.blue)),
        )
      ],
    );
  }
}