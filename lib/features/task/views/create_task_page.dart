import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';

import '../view_model/create_task_view_model.dart';
// import 'package:tikdone_app/core/utils/theme_helper.dart';

class CreateTaskPage extends GetView<CreateTaskViewModel> {
  const CreateTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    // تزریق کنترلر (اگر از بایندینگ استفاده نکرده‌اید)
    Get.put(CreateTaskViewModel());

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInputCard(),
                    const SizedBox(height: 20),
                    _buildCategorySelection(),
                    const SizedBox(height: 20),
                    _buildDueDateCard(context),
                    const SizedBox(height: 20),
                    _buildReminderCard(),
                    const SizedBox(height: 20),
                    _buildPriorityCard(),
                    const SizedBox(height: 32),
                    _buildBottomActions(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================
  // 1. Header
  // =====================================
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withAlpha(50)]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: const Icon(Icons.add_task_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('افزودن تسک جدید', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
                  Text('انجامش بده و ذهنت رو آزاد کن!', style: TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.textMutedLight),
            onPressed: () => Get.back(),
            style: IconButton.styleFrom(backgroundColor: AppColors.cardLight),
          ),
        ],
      ),
    );
  }

  // =====================================
  // 2. Main Input Card (Title & Desc)
  // =====================================
  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24, height: 24,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.check_rounded, size: 16, color: Colors.transparent), // فقط نمایشی
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller.titleController,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMainLight),
                  decoration: const InputDecoration(
                    hintText: 'عنوان کار؛ مثلاً بازبینی قرارداد...',
                    hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: AppColors.backgroundLight.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
            child: TextField(
              controller: controller.descController,
              maxLines: 3,
              style: const TextStyle(fontSize: 13, color: AppColors.textMainLight),
              decoration: const InputDecoration(
                hintText: 'توضیحات و جزییات، پیوندها یا یادداشت‌ها...',
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================
  // 3. Category Selection
  // =====================================
  Widget _buildCategorySelection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.category_rounded, size: 18, color: AppColors.primary),
                SizedBox(width: 6),
                Text('دسته‌بندی مرتبط', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
              ],
            ),
            TextButton.icon(
              onPressed: () {}, // رفتن به ساخت دسته
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('دسته جدید', style: TextStyle(fontSize: 12)),
            )
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: Obx(() {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: controller.availableCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = controller.availableCategories[index];
                final isSelected = controller.selectedCategoryId.value == cat.id;
                // final color = ThemeHelper.parsePrimaryColor(cat.theme);
                final color = AppColors.primary; // موقت برای تست

                return GestureDetector(
                  onTap: () => controller.selectCategory(cat.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? color : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected ? null : Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        // Icon(AppIcons.getIconFromCode(cat.icon), size: 16, color: isSelected ? Colors.white : Colors.grey),
                        Icon(Icons.folder_rounded, size: 16, color: isSelected ? Colors.white : Colors.grey),
                        const SizedBox(width: 6),
                        Text(cat.title, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : AppColors.textMainLight)),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  // =====================================
  // 4. Due Date
  // =====================================
  Widget _buildDueDateCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.cardLight, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text('موعد انجام تسک', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
                ],
              ),
              Obx(() => controller.dueDate.value != null
                  ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Text('تنظیم شده', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
              )
                  : const SizedBox.shrink()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildDatePill('امروز', false, () {}),
              const SizedBox(width: 8),
              _buildDatePill('فردا', true, () {}),
              const SizedBox(width: 8),
              _buildDatePill('آخر هفته', false, () {}),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () => controller.pickDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(12)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit_calendar_rounded, size: 14, color: AppColors.textMutedLight),
                        SizedBox(width: 4),
                        Text('تقویم', style: TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePill(String title, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(color: isSelected ? AppColors.primary : AppColors.backgroundLight, borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(title, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : AppColors.textMainLight))),
        ),
      ),
    );
  }

  // =====================================
  // 5. Reminder
  // =====================================
  Widget _buildReminderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.cardLight, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.notifications_active_rounded, size: 18, color: Colors.amber),
                  SizedBox(width: 6),
                  Text('یادآور هوشمند', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
                ],
              ),
              Obx(() => Switch(
                value: controller.reminderEnabled.value,
                onChanged: controller.toggleReminder,
                activeColor: AppColors.primary,
              )),
            ],
          ),
          Obx(() {
            if (!controller.reminderEnabled.value) return const SizedBox.shrink();
            final presets = [
              {'key': 'on_time', 'label': 'در زمان سررسید'},
              {'key': '10m', 'label': '۱۰ دقیقه قبل'},
              {'key': '30m', 'label': '۳۰ دقیقه قبل'},
            ];
            return Padding(
              padding: EdgeInsets.only(top:12),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: presets.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = presets[index];
                    final isSelected = controller.reminderPreset.value == item['key'];
                    return InkWell(
                      onTap: () => controller.selectReminderPreset(item['key']!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.amber.withValues(alpha: 0.15) : AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(item['label']!, style: TextStyle(fontSize: 12, color: isSelected ? Colors.amber.shade700 : AppColors.textMainLight, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // =====================================
  // 6. Priority
  // =====================================
  Widget _buildPriorityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.cardLight, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.flag_rounded, size: 18, color: Colors.red),
              SizedBox(width: 6),
              Text('سطح اولویت', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMainLight)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPriorityPill(3, 'فوری و مهم', Colors.red, Icons.keyboard_double_arrow_up_rounded),
              const SizedBox(width: 8),
              _buildPriorityPill(2, 'معمولی', Colors.blue, Icons.drag_handle_rounded),
              const SizedBox(width: 8),
              _buildPriorityPill(1, 'کم‌اهمیت', Colors.grey, Icons.keyboard_double_arrow_down_rounded),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPriorityPill(int level, String title, Color color, IconData icon) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.priorityLevel.value == level;
        return InkWell(
          onTap: () => controller.selectPriority(level),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? color.withValues(alpha: 0.1) : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(color: color.withValues(alpha: 0.5)) : Border.all(color: Colors.transparent),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 14, color: isSelected ? color : Colors.grey),
                const SizedBox(width: 4),
                Text(title, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? color : AppColors.textMutedLight)),
              ],
            ),
          ),
        );
      }),
    );
  }

  // =====================================
  // 7. Bottom Actions
  // =====================================
  Widget _buildBottomActions() {
    return Column(
      children: [
        Obx(() => InkWell(
          onTap: controller.isLoading.value ? null : () => controller.saveTask(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withAlpha(50)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8))],
            ),
            child: Center(
              child: controller.isLoading.value
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Text('ثبت و ذخیره تسک', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ),
        )),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close_rounded, color: Colors.grey),
          label: const Text('انصراف', style: TextStyle(color: Colors.grey)),
        )
      ],
    );
  }
}