import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:signtalk/src/constants/colors.dart';
import 'package:signtalk/src/services/services/audio_recorder.dart';
import 'package:signtalk/src/constants/globals/index.dart' as globals;
import 'package:signtalk/src/services/services/api_services.dart'
    as app_services;
import 'package:signtalk/src/services/services/youtube_transcript.dart'
    as youtube_transcript_service;

class TranscribeTextBuilder extends StatelessWidget {
  const TranscribeTextBuilder(
      {super.key, required this.audioRecorder, required this.method});

  final AudioRecorder audioRecorder;
  final String method;

  Future<String> transcript(String method) async {
    debugPrint(method);
    if (method == "Mic") {
      return app_services.transcriptFile(audioRecorder.recordFilePath);
    } else if (method == "File") {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['wav', 'mp3', 'm4a', 'mp4'],
        type: FileType.custom,
      );
      if (result != null) {
        File file = File(result.files.single.path!);
        return app_services.transcriptFile(file.path);
      } else
        return "File did not pick";
    } else if (method == "Youtube") {
      //with python server
      // return app_services.transcriptYoutubeVideo(globals.transcript.text);
      //with dart server
      return youtube_transcript_service
          .getYoutubeVideoTranscript(globals.transcript.text);
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
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: AppColors.redColor,
                  )),
                  child: Text(responseText),
                ),
              )
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
        return Column(
          children: children,
        );
      },
    );
  }
}
