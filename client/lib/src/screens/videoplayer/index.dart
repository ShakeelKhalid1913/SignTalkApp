import 'package:flutter/material.dart';
import 'package:client/src/constants/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Sign Talk"),
      ),
      body: Container(
        color: AppColors.whiteColor,
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  onReady: () => debugPrint("ready"),
                ),
                Positioned(
                  top: 20, // Adjust the positioning as needed
                  left: 20, // Adjust the positioning as needed
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button press
                    },
                    child: Text('Your Button'),
                  ),
                ),
              ],
            ),
            // const Character(height: 450.0,),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton.icon(
                onPressed: () {
                  _controller.play();
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text("Play"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
