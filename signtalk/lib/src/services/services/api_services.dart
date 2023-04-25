import 'dart:convert';

import 'package:path/path.dart';
import 'package:signtalk/src/services/api/index.dart';

Future<String> transcriptFile(String path) async {
  String fileName = basename(path);
  print(path);

  final response = await Api.uploadAudio(path, fileName);
  return await response.stream
      .bytesToString()
      .then((value) => jsonDecode(value)['text'])
      .catchError(
          (error) => "Error in transcription file: ${error.toString()}");
}

Future<String> transcriptYoutubeVideo(String url) async {
  final response = Api.transcriptYoutubeVideo(url);
  return await response
      .then((value) => jsonDecode(value.body)['text'])
      .catchError(
          (error) => "Error in transcription file: ${error.toString()}");
}
