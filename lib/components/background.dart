import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      // Use the uploaded image as the background
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              "assets/images/orangeshade.png"), // Replace with your uploaded image path
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [Positioned.fill(child: child)],
      ),
    );
  }
}
