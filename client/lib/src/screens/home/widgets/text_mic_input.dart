import 'package:client/src/constants/colors.dart';
import 'package:client/src/screens/home/widgets/mic_button.dart';
import 'package:client/src/screens/home/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:client/src/services/services/audio_recorder.dart';

class TextMicInputWidget extends StatefulWidget {
  const TextMicInputWidget(
      {super.key,
      required this.animate,
      required this.transcript,
      required this.inputController,
      required this.setMethodOfTranscript,
      required this.audioRecorder});

  final Function(String) animate;
  final Function(String) transcript;
  final TextEditingController inputController;
  final Function(String) setMethodOfTranscript;
  final AudioRecorder audioRecorder;

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
      height: 50,
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 20),
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
                    widget.animate(widget.inputController.text);
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
              : MicButton(
                  setMethodOfTranscript: widget.setMethodOfTranscript,
                  audioRecorder: widget.audioRecorder,
                  transcript: widget.transcript,
                  animate: widget.animate,
                )
        ],
      ),
    );
  }
}
