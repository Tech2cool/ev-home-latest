import 'package:ev_homes/components/animated_box.dart';
import 'package:ev_homes/core/constant/constant.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/pages/cp_pages/cp_dashboard_page.dart';
import 'package:ev_homes/sections/login_sections/admin_login_sub_section.dart';
import 'package:ev_homes/wrappers/admin_home_wrapper.dart';
import 'package:flutter/material.dart';

class AdminLoginSection extends StatefulWidget {
  const AdminLoginSection({super.key});

  @override
  State<AdminLoginSection> createState() => _AdminLoginSectionState();
}

class _AdminLoginSectionState extends State<AdminLoginSection>
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'I am a',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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
                    imagePath: Constant.salesIcon,
                    label: 'Sales',
                    colorAnimation: _colorAnimation,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminHomeWrapper(),
                        ),
                      );
                    },
                  ),
                  AnimatedBox(
                    imagePath: Constant.accountsIcon,
                    label: 'Accounts',
                    colorAnimation: _colorAnimation,
                    onPress: () {
                      Helper.showCustomSnackBar("Coming soon...", Colors.green);
                    },
                  ),
                  AnimatedBox(
                    imagePath: Constant.enggineerIcon,
                    label: 'Engineering',
                    colorAnimation: _colorAnimation,
                    onPress: () {
                      Helper.showCustomSnackBar("Coming soon...", Colors.green);
                    },
                  ),
                  AnimatedBox(
                    imagePath: Constant.designIcon,
                    label: 'Design',
                    colorAnimation: _colorAnimation,
                    onPress: () {
                      Helper.showCustomSnackBar("Coming soon...", Colors.green);
                    },
                  ),
                  AnimatedBox(
                    imagePath: Constant.HRIcon,
                    label: 'HR',
                    colorAnimation: _colorAnimation,
                    onPress: () {
                      Helper.showCustomSnackBar("Coming soon...", Colors.green);
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

  Widget buildAnimatedContainer(String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Sales') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminLoginSubSection(),
            ), // Navigate to LoginPage
          );
        }
        if (label == 'Accounts') {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => Logincp()), // Navigate to LoginPage
          // );
        }
        if (label == 'Engineering') {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) =>
          //           const LoginPagee()), // Navigate to LoginPage
          // );
        }
        if (label == 'Design') {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) =>
          //           const LoginPagee()), // Navigate to LoginPage
          // );
        }
      },
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return Container(
                width: 120,
                height: 130,
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: _colorAnimation.value!, // Animated shadow color
                      offset: const Offset(3, 3), // Position the shadow
                      blurRadius: 12, // Blur effect
                      spreadRadius: 3, // Spread the shadow
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Clip image
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover, // Fit the image in the container
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8), // Space between container and text
          Text(
            label,
            style: const TextStyle(
              color: Colors.black, // Text color
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
