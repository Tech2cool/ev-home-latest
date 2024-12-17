import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CpVideoplayer extends StatefulWidget {
  const CpVideoplayer({super.key});

  @override
  State<CpVideoplayer> createState() => _CpVideoplayerState();
}

class _CpVideoplayerState extends State<CpVideoplayer> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoController = VideoPlayerController.asset('assets/video/video_2.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
        _videoController.setVolume(0.0);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: _videoController.value.isInitialized
          ? AspectRatio(
              aspectRatio: 9 / 16,
              child: VideoPlayer(_videoController),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
