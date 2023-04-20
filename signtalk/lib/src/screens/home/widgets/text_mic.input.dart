import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signtalk/src/constants/colors.dart';

import '../../../config/services/audio_recorder.dart';
import '../../../constants/globals/index.dart' as globals;

class TextMicInputWidget extends StatefulWidget {
  const TextMicInputWidget(
      {super.key,
      required this.inputController,
      required this.setMethodOfTranscript,
      required this.audioRecorder});

  final TextEditingController inputController;
  final Function(String) setMethodOfTranscript;
  final AudioRecorder audioRecorder;

  @override
  State<TextMicInputWidget> createState() => _TextMicInputWidget();
}

class _TextMicInputWidget extends State<TextMicInputWidget> {
  String mode = "mic";
  bool _isRecording = false;
  Stopwatch _stopwatch = Stopwatch();

  void _startRecording() async {
    if (await widget.audioRecorder.checkPermission()) {
      Fluttertoast.showToast(
        msg: 'Recording....',
      );
      setState(() => _isRecording = true);
      _stopwatch = Stopwatch();
      _stopwatch.start();
      widget.audioRecorder.startRecord();
    } else
      Fluttertoast.showToast(
        msg: 'Permission not granted',
      );
  }

  void _stopRecording() async {
    setState(() => _isRecording = false);
    widget.audioRecorder.stopRecord();
    _stopwatch.stop();
    var timeElapsedInSeconds = _stopwatch.elapsed.inSeconds;
    debugPrint(timeElapsedInSeconds.toString());
    if (timeElapsedInSeconds >= 3) {
      await Future.delayed(const Duration(milliseconds: 1000));
      widget.setMethodOfTranscript("Mic");
      setState(() {
        globals.transcriptMethod = "Mic";
      });
      Fluttertoast.showToast(
        msg: 'Recording stopped.',
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Please hold the button for at least 3 seconds.',
      );
    }
  }

  void changeMode() => setState(
      () => mode = widget.inputController.text.isNotEmpty ? "text" : "mic");

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: widget.inputController,
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
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                ),
                onChanged: (value) => changeMode(),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.fromLTRB(0, 5, 5, 0)),
          mode == "text"
              ? FloatingActionButton(
                  onPressed: () {},
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
              : GestureDetector(
                  onTapDown: (details) => _startRecording(),
                  onTapUp: (details) => _stopRecording(),
                  onTapCancel: () => _stopRecording(),
                  child: Container(
                    height: 56,
                    width: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.kColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: FaIcon(
                        _isRecording
                            ? FontAwesomeIcons.stop
                            : FontAwesomeIcons.microphone,
                        color: AppColors.whiteColor),
                  ),
                ),
        ],
      ),
    );
  }
}
