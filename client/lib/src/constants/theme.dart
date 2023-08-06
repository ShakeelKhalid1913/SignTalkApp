import 'package:flutter/material.dart';
import 'package:client/src/constants/colors.dart';

class Themes {
  static ThemeData lightTheme(context) => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.kColor),
        useMaterial3: true,
        primarySwatch: AppColors.kColor,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          color: AppColors.whiteColor,
          elevation: 4,
          shadowColor: Theme.of(context).shadowColor,
          titleTextStyle: const TextStyle(
            color: AppColors.kColor,
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
          iconTheme: const IconThemeData(color: AppColors.kColor),
        ),
      );
}
