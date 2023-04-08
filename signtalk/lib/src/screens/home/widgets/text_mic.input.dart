import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signtalk/src/constants/colors.dart';

import '../../../config/services/audio_recorder.dart';

class TextMicInputWidget extends StatefulWidget {
  final TextEditingController inputController;
  final Function(String) setStatusText;
  final Function(String) setMethodOfTranscript;
  final AudioRecorder audioRecorder;

  TextMicInputWidget(
      {super.key,
      required this.inputController,
      required this.setStatusText,
      required this.setMethodOfTranscript,
      required this.audioRecorder});

  @override
  State<TextMicInputWidget> createState() => _TextMicInputWidget();
}

class _TextMicInputWidget extends State<TextMicInputWidget> {
  String mode = "mic";
  bool _isRecording = false;

  void _startRecording() async {
    if (await widget.audioRecorder.checkPermission()) {
      widget.audioRecorder.startRecord();
      setState(() {
        _isRecording = true;
      });
      widget.setStatusText("Recording");
    } else
      widget.setStatusText("Permission not granted");
  }

  void _stopRecording() async {
    widget.audioRecorder.stopRecord();
    await Future.delayed(Duration(milliseconds: 1000));
    widget.setMethodOfTranscript("Mic");
    setState(() {
      _isRecording = false;
    });
    widget.setStatusText("Recording stopped");
  }

  void changeMode() {
    setState(() {
      mode = widget.inputController.text.isNotEmpty ? "text" : "mic";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.fromLTRB(5, 5, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:AppColors.whiteColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: widget.inputController,
                maxLines: 1,
                cursorColor: Color(0xFF13F5B2),
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF302E5B),
                ),
                decoration: InputDecoration(
                  hintText: 'Enter Text to translate',
                  hintStyle: GoogleFonts.quicksand(
                    color: Color(0xFF9B9BA6),
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                ),
                onChanged: (value) => changeMode(),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 5, 5, 0)),
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
                    child: FaIcon(
                      FontAwesomeIcons.solidPaperPlane,
                      color:AppColors.whiteColor,
                    ),
                  ))
              : GestureDetector(
                  onTapDown: (details) {
                    _startRecording();
                    HapticFeedback.heavyImpact();
                  },
                  onTapUp: (details) => _stopRecording(),
                  child: Container(
                    height: 56,
                    width: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.kColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _isRecording
                        ? FaIcon(FontAwesomeIcons.stop, color:AppColors.whiteColor)
                        : FaIcon(FontAwesomeIcons.microphone,
                            color:AppColors.whiteColor),
                  ),
                ),
        ],
      ),
    );
  }
}
