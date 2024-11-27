import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:ev_homes/wrappers/auth_wrapper.dart';
import 'package:flutter/material.dart';

class AdminResetPasswordPage extends StatefulWidget {
  final String email;

  const AdminResetPasswordPage({
    super.key,
    required this.email,
  });

  @override
  State<AdminResetPasswordPage> createState() => _AdminResetPasswordPageState();
}

class _AdminResetPasswordPageState extends State<AdminResetPasswordPage> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Reset Password'),
            backgroundColor: Colors.orange,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Enter OTP and New Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                // SizedBox(height: 20),
                // Email Input
                // TextFormField(
                //   controller: _emailController,
                //   decoration: InputDecoration(
                //     labelText: 'Email',
                //     border: OutlineInputBorder(),
                //     prefixIcon: Icon(Icons.email, color: Colors.orange),
                //   ),
                // ),
                const SizedBox(height: 20),
                // OTP Input
                TextFormField(
                  controller: _otpController,
                  decoration: const InputDecoration(
                    labelText: 'OTP',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock, color: Colors.orange),
                  ),
                ),
                const SizedBox(height: 20),
                // New Password Input
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.orange),
                  ),
                ),
                const SizedBox(height: 20),
                // Confirm Password Input
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.orange),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: forgotPassword,
                  child: const Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    _resetPassword();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }

  Future<void> forgotPassword() async {
    setState(() {
      isLoading = true;
    });
    try {
      final respForgotPass = await ApiService().forgotPasswordEmployee(
        widget.email,
      );
      if (respForgotPass == null) return;
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void _resetPassword() async {
    String email = widget.email.trim();
    String otp = _otpController.text.trim();
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      Helper.showCustomSnackBar("Passwords do not match!");
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("Passwords do not match!"),
      // ));
      return;
    }
    final resetResp = await ApiService().resetPasswordEmployee(
      email,
      otp,
      newPassword,
    );
    if (resetResp == null) return;
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AuthWrapper(),
      ),
    );

    // Implement your logic to send email, otp, and new password to the server
    // Helper.showCustomSnackBar("Passwords do not match!");

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text("Password reset successfully!"),
    // ));
  }
}

class AdminForgotPasswordPage extends StatefulWidget {
  const AdminForgotPasswordPage({super.key});

  @override
  State<AdminForgotPasswordPage> createState() =>
      _AdminForgotPasswordPageState();
}

class _AdminForgotPasswordPageState extends State<AdminForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  Future<void> forgotPassword() async {
    setState(() {
      isLoading = true;
    });
    try {
      final respForgotPass = await ApiService()
          .forgotPasswordEmployee(_emailController.text.trim());
      if (respForgotPass == null) return;

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AdminResetPasswordPage(
            email: respForgotPass['email'] ?? _emailController.text.trim(),
          ),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Forgot Password'),
            backgroundColor: Colors.orange,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Enter your registered email id',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
                const SizedBox(height: 20),
                // Email Input
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email, color: Colors.orange),
                  ),
                ),

                const SizedBox(height: 30),
                // Submit Button
                ElevatedButton(
                  onPressed: forgotPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}
