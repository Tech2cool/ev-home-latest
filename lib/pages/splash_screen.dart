import 'package:ev_homes/core/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the video player with the splash video
    _controller = VideoPlayerController.asset(Constant.splashVideo,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..setLooping(false)
      ..initialize().then((_) {
        setState(() {});
        _controller.setVolume(0.0); // Mute the video
        _controller.play();
      });

    // Navigate when the video ends
    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.position >= _controller.value.duration) {
        GoRouter.of(context).pushReplacement("/auth-wrapper");
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
