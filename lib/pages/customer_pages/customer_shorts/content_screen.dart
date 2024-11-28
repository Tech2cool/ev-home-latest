import 'package:ev_homes/pages/customer_pages/customer_shorts/like_icon.dart';
import 'package:ev_homes/pages/customer_pages/customer_shorts/options_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ContentScreen extends StatefulWidget {
  final String src;

  const ContentScreen({super.key, required this.src});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
    loadLikeStatus();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.src));
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: true,
    );
    setState(() {});
  }

  Future<void> loadLikeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _liked =
          prefs.getBool(widget.src) ?? false; // Load like status for this video
    });
  }

  Future<void> saveLikeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(widget.src, _liked); // Save like status for this video
  }

  void toggleLike() {
    setState(() {
      _liked = !_liked;
    });
    saveLikeStatus(); // Persist like status when it changes
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<int> showLikeIcon() async {
    await Future.delayed(const Duration(seconds: 1));
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_chewieController != null &&
            _chewieController!.videoPlayerController.value.isInitialized)
          GestureDetector(
            onDoubleTap: toggleLike,
            child: Chewie(
              controller: _chewieController!,
            ),
          )
        else
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Loading..'),
              ],
            ),
          ),
        if (_liked) LikeIcon(tempFuture: showLikeIcon),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: OptionsScreen(
            liked: _liked,
            onLikeToggle: toggleLike,
            videoUrl: widget.src,
          ),
        ),
      ],
    );
  }
}
