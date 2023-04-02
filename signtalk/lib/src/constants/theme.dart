import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static const MaterialColor kColor = MaterialColor(
    0xfff49728, // 0%
    <int, Color>{
      50: Color(0xfff5a13e), //10%
      100: Color(0xfff6ac53), //20%
      200: Color(0xfff7b669), //30%
      300: Color(0xfff8c17e), //40%
      400: Color(0xfffacb94), //50%
      500: Color(0xfffbd5a9), //60%
      600: Color(0xfffce0bf), //70%
      700: Color(0xfffdead4), //80%
      800: Color(0xfffef5ea), //90%
      900: Color(0xffffffff), //100%
    },
  );

  static ThemeData lightTheme(context) => ThemeData(
      primarySwatch: kColor,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.firaSans().fontFamily,
      appBarTheme: AppBarTheme(
          color: kColor,
          elevation: 0.0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: kColor, fontWeight: FontWeight.bold, fontSize: 30, fontFamily: 'Pacifico'),
          iconTheme: IconThemeData(color: kColor)));

  static ThemeData darkTheme(context) => ThemeData(
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.lato().fontFamily,
    appBarTheme: AppBarTheme(
        color: kColor,
        elevation: 0.0,
        titleTextStyle: TextStyle(color: kColor[900], fontSize: 20),
        iconTheme: IconThemeData(color: kColor[900])),
  );
}
