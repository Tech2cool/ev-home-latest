import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingGeneratePdf extends StatelessWidget {
  const LoadingGeneratePdf({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Lottie.asset(
          width: 350,
          height: 350,
          "assets/animations/pdf_anim_0.json",
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
