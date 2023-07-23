import 'package:flutter/material.dart';
import 'package:client/src/constants/colors.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {super.key, required this.inputController, required this.changeMode});

  final TextEditingController inputController;
  final Function changeMode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: inputController,
        maxLines: 1,
        cursorColor: AppColors.greenColor,
        // style: GoogleFonts.quicksand(
        //   fontWeight: FontWeight.w500,
        //   color: AppColors.kColor,
        // ),
        decoration: InputDecoration(
          hintText: 'Enter Text to translate',
          // hintStyle: GoogleFonts.quicksand(
          //   color: AppColors.greyTextColor,
          //   fontWeight: FontWeight.w500,
          // ),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.kColor)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          suffixIcon: IconButton(
            onPressed: () {
              inputController.clear();
              changeMode();
            },
            icon: Icon(
              Icons.clear_outlined,
              color: inputController.text.isEmpty
                  ? AppColors.greyTextColor
                  : AppColors.redColor,
            ),
          ),
        ),
        onChanged: (value) => changeMode(),
      ),
    );
  }
}
