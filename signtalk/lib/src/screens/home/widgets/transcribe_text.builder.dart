import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:signtalk/src/config/services/audio_recorder.dart';

import '../../../constants/globals/index.dart' as globals;

// ignore: must_be_immutable
class TranscribeTextBuilder extends StatefulWidget {
  const TranscribeTextBuilder(
      {super.key,
      required this.audioRecorder,
      required this.method,
      required this.setMethodOfTranscript});

  final AudioRecorder audioRecorder;
  final String method;
  final Function(String) setMethodOfTranscript;

  @override
  State<TranscribeTextBuilder> createState() => _TranscribeTextBuilderState();
}

class _TranscribeTextBuilderState extends State<TranscribeTextBuilder> {
  Future<String> transcript(String method) async {
    print(method);
    if (method == "Mic") {
      return globals.transcriptFile(widget.audioRecorder.recordFilePath);
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
      future: transcript(widget.method),
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            children = [Text('Error: ${snapshot.error}')];
          } else {
            final responseText = snapshot.data ?? "";
            children = [
              SingleChildScrollView(
                  child: SizedBox(height: 100, child: Text(responseText)))
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
