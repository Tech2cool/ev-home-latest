import 'dart:async';
import 'package:ev_homes/pages/cp_pages/registration_pending_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  int countdown = 5; // Countdown start value
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // Start the countdown timer
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          t.cancel();
          // Navigate to request page when countdown finishes
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const RegistrationPendingScreen()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset('assets/animations/req1.json'),
          ),
          const SizedBox(height: 20),
          Text(
            'Request processing $countdown s',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: countdown / 5,
            backgroundColor: Colors.orange[200], // Background color
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ],
      ),
    );
  }
}
