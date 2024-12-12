import 'package:flutter/material.dart';

class Lottiepage extends StatefulWidget {
  const Lottiepage({super.key});

  @override
  State<Lottiepage> createState() => _LottiepageState();
}

class _LottiepageState extends State<Lottiepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
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
          child: Image.asset(
            'assets/images/logo9square.png',
            width: 200,
            height: 300,
          ),
        ),
      ),
    );
  }
}
