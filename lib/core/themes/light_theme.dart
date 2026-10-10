import 'package:flutter/material.dart';
import 'package:todo_infinity_app/core/gen/fonts.gen.dart';
import 'package:todo_infinity_app/core/styles/text_styles.dart';
import '../values/colors.dart';

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: false,
    fontFamily: FontFamily.samim,
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backGround,
    shadowColor: Colors.black.withOpacity(0.1),
    splashColor: AppColors.primaryBG,
    cardColor: AppColors.card,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: AppColors.black),
      backgroundColor: AppColors.backGround,
      elevation: 0,
    ),
   
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.primaryBG,),
    inputDecorationTheme: inputTheme(),
    elevatedButtonTheme: elevatedButtonTheme(),
    bottomAppBarTheme: const BottomAppBarThemeData(color: AppColors.white),
    iconTheme: const IconThemeData(
      color: AppColors.black

    )
  );
}

ElevatedButtonThemeData elevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.primary),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        )),
  );
}

InputDecorationTheme inputTheme() {
  return InputDecorationTheme(
    fillColor: Colors.white,
    
    errorStyle: AppTextStyles.normal10(AppColors.redText),
    contentPadding:
        const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0, right: 14),
    filled: true,
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primary),
      borderRadius: BorderRadius.circular(6),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
      borderRadius: BorderRadius.circular(6),
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(),
      borderRadius: BorderRadius.circular(6),
    ),
    hintStyle: const TextStyle(fontSize: 12),
  );
}
