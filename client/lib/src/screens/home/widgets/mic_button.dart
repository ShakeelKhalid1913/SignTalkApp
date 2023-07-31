import 'package:client/src/constants/colors.dart';
import 'package:client/src/services/services/audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:client/src/constants/globals/index.dart' as globals;

class MicButton extends StatefulWidget {
  const MicButton({
    super.key,
    required this.transcript,
    required this.setMethodOfTranscript,
    required this.audioRecorder,
    required this.animate,
  });

  final AudioRecorder audioRecorder;
  final Function(String) setMethodOfTranscript;
  final Function(String) transcript;
  final Function(String) animate;

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> {
  final GlobalKey _tooltipKey = GlobalKey();
  bool _isRecording = false;
  Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _startRecording() async {
    if (await widget.audioRecorder.checkPermission()) {
      // final connectivityResult = await Connectivity().checkConnectivity();
      // if (connectivityResult == ConnectivityResult.none) {
      //   showToast("Please connect to the internet");
      //   return;
      // }else{
      //   showToast("Recording started");
      // }
      showToast("Recording started");
      setState(() => _isRecording = true);
      _stopwatch = Stopwatch();
      _stopwatch.start();
      widget.audioRecorder.startRecord();
    } else {
      showToast("Please grant permission to record audio");
    }
  }

  void _stopRecording() async {
    setState(() => _isRecording = false);
    widget.audioRecorder.stopRecord();
    _stopwatch.stop();
    var timeElapsedInSeconds = _stopwatch.elapsed.inSeconds;

    debugPrint("${timeElapsedInSeconds.toString()} seconds");
    if (timeElapsedInSeconds >= globals.minRecordingTime) {
      await Future.delayed(const Duration(milliseconds: 1000));
      widget.setMethodOfTranscript("Mic");
      setState(() {
        globals.transcriptMethod = "Mic";
      });
      widget.transcript("Mic");
      widget.animate(globals.transcript.text);
      print(globals.transcript.text);
      showToast("Recording stopped");
    } else {
      showToast(
          'Please hold the button for at least ${globals.minRecordingTime} seconds.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) => _startRecording(),
      onLongPressEnd: (details) => _stopRecording(),
      onTap: () {
        dynamic toolTip = _tooltipKey.currentState;
        toolTip.ensureTooltipVisible();
      },
      child: Container(
        height: 56,
        width: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isRecording ? AppColors.redColor : AppColors.kColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Tooltip(
          key: _tooltipKey,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppColors.kColor,
            borderRadius: BorderRadius.circular(16),
          ),
          triggerMode: TooltipTriggerMode.tap,
          message: "Hold to record, release to stop",
          child: FaIcon(
            _isRecording ? FontAwesomeIcons.stop : FontAwesomeIcons.microphone,
            color: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
}
