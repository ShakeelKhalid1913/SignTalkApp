import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  //mobile:    http://192.168.0.100:8000 should be the ip of the computer running the server
  //emulator:  http://10.0.2.2:8000
  static const String url = "http://10.0.2.2:8000";
  static const String audio2text = "$url/audio";
  static const String youtube2text = "$url/youtube";

  static Future<http.StreamedResponse> uploadAudio(
      String path, String filename) async {
    var request = http.MultipartRequest('POST', Uri.parse(audio2text));
    request.files.add(
        await http.MultipartFile.fromPath('file', path, filename: filename));
    return await request.send();
  }

  static Future<http.Response> transcriptYoutubeVideo(String youtubeUrl) async {
    return await http.post(
      Uri.parse(youtube2text),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'youtube_url': youtubeUrl}),
    );
  }
}
