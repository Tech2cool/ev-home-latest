import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AdminRegisterConfirmationSection extends StatefulWidget {
  final int stage;

  final TextEditingController otpController;

  const AdminRegisterConfirmationSection({
    super.key,
    required this.otpController,
    required this.stage,
  });

  @override
  State<AdminRegisterConfirmationSection> createState() =>
      _AdminRegisterConfirmationSectionState();
}

class _AdminRegisterConfirmationSectionState
    extends State<AdminRegisterConfirmationSection> {
  final bool _isRegistrationDetailsComplete = false;
  bool isPersonalDetailsComplete = true;
  bool isCompanyDetailsComplete = true;
  final bool _isPersonalDetailsComplete = true;
  final bool _isCompanyDetailsComplete = true;

  // final TextEditingController _otpController = TextEditingController();

// @override
// void dispose() {
//   // Dispose of the controller when the widget is removed from the widget tree
//   _otpController.dispose();
//   super.dispose();
// }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: PinCodeTextField(
            controller: widget.otpController,
            appContext: context,
            length: 4,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 45,
              fieldWidth: 45,
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
        ),
        // Image.asset(
        //   Constant.logoIcon,
        //   width: 150,
        //   height: 150,
        // ),
        // const SizedBox(height: 10),
        // // Timeline tile
        // // _buildTimelineTile(),
        // const SizedBox(height: 15),

        // const Padding(
        //   padding: EdgeInsets.all(15),
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           "We  received your details, will get back to you soon.",
        //           style: TextStyle(
        //             fontSize: 14,
        //             fontWeight: FontWeight.w600,
        //           ),
        //           textAlign: TextAlign.center,
        //         ),
        //         SizedBox(height: 4),
        //         Text(
        //           "Please wait, while we verify your details.",
        //           style: TextStyle(
        //             fontSize: 14,
        //             fontWeight: FontWeight.w600,
        //           ),
        //           textAlign: TextAlign.center,
        //         ),
        //         SizedBox(height: 10),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
