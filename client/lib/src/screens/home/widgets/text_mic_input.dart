import 'package:client/src/constants/colors.dart';
import 'package:client/src/screens/home/widgets/mic_button.dart';
import 'package:client/src/screens/home/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:client/src/services/services/api_services.dart' as api_services;
import 'package:client/src/constants/globals/index.dart' as globals;

class TextMicInputWidget extends StatefulWidget {
  const TextMicInputWidget(
      {super.key, required this.inputController});

  final TextEditingController inputController;

  @override
  State<TextMicInputWidget> createState() => _TextMicInputWidget();
}

class _TextMicInputWidget extends State<TextMicInputWidget> {
  String mode = "mic";

  void changeMode() => setState(
      () => mode = widget.inputController.text.isNotEmpty ? "text" : "mic");

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 50,
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextInput(
            inputController: widget.inputController,
            changeMode: changeMode,
          ),
          const Padding(padding: EdgeInsets.fromLTRB(0, 5, 5, 0)),
          mode == "text"
              ? FloatingActionButton(
                  onPressed: () {
                    api_services
                        .generateGlossary(widget.inputController.text)
                        .then((value) {
                      globals.characterKey.currentState
                          ?.playAllAnimations(value);
                    });
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
                  ))
              : MicButton()
        ],
      ),
    );
  }
}
