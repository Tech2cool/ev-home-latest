// import 'package:ev_homes_customer/pages/home_screen.dart';
// import 'package:ev_homes/Customer%20pages/home_screen.dart';
import 'package:flutter/material.dart';

class FeaturedProjectScreen extends StatelessWidget {
  final String logoImagePath;
  final String title;

  const FeaturedProjectScreen({
    super.key,
    required this.logoImagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(
        //         builder: (context) => const HomeScreen(),
        //       ),
        //     );
        //   },
        //   icon: const Icon(Icons.arrow_back),
        // ),
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            logoImagePath,
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    " Something big is coming soon",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Stay tuned for updates on this project!",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
