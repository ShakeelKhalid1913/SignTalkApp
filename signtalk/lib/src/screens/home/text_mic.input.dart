import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/api/audio_recorder.dart';
import '../../constants/theme.dart';

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
    } else {
      widget.setStatusText("Permission not granted");
    }
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
      if (widget.inputController.text.isNotEmpty) {
        mode = "text";
      } else {
        mode = "mic";
      }
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
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: widget.inputController,
                  decoration: InputDecoration(
                    hintText: "Type to translate",
                    labelText: "Translate",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (value) {
                    changeMode();
                  },
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 5, 5, 0)),
          mode == "text"
              ? FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Themes.kColor,
                  child: Icon(
                    Icons.send,
                    size: 30,
                    color: Colors.white,
                  ),
                )
              : GestureDetector(
                  onTapDown: (details) {
                    _startRecording();
                    HapticFeedback.heavyImpact();
                  },
                  onTapUp: (details) => _stopRecording(),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Themes.kColor,
                    child: Icon(_isRecording ? Icons.mic : Icons.mic_off,
                        color: Colors.white),
                  ),
                ),
        ],
      ),
    );
  }
}
