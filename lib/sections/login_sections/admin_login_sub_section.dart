import 'package:ev_homes/components/animated_box.dart';
import 'package:ev_homes/core/constant/constant.dart';
import 'package:ev_homes/sections/login_sections/admin_login_final_section.dart';
import 'package:flutter/material.dart';

class AdminLoginSubSection extends StatefulWidget {
  const AdminLoginSubSection({super.key});

  @override
  State<AdminLoginSubSection> createState() => _AdminLoginSubSectionState();
}

class _AdminLoginSubSectionState extends State<AdminLoginSubSection>
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
                    imagePath: Constant.preSalesIcon,
                    label: 'Pre Sales',
                    colorAnimation: _colorAnimation,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminLoginFinalSection(),
                        ),
                      );
                    },
                  ),
                  AnimatedBox(
                    imagePath: Constant.salesIcon,
                    label: 'Sales',
                    colorAnimation: _colorAnimation,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminLoginFinalSection(),
                        ),
                      );
                    },
                  ),
                  AnimatedBox(
                    imagePath: Constant.postSalesIcon,
                    label: 'Post Sales',
                    colorAnimation: _colorAnimation,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminLoginFinalSection(),
                        ),
                      );
                    },
                  ),
                  AnimatedBox(
                    imagePath: Constant.recptionIcon,
                    label: 'Reception',
                    colorAnimation: _colorAnimation,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminLoginFinalSection(),
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
