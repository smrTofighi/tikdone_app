import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/core/values/colors.dart';
import 'package:tikdone_app/features/auth/view_model/auth_view_model.dart';
import 'package:tikdone_app/features/auth/views/widgets/amient_glows.dart';
import 'package:tikdone_app/features/auth/views/widgets/auth_card.dart';
import 'package:tikdone_app/features/auth/views/widgets/auth_header.dart';
import 'package:tikdone_app/gen/assets.gen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          const AmbientGlows(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  AuthHeader(),
                  const SizedBox(height: 32),
                  AuthCard(
                   
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// ویجت‌های کلاس‌محور (مستقل و Const-Friendly)
// ==========================================





