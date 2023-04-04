import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundColor = Color(0xFFfafafa);
  static const Color backgroundOutlineColor = Color(0xFFF6F6F6);

  static const Color whiteColor = Color(0xFFffffff);
  static const Color greyColor = Color(0xFF9698A9);
  static const Color redColor = Color(0xFFed4337);
  static const Color greenColor = Color(0xFF13F5B2);
  static const Color greyTextColor = Color(0xFF9B9BA6);
  static const Color blackColor = Color(0xFF302E5B);
  static const Color bgDarkColor = Color(0xFF38366B);

  static const MaterialColor kColor = MaterialColor(
    0xff302e5b, // 0%
    <int, Color>{
      50: Color(0xff2b2952), //10%
      100: Color(0xff262549), //20%
      200: Color(0xff222040), //30%
      300: Color(0xff1d1c37), //40%
      400: Color(0xff18172e), //50%
      500: Color(0xff131224), //60%
      600: Color(0xff0e0e1b), //70%
      700: Color(0xff0a0912), //80%
      800: Color(0xff050509), //90%
      900: Color(0xff000000), //100%
    },
  );
}