import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signtalk/src/constants/colors.dart';

class Themes {

  static ThemeData lightTheme(context) => ThemeData(
      primarySwatch: AppColors.kColor,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.quicksand().fontFamily,
      appBarTheme: AppBarTheme(
          color: AppColors.whiteColor,
          //elevation: 0.0,
          titleTextStyle: TextStyle(
              color: AppColors.kColor,
              fontWeight: FontWeight.bold,
              fontSize: 35,
              fontFamily: GoogleFonts.quicksand().fontFamily),
          iconTheme: IconThemeData(color: AppColors.kColor)));

  static ThemeData darkTheme(context) => ThemeData(
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.quicksand().fontFamily,
        appBarTheme: AppBarTheme(
            color: AppColors.kColor,
            elevation: 0.0,
            titleTextStyle: TextStyle(color: AppColors.kColor[900], fontSize: 20),
            iconTheme: IconThemeData(color: AppColors.kColor[900])),
      );
}
