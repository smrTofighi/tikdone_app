import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_infinity_app/core/values/colors.dart';

class MyFloatingActionButton extends StatelessWidget {
  const MyFloatingActionButton(
      {super.key,
      required this.onPressed,
      required this.color,
      required this.icon, required this.isLoading,
      });
  final Function() onPressed;
  final Color color;
  final bool isLoading;
  final FaIconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0.5, 0.5),
          ),
        ],
      ),
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        onPressed: isLoading ? null : onPressed,
        backgroundColor: color,
        child: isLoading ? const CircularProgressIndicator( color: Colors.white, ) : FaIcon(
          icon,
          size: 20,
          color: AppColors.white,
        ),
      ),
    );
  }
}
