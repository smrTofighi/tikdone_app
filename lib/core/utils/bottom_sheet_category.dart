import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart'; // حاوی ThemeHelper
import 'package:tikdone_app/core/values/icons.dart'; // حاوی AppIcons
import 'package:tikdone_app/core/values/strings.dart';
import 'package:tikdone_app/features/main/widgets/loading.dart';
import 'package:tikdone_app/features/main/main_category/view_model/main_category_view_model.dart';
import '../../features/main/main_category/views/widgets/color_widget.dart';

void bottomSheetCategory(
  String title,
  TextEditingController controller,
  Function() confirmTap,
  Function() closeTap,
  BuildContext context, {
  // این پارامترها برای حالت ویرایش اضافه شده‌اند
  String? initialIconKey,
  String? initialThemeString,
}) {
  final categoryVM = Get.find<MainCategoryViewModel>();

  // حالا متغیرهای ما String هستند
  // اگر مقدار اولیه نداشتیم، اولین آیتم لیست‌ها را به صورت پیش‌فرض انتخاب می‌کنیم
  final RxString selectedTheme =
      (initialThemeString ?? ThemeHelper.defaultThemes[0]).obs;
  final RxString selectedIconKey = (initialIconKey ?? AppIcons.iconKeys[0]).obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final isDark = Theme.of(context).brightness == Brightness.dark;

  Get.bottomSheet(
    Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Gap(16),

              // تیتر + پیش‌نمایش زنده آیکون
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  Obx(() {
                    final currentColor =
                        ThemeHelper.parsePrimaryColor(selectedTheme.value);
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: currentColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        AppIcons.getIcon(selectedIconKey.value),
                        size: 26,
                        color: currentColor,
                      ),
                    ).animate(target: currentColor.value.toDouble()).scale(
                          duration: 250.ms,
                          curve: Curves.easeOutBack,
                        );
                  }),
                ],
              ),
              const Gap(20),

              TextFormField(
                controller: controller,
                autofocus: false,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  labelText: 'نام دسته‌بندی',
                  hintText: 'مثلاً: کاری، شخصی، دانشگاه...',
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
                  return null;
                },
              ),
              const Gap(20),

              // انتخاب آیکون از روی Keys
              Text(
                'انتخاب آیکون',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white60 : Colors.grey.shade700,
                ),
              ),
              const Gap(8),
              SizedBox(
                height: 52,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: AppIcons.iconKeys.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final currentIconKey = AppIcons.iconKeys[index];
                    return Obx(
                      () => IconWidget(
                        iconKey: currentIconKey,
                        selectedIconKey: selectedIconKey.value,
                        selectedThemeString: selectedTheme.value,
                        onTap: () => selectedIconKey(currentIconKey),
                      ),
                    );
                  },
                ),
              ),
              const Gap(16),

              // انتخاب رنگ از تم‌های جدید
              Text(
                'انتخاب رنگ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white60 : Colors.grey.shade700,
                ),
              ),
              const Gap(8),
              SizedBox(
                height: 42,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: ThemeHelper.defaultThemes.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final currentThemeString = ThemeHelper.defaultThemes[index];
                    final parsedColor =
                        ThemeHelper.parsePrimaryColor(currentThemeString);
                    return Obx(() {
                      final isSelected =
                          currentThemeString == selectedTheme.value;
                      return ColorWidget(
                        color: isSelected
                            ? parsedColor
                            : parsedColor.withOpacity(0.4),
                        onTap: () => selectedTheme(currentThemeString),
                      );
                    });
                  },
                ),
              ),
              const Gap(24),

              Obx(
                () => categoryVM.isLoadingBottomSheet.value
                    ? const Center(
                        child: Loading(
                          color: AppColors.primary,
                          size: 38,
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                side: BorderSide(
                                  color: isDark
                                      ? Colors.white24
                                      : Colors.grey.shade300,
                                ),
                              ),
                              onPressed: () {
                                Get.back();
                                closeTap();
                              },
                              child: Text(
                                PersianStrings.cancel,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  // حالا رشته‌ها رو می‌فرستیم به ویومدل
                                  categoryVM.addCategory(
                                    title: controller.text.trim(),
                                    iconString:
                                        selectedIconKey.value, // کلید آیکون
                                    themeString: selectedTheme.value, // کلید تم
                                    context: context,
                                  );
                                  confirmTap();
                                }
                              },
                              child: const Text(
                                PersianStrings.add,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
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
      ),
    ),
    isScrollControlled: true,
  );
}

class IconWidget extends StatelessWidget {
  const IconWidget({
    super.key,
    required this.iconKey,
    required this.selectedIconKey,
    required this.selectedThemeString,
    required this.onTap,
  });

  final String iconKey;
  final String selectedIconKey;
  final String selectedThemeString;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = iconKey == selectedIconKey;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentColor = ThemeHelper.parsePrimaryColor(selectedThemeString);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: 46,
        height: 46,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: isSelected
              ? currentColor.withOpacity(0.15)
              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? currentColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Icon(
            AppIcons.getIcon(iconKey),
            size: 24,
            color: isSelected
                ? currentColor
                : (isDark ? Colors.white38 : Colors.grey.shade500),
          ),
        ),
      ),
    );
  }
}
