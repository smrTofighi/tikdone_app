import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/dimens.dart';
import 'package:tikdone_app/features/auth/view_model/auth_view_model.dart';
import '../main/widgets/loading.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    AuthViewModel authVM = Get.find<AuthViewModel>();
    
    Future.delayed(const Duration(seconds: 3))
        .then((value) => authVM.checkSession());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).splashColor,
        body: SizedBox(
          width: AppDimens.infinity,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Loading(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
