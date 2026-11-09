import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/routes/pages.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/core/widgets/ambient_glow.dart';
import 'package:tikdone_app/features/category/views/widgets/category_workspace/hero_card.dart';
import 'package:tikdone_app/features/category/views/widgets/category_workspace/workspace_appbar.dart';
import '../../view-model/category_workspace_view_model.dart';
import '../widgets/category_workspace/task_item.dart';
import '../widgets/category_workspace/workspace_filters.dart';

class CategoryWorkspacePage extends GetView<CategoryWorkspaceViewModel> {
  const CategoryWorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    // گرفتن رنگ اختصاصی دسته‌بندی از ویومدل

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          Obx(
            () => AmbientGlow(
              color: ThemeHelper.parsePrimaryColor(
                  controller.category.value.theme),
              top: -100,
              right: -50,
              size: 300,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                WorkspaceAppBar(),
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            HeroCard(),
                            const SizedBox(height: 16),
                            WorkspaceFilters(),
                            const SizedBox(height: 16),
                          ]),
                        ),
                      ),

                      // لیست تسک‌ها با مدیریت State
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: controller.obx(
                          (state) {
                            return Obx(() {
                              final list = controller.filteredTasks;
                              final activeFilter =
                                  controller.activeFilter.value;

                              // اگر لیستی در این فیلتر وجود نداشت، ویجت انیمیشنی را نشان بده
                              if (list.isEmpty) {
                                return _buildAnimatedEmptyState(activeFilter);
                              }

                              // نمایش لیست تسک‌ها
                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) =>
                                      TaskItem(task: list[index]),
                                  childCount: list.length,
                                ),
                              );
                            });
                          },
                          onLoading: const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                          // اگر کل دیتابیسِ این دسته خالی باشد، از حالت all استفاده می‌کنیم
                          onEmpty: _buildAnimatedEmptyState('all'),
                        ),
                      ),
                      const SliverToBoxAdapter(
                          child: SizedBox(
                              height:
                                  100)), // فضای خالی برای اینکه محتوا زیر دکمه شناور نرود
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          backgroundColor:
              ThemeHelper.parsePrimaryColor(controller.category.value.theme),
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Get.toNamed(AppPages.createTask);
          },
        ),
      ),
    );
  }

  // ==========================================
  // متد ساخت Empty State با ایموجی و انیمیشن
  // ==========================================
  Widget _buildAnimatedEmptyState(String filter) {
    String emoji;
    String title;
    String subtitle;

    // تشخیص متن و ایموجی بر اساس فیلتر فعال
    switch (filter) {
      case 'in_progress':
        emoji = '🎉';
        title = 'همه‌چیز مرتبه!';
        subtitle = 'هیچ تسکِ در انتظاری نداری، خسته نباشی.';
        break;
      case 'completed':
        emoji = '🚀';
        title = 'هنوز اول راهیم!';
        subtitle = 'هیچ تسکی رو تکمیل نکردی. وقت شروع کردنه!';
        break;
      case 'all':
      default:
        emoji = '📭';
        title = 'اینجا خیلی خلوته!';
        subtitle = 'هنوز هیچ تسکی توی این دسته ثبت نکردی.';
        break;
    }

    return SliverToBoxAdapter(
      // استفاده از AnimatedSwitcher برای تغییر نرم بین ایموجی‌ها
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutBack, // افکت فنری ملایم موقع ورود
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          // ترکیب انیمیشن محو شدن (Fade) و حرکت به بالا (Slide)
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.2), // کمی از پایین‌تر شروع میشه
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        // برای اینکه AnimatedSwitcher بفهمه فرزند تغییر کرده، حتماً باید Key متفاوتی بدهیم
        child: Padding(
          key: ValueKey<String>(filter),
          padding: const EdgeInsets.symmetric(vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMainLight)),
              const SizedBox(height: 8),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMutedLight)),
            ],
          ),
        ),
      ),
    );
  }
}
