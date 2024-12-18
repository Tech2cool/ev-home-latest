import 'package:flutter/material.dart';

class blueanimatesgradint extends StatefulWidget {
  const blueanimatesgradint({super.key});

  @override
  State<blueanimatesgradint> createState() => _blueanimatesgradintState();
}

class _blueanimatesgradintState extends State<blueanimatesgradint> {
  List<Color> gradientColors = [
    const Color(0xFFFF3373b0),
    const Color(0xFFFFbed4e9),
    const Color(0xFFFFbcd5eb)
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
