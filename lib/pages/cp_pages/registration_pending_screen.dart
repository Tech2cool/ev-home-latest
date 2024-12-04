import 'package:ev_homes/core/constant/constant.dart';
import 'package:ev_homes/pages/login_pages/cp_register_page.dart';
import 'package:flutter/material.dart';

class RegistrationPendingScreen extends StatelessWidget {
  const RegistrationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final settingProvider = Provider.of<SettingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            Constant.logoIcon,
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
                    "We  received your details, will get back to you soon.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Please wait, while we verify your details.",
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
