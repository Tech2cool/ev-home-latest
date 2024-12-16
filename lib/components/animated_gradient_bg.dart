import 'package:flutter/material.dart';

class AnimatedGradientBg extends StatefulWidget {
  const AnimatedGradientBg({super.key});

  @override
  State<AnimatedGradientBg> createState() => _AnimatedGradientBgState();
}

class _AnimatedGradientBgState extends State<AnimatedGradientBg> {
  List<Color> gradientColors = [
    const Color(0xFFFF3373b0),
    const Color(0xFFFFbed4e9),
    const Color(0xFFFFbcd5eb)
    // const Color.fromARGB(199, 248, 85, 4),
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
