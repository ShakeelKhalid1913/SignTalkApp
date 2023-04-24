import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:signtalk/src/config/services/audio_recorder.dart';
import 'package:signtalk/src/constants/globals/index.dart' as globals;

class TranscribeTextBuilder extends StatelessWidget {
  const TranscribeTextBuilder(
      {super.key,
      required this.audioRecorder,
      required this.method,
      required this.setMethodOfTranscript});

  final AudioRecorder audioRecorder;
  final String method;
  final Function(String) setMethodOfTranscript;

  Future<String> transcript(String method) async {
    debugPrint(method);
    if (method == "Mic") {
      return globals.transcriptFile(audioRecorder.recordFilePath);
    } else if (method == "File") {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['wav', 'mp3', 'm4a', 'mp4'],
        type: FileType.custom,
      );
      if (result != null) {
        File file = File(result.files.single.path!);
        return globals.transcriptFile(file.path);
      } else
        return "File did not pick";
    } else if (method == "Youtube") {
      print(globals.transcript.text);
      return globals.transcriptYoutubeVideo(globals.transcript.text);
    } else
      return "Error in transcripting file";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: transcript(method),
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            children = [Text('Error: ${snapshot.error}')];
          } else {
            final responseText = snapshot.data ?? "";
            children = [
              SingleChildScrollView(
                  child: SizedBox(height: 280, child: Text(responseText)))
            ];
          }
        } else {
          children = const [
            SizedBox(
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            ),
          ];
        }
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }
}
