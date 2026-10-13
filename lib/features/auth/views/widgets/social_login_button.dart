import 'package:flutter/material.dart';
import 'package:tikdone_app/core/values/colors.dart';

class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textMainLight,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      icon: Icon(icon, color: iconColor, size: 24),
      label: Text(title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }
}
