import 'package:ev_homes/pages/login_pages/customer_login_page.dart';
import 'package:ev_homes/pages/login_pages/customer_signup_page.dart';
import 'package:flutter/material.dart';

class CustomerLoginSection extends StatefulWidget {
  const CustomerLoginSection({super.key});

  @override
  State<CustomerLoginSection> createState() => _FirstPageState();
}

class _FirstPageState extends State<CustomerLoginSection>
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
      body: Center(
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
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Center the row
              children: [
                buildAnimatedContainer(
                    'assets/images/new_customer.jpg', 'New Customer'),
                buildAnimatedContainer('assets/images/returning_customer.jpg',
                    'Returning Customer'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildAnimatedContainer(String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'New Customer') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignUpTabBarPage()),
          );
        }
        if (label == 'Returning Customer') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const LoginPagee()), // Navigate to LoginPage
          );
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
