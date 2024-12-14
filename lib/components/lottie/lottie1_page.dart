import 'package:flutter/material.dart';

class Lottie1Page extends StatefulWidget {
  const Lottie1Page({super.key});

  @override
  State<Lottie1Page> createState() => _Lottie1PageState();
}

class _Lottie1PageState extends State<Lottie1Page>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          // Commented gradient remains unchanged
          // gradient: LinearGradient(
          //   colors: [
          //     Color(0xFFFFDE4D),
          //     Color(0xFFFFB22C),
          //     Color.fromARGB(199, 248, 85, 4),
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: child,
              );
            },
            child: Center(
              child: AspectRatio(
                aspectRatio: 3 / 4, // Maintain the aspect ratio of 300:400
                child: Image.network(
                  'https://cdn.evhomes.tech/50c20134-af99-476c-8316-2638a39410f3-EV HOME LOGO GOLDEN HD.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjUwYzIwMTM0LWFmOTktNDc2Yy04MzE2LTI2MzhhMzk0MTBmMy1FViBIT01FIExPR08gR09MREVOIEhELnBuZyIsImlhdCI6MTczNDA5NTk5MH0.yPKVawX2e0QNn7X8vbZ1uNxjY3Jg-LTGzlU9SFe3Pck',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
