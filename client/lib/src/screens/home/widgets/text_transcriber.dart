import 'dart:io';

import 'package:client/src/services/services/audio_recorder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:client/src/constants/globals/index.dart' as globals;
import 'package:client/src/services/services/api_services.dart' as app_services;
import 'package:client/src/services/services/youtube_transcript.dart'
    as youtube_transcript_service;

class TranscribeTextBuilder extends StatefulWidget {
  const TranscribeTextBuilder(
      {super.key,
      required this.audioRecorder,
      required this.method,
      required this.callback});

  final Function(String) callback;
  final AudioRecorder audioRecorder;
  final String method;

  @override
  State<TranscribeTextBuilder> createState() => _TranscribeTextBuilderState();
}

class _TranscribeTextBuilderState extends State<TranscribeTextBuilder> {
  Future<String> transcript(String method) async {
    debugPrint(method);
    if (method == "Mic") {
      return app_services.transcriptFile(widget.audioRecorder.recordFilePath);
    } else if (method == "File") {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['wav', 'mp3', 'm4a', 'mp4'],
        type: FileType.custom,
      );
      if (result != null) {
        File file = File(result.files.single.path!);
        return app_services.transcriptFile(file.path);
      } else {
        return "File did not pick";
      }
    } else if (method == "Youtube") {
      //with python server
      // return app_services.transcriptYoutubeVideo(globals.transcript.text);
      //with dart server
      return youtube_transcript_service
          .getYoutubeVideoTranscript(globals.transcript.text);
    } else {
      return "Error in transcripting file";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: transcript(widget.method),
      builder: (context, snapshot) {
        Widget? child;
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            child = Text('Error: ${snapshot.error}');
          } else {
            final responseText = snapshot.data ?? "";
            child = Text(responseText);
            // child = Marquee(
            //   text: responseText,
            //   style: const TextStyle(fontWeight: FontWeight.bold),
            //   scrollAxis: Axis.horizontal,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   blankSpace: 20.0,
            //   velocity: 100.0,
            //   // pauseAfterRound: const Duration(seconds: 1),
            //   // showFadingOnlyWhenScrolling: true,
            //   // fadingEdgeStartFraction: 0.1,
            //   // fadingEdgeEndFraction: 0.1,
            //   // numberOfRounds: 1,
            //   // startPadding: 10.0,
            //   // accelerationDuration: const Duration(seconds: 1),
            //   // accelerationCurve: Curves.linear,
            //   // decelerationDuration: const Duration(milliseconds: 500),
            //   // decelerationCurve: Curves.easeOut,
            // );
          }
        } else {
          // child = const Column(children: [
          //   SizedBox(
          //     child: CircularProgressIndicator(),
          //   ),
          //   Text('Awaiting result...'),
          // ]);
        }
        return Container(
          child: child,
        );
      },
    );
  }
}
