import 'package:flutter/material.dart';
import 'package:ev_homes/components/animated_gradient_bg.dart';

import '../../components/cp_videoplayer.dart';

class FeaturedProjectScreen extends StatefulWidget {
  final String logoImagePath;
  final String title;

  const FeaturedProjectScreen({
    Key? key,
    required this.logoImagePath,
    required this.title,
  }) : super(key: key);

  @override
  _FeaturedProjectScreenState createState() => _FeaturedProjectScreenState();
}

class _FeaturedProjectScreenState extends State<FeaturedProjectScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
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
    return Stack(
      children: [
        const Positioned.fill(
          child: CpVideoplayer(),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Text(widget.title),
            ),
          ),
          body: Stack(
            children: [
              // const Positioned.fill(
              //   child: AnimatedGradientBg(),
              // ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: Image.network(
                        widget.logoImagePath,
                        width: 300,
                        height: 300,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 250,
                            height: 250,
                            color: Colors.grey[300],
                            child:
                                Icon(Icons.error, color: Colors.red, size: 50),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Something big is coming soon",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Stay tuned for updates on this project!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _controller,
                        curve: Interval(0.5, 1.0, curve: Curves.easeOutQuart),
                      )),
                      // child: ElevatedButton(
                      //   onPressed: () {
                      //     // Add functionality for notification sign-up
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text('Notification feature coming soon!')),
                      //     );
                      //   },
                      //   child: Text('Notify me when it\'s ready'),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Theme.of(context).primaryColor,
                      //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
