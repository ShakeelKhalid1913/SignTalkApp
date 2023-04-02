import 'package:flutter/material.dart';
import 'package:signtalk/src/constants/theme.dart';
import 'package:signtalk/src/screens/about/index.dart';
import 'package:signtalk/src/screens/home/index.dart';
import 'package:signtalk/src/screens/onboarding/index.dart';
import 'package:signtalk/src/utils/routes.dart';

void main(List<String> args) {
  runApp(SignTalkApp());
}

class SignTalkApp extends StatelessWidget {
  const SignTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Talk',
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme(context),
      darkTheme: Themes.darkTheme(context),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        Routes.onBoardingScreen: (_) => OnBoardingScreen(),
        Routes.homeScreen: (_) => HomeScreen(),
        Routes.aboutScreen: (_) => AboutUsScreen(),
      },
    );
  }
}
