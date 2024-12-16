import 'package:ev_homes/components/loading/loading.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isObscuredPassword = true;
  bool _isLoading = false;
  bool _isObscuredConfirmPassword = true;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // final AuthService _authService = AuthService();
  Future<void> resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    final loggedChannelPartner = settingProvider.loggedChannelPartner;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("New passwords do not match."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Call changePasswordChannelPartner
    await settingProvider.changePasswordChannelPartner(
      loggedChannelPartner?.id ?? "",
      _oldPasswordController.text,
      _newPasswordController.text,
    );

    setState(() {
      _isLoading = false;
    });
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ElevatedButton(onPressed: fetchOldPassword, child: Text("fetch")),
                  const Text(
                    "Set a new password",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF042630),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Create a new password. Ensure it differs from previous ones for security",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  // Password Field
                  TextField(
                    controller: _oldPasswordController,
                    obscureText: _isObscuredPassword,
                    decoration: InputDecoration(
                      labelText: "Old Password",
                      hintText: "Enter your new password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscuredPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscuredPassword = !_isObscuredPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Password Field
                  TextField(
                    controller: _newPasswordController,
                    obscureText: _isObscuredPassword,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      hintText: "Enter your new password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscuredPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscuredPassword = !_isObscuredPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password Field
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _isObscuredConfirmPassword,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      hintText: "Re-enter password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscuredConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscuredConfirmPassword =
                                !_isObscuredConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Update Password Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle password update action here
                        resetPassword();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Color(0xFF042630),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Update Password",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // Text color set to white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading) ...[
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Align(
              alignment: Alignment.center,
              child: Loading(),
            ),
          ),
        ]
      ],
    );
  }
}
