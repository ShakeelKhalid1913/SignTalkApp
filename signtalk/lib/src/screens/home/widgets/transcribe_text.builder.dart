import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:signtalk/src/config/services/audio_recorder.dart';

import '../../../constants/globals/index.dart' as globals;

// ignore: must_be_immutable
class TranscribeTextBuilder extends StatefulWidget {
  final AudioRecorder _audioRecorder;
  final String _method;
  final Function(String) setMethodOfTranscript;

  TranscribeTextBuilder(
      {super.key,
      required AudioRecorder audioRecorder,
      required String method,
      required this.setMethodOfTranscript})
      : _audioRecorder = audioRecorder,
        _method = method;

  @override
  State<TranscribeTextBuilder> createState() => _TranscribeTextBuilderState();
}

class _TranscribeTextBuilderState extends State<TranscribeTextBuilder> {
  Future<String> transcript(String method) async {
    print(method);
    if (method == "Mic") {
      return globals.transcriptFile(widget._audioRecorder.recordFilePath);
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
      return globals.transcriptYoutubeVideo("https://youtu.be/ZDQDWLhfsEY");
    } else
      return "Error in transcripting file";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: transcript(widget._method),
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            children = [Text('Error: ${snapshot.error}')];
          } else {
            final responseText = snapshot.data ?? "";
            children = [Text(responseText)];
          }
        } else {
          children = [
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
