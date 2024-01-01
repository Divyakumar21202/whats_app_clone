import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;
  const VideoPlayer({super.key, required this.videoUrl});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlay = false;
  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then(
        (value) {
          videoPlayerController.setVolume(1);

          videoPlayerController.setLooping(true);
          videoPlayerController.seekTo(Duration.zero);
        },
      );
  }

  void playPause() {
    if (isPlay) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
    }
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: isPlay
                  ? const Icon(Icons.pause_circle_filled_rounded)
                  : const Icon(Icons.play_circle_rounded),
              onPressed: () {
                playPause();
                setState(() {
                  isPlay = !isPlay;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
