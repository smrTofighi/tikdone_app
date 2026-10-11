import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/utils/custom_snackbar.dart';
import 'package:tikdone_app/features/main/main_report/model/main_report_model.dart';

class MainReportViewModel extends GetxController {
  late MainReportModel _model;
  MainReportModel get model => _model;
  final RxBool isLoading = RxBool(false);
  MainReportViewModel() {
    _model = MainReportModel();
  }

  void getCategoryAndTodos(BuildContext context) async {
    isLoading(true);
    var res = await _model.getCategoryAndTodos();
    res.fold(
      (l) {
        isLoading(false);
        CustomSnackbar.showError(context, l.message);
      },
      (r) {
        isLoading(false);
        update();
      },
    );
  }
}
