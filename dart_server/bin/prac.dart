import 'package:prac/whisper_api.dart' as whisper_api;
import 'package:prac/youtube_transcript.dart' as youtube_transcript;

void main(List<String> args) async {
  String filename = "vocal-spoken-the-realm-female-speech_75bpm_C_major.wav";
  String url = "https://youtu.be/UOkOA6W-vwc";

  whisper_api.transcript(filename).then((value) => print(value));

  youtube_transcript
      .getYoutubeVideoTranscript(url)
      .then((value) => print(value));
}
