import 'dart:developer';

import 'package:appwrite/models.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/config/storage_key.dart';
import 'package:tikdone_app/core/locator/locator.dart';
import 'package:tikdone_app/core/routes/pages.dart';
import 'package:tikdone_app/data/services/storage_service.dart';
import 'package:tikdone_app/core/utils/custom_snackbar.dart';
import 'package:tikdone_app/features/auth/model/auth_model.dart';

class AuthViewModel extends GetxController {
  late AuthModel _model;
  AuthModel get model => _model;
  AuthViewModel() {
    _model = AuthModel();
  }
  RxBool isLoading = RxBool(false);
  late Session userSession;
  void checkSession() async {
    var userId =
        await locator<StorageService>().getValue(StorageKey.userId) ?? '';
    if (userId.isNotEmpty) {
      var res = await _model.checkSession();
      res.fold(
        (failure) {
          log(failure.message);
        },
        (session) {
          userSession = session;
        },
      );
      //Get.put(MainCategoryViewModel());
      Get.offNamed(PageName.main);
    } else {
      Get.offNamed(PageName.logIn);
    }
  }

  void signUpUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required BuildContext context,
  }) async {
    isLoading(true);
    var res = await _model.signInUser(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    res.fold(
      (failure) {
        log(failure.message);
        isLoading(false);
        CustomSnackbar.showError(context, failure.message);
      },
      (user) {
        log(user.email);
        isLoading(false);
        Get.offNamed(PageName.logIn);
        CustomSnackbar.showSuccess(context, 'Created: ${user.email}');
      },
    );
  }

  void logInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    isLoading(true);
    var res = await _model.logInUser(email: email, password: password);
    res.fold(
      (failure) {
        log(failure.message);
        isLoading(false);
        CustomSnackbar.showError(context, failure.message);
      },
      (session) {
        isLoading(false);
        Get.offNamed(PageName.main);
        CustomSnackbar.showSuccess(context, session.userId);
        userSession = session;
      },
    );
  }
}
