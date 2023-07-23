import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signtalk/src/constants/theme.dart';
import 'package:signtalk/src/screens/home/index.dart';
import 'package:signtalk/src/screens/onboarding/index.dart';
import 'package:signtalk/src/utils/routes.dart';

void main(List<String> args) {
  runApp(const SignTalkApp());
}

class SignTalkApp extends StatelessWidget {
  const SignTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Sign Talk',
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme(context),
      darkTheme: Themes.darkTheme(context),
      themeMode: ThemeMode.light,
      initialRoute: '/',
      routes: {
        Routes.onBoardingScreen: (_) => const OnBoardingScreen(),
        Routes.homeScreen: (_) => const HomeScreen(),
        // Routes.videoPlayerScreen: (_) => const VideoPlayerScreen(),
      },
    );
  }
}
