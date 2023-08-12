import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../api/index.dart';
import 'package:client/src/services/services/youtube_transcript.dart'
    as youtube_transcript_service;
import 'package:client/src/constants/globals/index.dart' as globals;

Future<String> transcriptFile(String path) async {
  String fileName = basename(path);

  final response = await Api.uploadAudio(path, fileName);
  return await response.stream
      .bytesToString()
      .then((value) => value)
      .catchError(
          (error) => "Error in transcription file: ${error.toString()}");
}

Future<String> transcriptYoutubeVideo(String url) async {
  final response = Api.transcriptYoutubeVideo(url);
  return await response
      .then((value) => jsonDecode(value.body)['text'])
      .catchError(
          (error) => "Error (Maybe Network issue): ${error.toString()}");
}

Future<String> generateGlossary(String text) async {
  final response = Api.generateGlossary(text);
  return await response
      .then((value) => jsonDecode(value.body)['glossary'])
      .catchError(
          (error) => "Error (Maybe Network issue): ${error.toString()}");
}

Future<String> transcript(String method) async {
  debugPrint(method);
  String output = "";
  if (method == "Mic") {
    output = await transcriptFile(globals.audioRecorder.recordFilePath);
  } else if (method == "Youtube") {
    output = await youtube_transcript_service.getYoutubeVideoTranscript("");
  }
  // else method will be "File"
  else {
    var result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['wav', 'mp3', 'm4a', 'mp4'],
      type: FileType.custom,
    );

    File file = File(result!.files.single.path!);
    output = await transcriptFile(file.path);
  }

  return output;
}
