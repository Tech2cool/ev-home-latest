import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ev_homes/components/cp_videoplayer.dart';

class ChatScreen extends StatefulWidget {
  final VoidCallback goBack;

  const ChatScreen({Key? key, required this.goBack}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CpVideoplayer(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    // child: const Text(
                    //   'Coming Soon',
                    //   style: TextStyle(
                    //     fontSize: 48,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ),
                ),
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: Lottie.asset(
                    'assets/animations/coming_soon.json',
                    width: 300,
                    height: 300,
                    // fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _opacityAnimation,
                  // child: Image.network(
                  //   'http://cdn.evhomes.tech/78dce8b9-3c9f-42c4-88c6-0c82455f4612-EV%20HOME%20LOGO%2039.2kb.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6Ijc4ZGNlOGI5LTNjOWYtNDJjNC04OGM2LTBjODI0NTVmNDYxMi1FViBIT01FIExPR08gMzkuMmtiLnBuZyIsImlhdCI6MTczMDM3MjI2M30.xvje-mYSst1qhQxsuS9aMbo4k3_DmYdhoG7gEz2dGOQ',
                  //   width: 300,
                  //   height: 200,
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: widget.goBack,
            ),
          ),
        ],
      ),
    );
  }
}

