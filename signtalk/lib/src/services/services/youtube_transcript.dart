import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';

Future<String> getYoutubeVideoTranscript(String url) async {
  RegExp pattern = RegExp(
      r'(?:https://)?(?:www\.)?(?:youtube\.com/watch\?v=|youtu\.be/)([\w-]+)');
  bool isValid = pattern.hasMatch(url);

  if (isValid) {
    final captionScraper = YouTubeCaptionScraper();

    final captionTracks = await captionScraper.getCaptionTracks(url);

    final subtitles = await captionScraper.getSubtitles(captionTracks[0]);

    String text = "";
    for (final subtitle in subtitles) {
      text += "${subtitle.text} ";
    }

    return text;
  } else {
    throw Exception("Invalid URL");
  }
}
