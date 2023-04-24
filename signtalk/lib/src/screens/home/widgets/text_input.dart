import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signtalk/src/constants/colors.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {super.key, required this.inputController, required this.changeMode});

  final TextEditingController inputController;
  final Function changeMode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: inputController,
          maxLines: 1,
          cursorColor: AppColors.greenColor,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w500,
            color: AppColors.kColor,
          ),
          decoration: InputDecoration(
            hintText: 'Enter Text to translate',
            hintStyle: GoogleFonts.quicksand(
              color: AppColors.greyTextColor,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          ),
          onChanged: (value) => changeMode(),
        ),
      ),
    );
  }
}
