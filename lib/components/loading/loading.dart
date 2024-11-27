// import 'package:ev_homes_customer/core/constant.dart';
import 'package:ev_homes/core/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(Constant.loadingDropletAnim);
  }
}
