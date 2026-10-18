import 'dart:ui';
import 'package:flutter/material.dart';

class AmbientGlow extends StatelessWidget {
  final Color color;
  final double size;
  final double blurRadius;
  final double opacity;

  // مختصات قرارگیری در Stack (اختیاری)
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const AmbientGlow({
    super.key,
    required this.color,
    this.size = 300.0,
    this.blurRadius = 80.0,
    this.opacity = 0.15,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    // هسته اصلی هاله نوری
    Widget glowElement = ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      ),
    );

    // اگر هیچ مختصاتی داده نشده بود، فقط خود هاله را برمی‌گرداند
    if (top == null && bottom == null && left == null && right == null) {
      return glowElement;
    }

    // اگر مختصات داشت، آن را داخل Positioned قرار می‌دهد (برای استفاده در Stack)
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: glowElement,
    );
  }
}