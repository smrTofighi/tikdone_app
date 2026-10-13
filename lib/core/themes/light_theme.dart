import 'package:flutter/material.dart';
import 'package:tikdone_app/core/styles/text_styles.dart';
import 'package:tikdone_app/gen/fonts.gen.dart';
import '../values/colors.dart';

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: false,
    fontFamily: FontFamily.samim,
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backGround,
    shadowColor: Colors.black.withOpacity(0.1),
    splashColor: AppColors.primary,
    cardColor: AppColors.cardLight,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: AppColors.black),
      backgroundColor: AppColors.backGround,
      elevation: 0,
    ),
   
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.primary,),
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
    
    errorStyle: AppTextStyles.normal10(AppColors.error),
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
