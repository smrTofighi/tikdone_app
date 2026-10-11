import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/main/widgets/loading.dart';
import 'package:tikdone_app/features/main/main_report/view_model/main_report_view_model.dart';
import 'package:tikdone_app/features/main/main_report/views/widgets/category_chart.dart';
import 'package:tikdone_app/features/main/main_report/views/widgets/category_chart_list.dart';

class ReportPage extends StatelessWidget {
  ReportPage({super.key});
  final MainReportViewModel reportVM = Get.find<MainReportViewModel>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => reportVM.isLoading.value
          ? const Center(
              child: Loading(color: AppColors.primary),
            )
          : SingleChildScrollView(
              child: GetBuilder<MainReportViewModel>(
                builder: (_) => Column(
                  children: [
                    const ReportText(),
                    CategoryPieChart(),
                    CategoryChartList(),
                  ],
                ),
              ),
            ),
    );
  }
}

class ReportText extends StatelessWidget {
  const ReportText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 12, 16, 12),
        child: Text(
          'گزارش',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
        ),
      ),
    );
  }
}
