import 'package:flutter/material.dart';

class AnimatedBox extends StatelessWidget {
  final String imagePath;
  final String label;
  final Animation<Color?> colorAnimation;
  final Function() onPress;

  const AnimatedBox({
    super.key,
    required this.imagePath,
    required this.label,
    required this.colorAnimation,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: colorAnimation,
            builder: (context, child) {
              return Container(
                width: 120,
                height: 130,
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(200),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: colorAnimation.value!,
                      offset: const Offset(3, 3),
                      blurRadius: 12,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
