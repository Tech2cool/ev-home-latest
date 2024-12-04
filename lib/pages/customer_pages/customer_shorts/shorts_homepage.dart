import 'package:ev_homes/pages/customer_pages/customer_shorts/content_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

class ShortsHomepage extends StatelessWidget {
  final List<String> videos = [
    // 'assets/video/shorts.mp4',
    // 'assets/video/amenities mobile.mp4',
    // 'assets/video/evhome.mp4',
    'https://cdn.evhomes.tech/5a123557-3e96-4682-a22f-61e8df67d647-amenities%20mobile%201.mp4?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjVhMTIzNTU3LTNlOTYtNDY4Mi1hMjJmLTYxZThkZjY3ZDY0Ny1hbWVuaXRpZXMgbW9iaWxlIDEubXA0IiwiaWF0IjoxNzMwMTk4NDUyfQ.1oonVe13kVu7JpyKyebUjlkTrE2Oiqaj8DTcJRa5nmo',
    'https://cdn.evhomes.tech/3576f08a-272b-4b7f-93ca-8dc0b6576fe5-amenities%20mobile%202.mp4?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjM1NzZmMDhhLTI3MmItNGI3Zi05M2NhLThkYzBiNjU3NmZlNS1hbWVuaXRpZXMgbW9iaWxlIDIubXA0IiwiaWF0IjoxNzMwNzk1OTQ5fQ.ELgyuEB8-psRLBFvPueC6NiPz_m4nKyMwfxP6OMzy38',
    // 'https://www.exit109.com/~dnn/clips/RW20seconds_1.mp4',
    // 'https://www.exit109.com/~dnn/clips/RW20seconds_2.mp4',
    // 'https://assets.mixkit.co/videos/preview/mixkit-taking-photos-from-different-angles-of-a-model-34421-large.mp4',
    // 'https://assets.mixkit.co/videos/preview/mixkit-young-mother-with-her-little-daughter-decorating-a-christmas-tree-39745-large.mp4',
    // 'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
    // 'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4',
    // 'https://assets.mixkit.co/videos/preview/mixkit-winter-fashion-cold-looking-woman-concept-video-39874-large.mp4',
    // 'https://assets.mixkit.co/videos/preview/mixkit-womans-feet-splashing-in-the-pool-1261-large.mp4',
    // 'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4',
  ];
  ShortsHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Stack(
          children: [
            Swiper(
              itemBuilder: (BuildContext context, int index) {
                return AspectRatio(
                  aspectRatio: 9 / 16,
                  child: ContentScreen(
                    src: videos[index],
                  ),
                );
              },
              itemCount: videos.length,
              scrollDirection: Axis.vertical,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "EVHomes Shorts",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.camera_alt),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
