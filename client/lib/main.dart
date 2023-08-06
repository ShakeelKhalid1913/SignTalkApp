import 'package:client/src/constants/theme.dart';
import 'package:client/src/screens/home/index.dart';
import 'package:flutter/material.dart';
import 'package:three_dart/three_dart.dart';

void main() {
  Cache.enabled = true;
  runApp(const SignTalkApp());
}

class SignTalkApp extends StatelessWidget {
  const SignTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignTalk',
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme(context),
      // darkTheme: Themes.darkTheme(context),
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
