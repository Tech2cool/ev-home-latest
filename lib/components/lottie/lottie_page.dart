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
          child: Image.network(
            'https://cdn.evhomes.tech/50c20134-af99-476c-8316-2638a39410f3-EV%20HOME%20LOGO%20GOLDEN%20HD.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjUwYzIwMTM0LWFmOTktNDc2Yy04MzE2LTI2MzhhMzk0MTBmMy1FViBIT01FIExPR08gR09MREVOIEhELnBuZyIsImlhdCI6MTczNDA5NTk5MH0.yPKVawX2e0QNn7X8vbZ1uNxjY3Jg-LTGzlU9SFe3Pck',
            width: 300,
            height: 300,
          ),
        ),
      ),
    );
  }
}
