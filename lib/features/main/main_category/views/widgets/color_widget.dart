import 'package:flutter/material.dart';

class ColorWidget extends StatelessWidget {
  const ColorWidget({super.key, required this.color, required this.onTap});
  final Color color;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        curve: Curves.easeInOutQuint,
        duration: const Duration(milliseconds: 500),
        width: 40,
        height: 26,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 6.0),
      ),
    );
  }
}

//? This widget is used on the main page where the user selects the color of the category icon
