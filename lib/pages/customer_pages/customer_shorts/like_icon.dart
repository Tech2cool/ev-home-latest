import 'package:flutter/material.dart';

class LikeIcon extends StatelessWidget {
  final Future<int> Function() tempFuture;

  const LikeIcon({super.key, required this.tempFuture});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: tempFuture(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Colors.orangeAccent,
                  Colors.deepOrange,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds),
              child: const Icon(
                Icons.favorite,
                size: 100,
                color: Colors.white,
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
