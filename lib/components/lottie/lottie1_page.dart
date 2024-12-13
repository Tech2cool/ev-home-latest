import 'package:flutter/material.dart';

class Lottie1Page extends StatefulWidget {
  const Lottie1Page({super.key});

  @override
  State<Lottie1Page> createState() => _Lottie1PageState();
}

class _Lottie1PageState extends State<Lottie1Page> {
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
          child: Image.network(
            'https://cdn.evhomes.tech/8f698a49-6c58-43a1-8622-a9a616a88f3e-10%20marina%20bay%20logo%20golden.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjhmNjk4YTQ5LTZjNTgtNDNhMS04NjIyLWE5YTYxNmE4OGYzZS0xMCBtYXJpbmEgYmF5IGxvZ28gZ29sZGVuLnBuZyIsImlhdCI6MTczMzgzOTI5MH0.WWfDOWt5E7-KB-Fg4OwtImqLImYpTGNnuavB84_RZco',
            width: 200,
            height: 300,
          ),
        ),
      ),
    );
  }
}
