import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class YouTubePage extends StatefulWidget {
  @override
  _YouTubePageState createState() => _YouTubePageState();
}

class _YouTubePageState extends State<YouTubePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/orange_bg.mp4')
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true);
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('YouTube',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Section
            Container(
              height: 200,
              color: Colors.black,
              child: _controller.value.isInitialized
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),

            // Video Title and Details
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sirat ne bataaya Akshara ko uski maa ka sach! | Yeh Rishta - Naira Kartik Ka',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '3 mo ago · ',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            Divider(),

            // Images Section with Play Button and Title
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildImageWithPlayButton(
                    imageUrl: 'assets/images/23 miami.png',
                    title: 'Miami - Beautiful Beaches',
                  ),
                  _buildImageWithPlayButton(
                    imageUrl: 'assets/images/23 miami.png',
                    title: 'Miami - Stunning Views',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWithPlayButton(
      {required String imageUrl, required String title}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            IconButton(
              icon: const Icon(
                Icons.play_circle_filled,
                size: 50,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
      ],
    );
  }
}

class EngagementButton extends StatelessWidget {
  final IconData icon;
  final String label;

  EngagementButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.black),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
