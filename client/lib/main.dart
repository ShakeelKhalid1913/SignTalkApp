import 'package:client/src/constants/colors.dart';
import 'package:client/src/screens/home/index.dart';
import 'package:client/src/utils/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const SignTalkApp());
}

class SignTalkApp extends StatelessWidget {
  const SignTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignTalk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
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
                  fontSize: 35,),
              iconTheme: const IconThemeData(color: AppColors.kColor))
      ),
      // darkTheme: Themes.darkTheme(context),
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
