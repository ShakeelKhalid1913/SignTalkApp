import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signtalk/src/constants/colors.dart';

class SendButton extends StatelessWidget {
  const SendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          
        },
        backgroundColor: AppColors.kColor,
        child: Container(
          height: 56,
          width: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.kColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const FaIcon(
            FontAwesomeIcons.solidPaperPlane,
            color: AppColors.whiteColor,
          ),
        ));
  }
}
