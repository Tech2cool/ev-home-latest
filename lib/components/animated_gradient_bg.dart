import 'package:flutter/material.dart';

class AnimatedGradientBg extends StatefulWidget {
  const AnimatedGradientBg({super.key});

  @override
  State<AnimatedGradientBg> createState() => _AnimatedGradientBgState();
}

class _AnimatedGradientBgState extends State<AnimatedGradientBg> {
  List<Color> gradientColors = [
    Color.fromARGB(59, 4, 38, 48),
    Colors.yellow,
    Color(0xFF005254),
  ];

  bool _isAnimating = true;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    _isAnimating = false;
    super.dispose();
  }

  void _startAnimation() {
    Future.delayed(const Duration(seconds: 2), () {
      if (_isAnimating && mounted) {
        setState(() {
          gradientColors = gradientColors.reversed.toList();
        });
        _startAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(),
    );
  }
}
