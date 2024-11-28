import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class OptionsScreen extends StatelessWidget {
  final bool liked;
  final VoidCallback onLikeToggle;
  final String videoUrl;

  const OptionsScreen({
    super.key,
    required this.liked,
    required this.onLikeToggle,
    required this.videoUrl,
  });

  void _shareVideo(BuildContext context) {
    final String message = 'Check out this amazing video! $videoUrl';
    Share.share(message, subject: 'EVHomes Video');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 110),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          child: Icon(Icons.person, size: 18),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'EV_GROUP_101',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.verified,
                          size: 15,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Follow',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'With our exclusive projects 💙❤💛',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    // Add hashtags or additional description here
                    const Text(
                      '#EVHomes #RealEstate #EVGroup',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      '#LuxuryLiving #HomeDecor #Investment',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Row(
                      children: [
                        Icon(
                          Icons.music_note,
                          size: 15,
                        ),
                        Text('Original Audio - some music track--'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: onLikeToggle,
                      child: Icon(
                        liked ? Icons.favorite : Icons.favorite_outline,
                        color: liked
                            ? Colors.red
                            : Colors.white, // Default color set to white
                      ),
                    ),
                    const Text(
                      '601k',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () => _shareVideo(context), // Trigger share on tap
                      child: Transform(
                        transform: Matrix4.rotationZ(5.8),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 50),
                    // const Icon(Icons.more_vert),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
