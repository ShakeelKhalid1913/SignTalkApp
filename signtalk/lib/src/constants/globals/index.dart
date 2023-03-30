import 'dart:convert';

import 'package:path/path.dart';

import '../../config/api/index.dart';

var transcript = "Nothing here";

Future<String> transcriptFile(String path) async {
  String fileName = basename(path);
  print(path);

  final response = await Api.uploadAudio(path, fileName);
  return await response.stream
      .bytesToString()
      .then((value) => jsonDecode(value)['text']);
}
