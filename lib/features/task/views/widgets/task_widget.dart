import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tikdone_app/data/models/todo_model.dart';

class TodoItemWidget extends StatelessWidget {
  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onChanged,
    required this.color,
    required this.onDelete,
    required this.onEdit,
  });

  final TodoModel todo;
  final Color color;
  final Function(BuildContext?) onDelete;
  final Function(BuildContext?) onEdit;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Slidable(
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.45,
        children: [
          SlidableAction(
            onPressed: onEdit,
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            icon: Icons.edit_rounded,
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(16)),
          ),
          SlidableAction(
            onPressed: onDelete,
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline_rounded,
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(16)),
          ),
        ],
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: todo.completed
                ? Colors.transparent
                : (isDark ? Colors.white10 : Colors.black.withOpacity(0.04)),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // دکمه تیک اختصاصی دایره‌ای (Clean Checkbox)
            GestureDetector(
              onTap: () => onChanged(!todo.completed),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: todo.completed ? color : Colors.transparent,
                  border: Border.all(
                    color: todo.completed
                        ? color
                        : (isDark ? Colors.white38 : Colors.grey.shade400),
                    width: 2,
                  ),
                ),
                child: todo.completed
                    ? const Icon(Icons.check_rounded,
                        size: 16, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 14),

            // عنوان و توضیحات تسک
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: todo.completed
                          ? (isDark ? Colors.white38 : Colors.grey.shade400)
                          : (isDark ? Colors.white : const Color(0xFF1E293B)),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration:
                          todo.completed ? TextDecoration.lineThrough : null,
                      decorationColor: color,
                    ),
                  ),
                  if (todo.description != null &&
                      todo.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      todo.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark ? Colors.white30 : Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 250.ms).slideY(begin: 0.08, end: 0);
  }
}
