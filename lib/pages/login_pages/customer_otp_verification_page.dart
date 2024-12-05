import 'dart:async';
import 'dart:math';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/wrappers/customer_home_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:ev_home_main/internal_wrapper/home_wrapper.dart';

class OtpVerificationPage extends StatefulWidget {
  final String? phoneNumber;
  const OtpVerificationPage({super.key, this.phoneNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _controller = TextEditingController();
  late Timer _timer;
  int _timeRemaining = 120;
  bool _isOtpExpired = false;
  bool _isResendAvailable = false;
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _generateOtp();
    _startTimer();
  }

  void _generateOtp() {
    final random = Random();
    setState(() {
      _otp = (random.nextInt(9000) + 1000).toString();
    });
    print("otp is:$_otp");
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        setState(() {
          _isOtpExpired = true;
          _timer.cancel();
        });
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _resendOtp() {
    setState(() {
      _isOtpExpired = false;
      _isResendAvailable = false;
      _timeRemaining = 120;
    });
    _generateOtp();
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP Resent!')),
    );
  }

  void _navigateToHomeWrapper() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CustomerHomeWrapper()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    //   _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'OTP VERIFICATION',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF745C),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter the OTP sent to your phone number',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            PinCodeTextField(
              controller: _controller,
              appContext: context,
              length: 4,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 40,
                fieldWidth: 40,
                activeFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                selectedFillColor: Colors.white,
                activeColor: const Color(0xFFFF745C),
                inactiveColor: const Color.fromARGB(255, 238, 136, 118),
                selectedColor: const Color(0xFFFF745C),
              ),
              keyboardType: TextInputType.number,
              enableActiveFill: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _navigateToHomeWrapper, // Direct navigation to HomeWrapper
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF745C),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'VERIFY OTP',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      color: Colors.white,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _formatTime(_timeRemaining),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Didn't receive OTP?",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: _isOtpExpired || _isResendAvailable ? _resendOtp : null,
              child: Text(
                'RESEND OTP',
                style: TextStyle(
                  color: _isOtpExpired || _isResendAvailable
                      ? const Color(0xFFFF745C)
                      : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
