import 'package:ev_homes/core/constant/constant.dart';
// import 'package:ev_homes_customer/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
        color: Constant.bgColor, // Deep purple background
        child: Center(
          child: Lottie.asset(
            'assets/animations/building.json',
            width: 200,
            height: 300,
          ),
        ),
      ),
    );
  }
}
