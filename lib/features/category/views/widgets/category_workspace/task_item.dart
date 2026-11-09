import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/routes/pages.dart';
import 'package:tikdone_app/data/models/todo_model.dart';
import 'package:tikdone_app/features/category/view-model/category_workspace_view_model.dart';

import '../../../../../core/values/colors.dart';

class TaskItem extends StatefulWidget {
  final TodoModel task;
  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isExpanded = false;

  // ==========================================
  // متد هوشمند برای تبدیل تاریخ به متن خوانا
  // ==========================================
  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    // اضافه کردن صفر پشت اعداد تک‌رقمی ساعت (مثلاً 09:05)
    final timeStr =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'امروز، $timeStr';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'فردا، $timeStr';
    } else {
      return '${date.year}/${date.month}/${date.day}، $timeStr';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryWorkspaceViewModel>();
    final completed = widget.task.completed;
    final color =
        ThemeHelper.parsePrimaryColor(controller.category.value.theme);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardLight.withValues(alpha: completed ? 0.4 : 1.0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isExpanded && !completed
            ? [
                BoxShadow(
                    color: color.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4))
              ]
            : [],
        border: isExpanded && !completed
            ? Border.all(color: color.withValues(alpha: 0.3))
            : null,
      ),
      child: Column(
        children: [
          // ۱. هدر کارت
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // دکمه چک‌باکس
                  GestureDetector(
                    onTap: () => controller.toggleTaskStatus(widget.task),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: completed ? color : AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(8),
                        border: completed
                            ? null
                            : Border.all(color: Colors.grey.shade300),
                      ),
                      child: completed
                          ? const Icon(Icons.check_rounded,
                              size: 16, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // عنوان و تاریخ تسک
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // عنوان
                        Text(
                          widget.task.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                completed ? FontWeight.normal : FontWeight.bold,
                            color: completed
                                ? AppColors.textMutedLight
                                : AppColors.textMainLight,
                            decoration:
                                completed ? TextDecoration.lineThrough : null,
                          ),
                          maxLines: isExpanded ? 3 : 1,
                          overflow: isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                        ),

                        // زیرنویس تاریخ و زمان (اگر وجود داشت)
                        if (widget.task.dueDate != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                // اگر یادآور داشت زنگوله، وگرنه تقویم نشان بده
                                widget.task.remindAt != null
                                    ? Icons.notifications_active_rounded
                                    : Icons.calendar_today_rounded,
                                size: 11,
                                color: completed
                                    ? AppColors.textMutedLight
                                    : color.withValues(alpha: 0.8),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDueDate(widget.task.dueDate!),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: completed
                                      ? AppColors.textMutedLight
                                      : color.withValues(alpha: 0.8),
                                  decoration: completed
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),

                  // آیکون فلش
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        size: 24,
                        color: completed
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                  )
                ],
              ),
            ),
          ),

          // ۲. بدنه کشویی
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: _buildExpandedContent(color, controller),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
            sizeCurve: Curves.easeOutCubic,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(
      Color themeColor, CategoryWorkspaceViewModel controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: AppColors.backgroundLight),
          const SizedBox(height: 12),
          if (widget.task.description!.isNotEmpty) ...[
            Text(
              widget.task.description ?? "توضیحاتی نوشته نشده است.",
              style: const TextStyle(
                  fontSize: 12, height: 1.5, color: AppColors.textMutedLight),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              if (widget.task.priority > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(widget.task.priority)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.flag_rounded,
                          size: 12,
                          color: _getPriorityColor(widget.task.priority)),
                      const SizedBox(width: 4),
                      Text(
                        _getPriorityText(widget.task.priority),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getPriorityColor(widget.task.priority)),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_note_rounded,
                        size: 20, color: Colors.blueAccent),
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      Get.toNamed(AppPages.createTask, arguments: widget.task);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded,
                        size: 20, color: Colors.redAccent),
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      // TODO: صدا زدن متد حذف از ViewModel
                    },
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'فوری';
      case 2:
        return 'معمولی';
      case 3:
        return 'کم‌اهمیت';
      default:
        return '';
    }
  }
}
