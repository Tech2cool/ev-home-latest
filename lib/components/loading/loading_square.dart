import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingSquare extends StatelessWidget {
  const LoadingSquare({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Lottie.asset(
          width: 200,
          height: 200,
          "assets/animations/loading_square.json",
        ),
      ),
    );
  }
}
