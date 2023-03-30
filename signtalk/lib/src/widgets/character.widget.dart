import 'package:flutter/material.dart';
import 'package:signtalk/src/constants/globals/index.dart' as globals;

class Character extends StatelessWidget {
  Character({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(child: Text(globals.transcript)),
    );
  }
}
