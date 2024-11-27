import 'package:ev_homes/components/animated_box.dart';
import 'package:ev_homes/core/constant/constant.dart';
import 'package:ev_homes/pages/admin_pages/admin_registration_page.dart';
import 'package:ev_homes/pages/login_pages/admin_login_page.dart';
import 'package:flutter/material.dart';

class AdminLoginFinalSection extends StatefulWidget {
  const AdminLoginFinalSection({super.key});

  @override
  State<AdminLoginFinalSection> createState() => _AdminLoginFinalSectionState();
}

class _AdminLoginFinalSectionState extends State<AdminLoginFinalSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Loop the animation

    _colorAnimation = ColorTween(
      begin: const Color(0xFFFFB22C),
      end: Colors.white.withOpacity(0.8),
    ).animate(_controller);
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
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 246, 117, 5),
              Color.fromARGB(255, 255, 248, 200),
              Color.fromARGB(255, 255, 255, 255)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the column
            children: [
              const Text(
                'I am a',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold, // Makes the text bold
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  AnimatedBox(
                    imagePath: Constant.newIcon,
                    label: 'New',
                    colorAnimation: _colorAnimation,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminRegistrationPage(),
                        ),
                      );
                    },
                  ),
                  AnimatedBox(
                    imagePath: Constant.existingIcon,
                    label: 'Existing',
                    colorAnimation: _colorAnimation,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminLoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
