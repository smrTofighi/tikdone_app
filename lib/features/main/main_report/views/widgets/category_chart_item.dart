import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tikdone_app/core/values/dimens.dart';

class CategoryChartItem extends StatelessWidget {
  const CategoryChartItem({super.key, required this.title, required this.color});
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: Row(children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radius),
            color: color,
          ),
        ),
        const Gap(8),
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        )
      ]),
    );
  }
}
