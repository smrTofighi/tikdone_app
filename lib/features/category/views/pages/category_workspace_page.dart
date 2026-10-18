import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/routes/pages.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/core/values/dimens.dart';
import 'package:tikdone_app/core/widgets/ambient_glow.dart';
import 'package:tikdone_app/features/category/views/widgets/category_workspace/hero_card.dart';
import 'package:tikdone_app/features/category/views/widgets/category_workspace/workspace_appbar.dart';

import '../../../../core/values/icons.dart';
import '../../view-model/category_workspace_view_model.dart';
import '../widgets/category_workspace/task_item.dart';
import '../widgets/category_workspace/workspace_filters.dart';

class CategoryWorkspacePage extends GetView<CategoryWorkspaceViewModel> {
  const CategoryWorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    final color =
        ThemeHelper.parsePrimaryColor(controller.category.value.theme);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          AmbientGlow(
            color: color,
            top: -100,
            right: -50,
            size: 300,
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
                            //_buildQuickAdd(color),
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
                          (tasks) => SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => TaskItem(task: tasks[index]),
                              childCount: tasks!.length,
                            ),
                          ),
                          onLoading: const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                          onEmpty: const SliverToBoxAdapter(
                            child: Center(
                                child: Text('تسکی در این دسته وجود ندارد')),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 40)),
                      // فاصله پایین
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: color,
        onPressed: () {
          Get.toNamed(AppPages.createTask);
        },
      ),
    );
  }
}
