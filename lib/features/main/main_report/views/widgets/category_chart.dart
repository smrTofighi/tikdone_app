import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart'; // ThemeHelper در اینجاست
import 'package:tikdone_app/core/values/dimens.dart';
import 'package:tikdone_app/features/main/main_report/view_model/main_report_view_model.dart';

class CategoryPieChart extends StatelessWidget {
  final MainReportViewModel reportVM = Get.find<MainReportViewModel>();
  CategoryPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimens.sizeOfDevice(context).width,
      height: AppDimens.sizeOfDevice(context).height * 0.35,
      child: PieChart(
        PieChartData(
          sections: _buildPieChartSections(),
          centerSpaceRadius: 55, // فضای مرکزی دایره
          sectionsSpace: 5, // فاصله بین قسمت‌های دایره
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return reportVM.model.categoryList.map((category) {
      return PieChartSectionData(
        // تغییر مهم: پارس کردن رنگ از استرینگ
        color: ThemeHelper.parsePrimaryColor(category.theme),
        value: category.totalTodos.toDouble(),
        title: '${category.totalTodos}',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
