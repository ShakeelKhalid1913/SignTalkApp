import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signtalk/src/config/services/audio_recorder.dart';
import 'package:signtalk/src/constants/colors.dart';
import 'package:signtalk/src/constants/globals/index.dart' as globals;
import 'package:signtalk/src/screens/home/widgets/send_button.dart';
import 'package:signtalk/src/screens/home/widgets/text_input.dart';

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
  final GlobalKey _tooltipKey = GlobalKey();

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
    if (timeElapsedInSeconds >= globals.minRecordingTime) {
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
        msg: 'Please hold the button for at least ${globals.minRecordingTime} seconds.',
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
          TextInput(
            inputController: widget.inputController,
            changeMode: changeMode,
          ),
          const Padding(padding: EdgeInsets.fromLTRB(0, 5, 5, 0)),
          mode == "text"
              ? const SendButton()
              : GestureDetector(
                  onLongPressStart: (details) => _startRecording(),
                  onLongPressEnd: (details) => _stopRecording(),
                  onTap: (){
                    dynamic toolTip = _tooltipKey.currentState;
                    toolTip.ensureTooltipVisible();
                  },
                  child: Container(
                    height: 56,
                    width: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.kColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Tooltip(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.kColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      key: _tooltipKey,
                      triggerMode: TooltipTriggerMode.tap,
                      message: "Hold to record, release to stop",
                      child: FaIcon(
                          _isRecording
                              ? FontAwesomeIcons.stop
                              : FontAwesomeIcons.microphone,
                          color: AppColors.whiteColor),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
