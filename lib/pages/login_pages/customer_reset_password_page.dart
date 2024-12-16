import 'package:ev_homes/components/loading/loading.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordCustomer extends StatefulWidget {
  const ResetPasswordCustomer({super.key});

  @override
  State<ResetPasswordCustomer> createState() =>
      _ResetPasswordScreenCustomerState();
}

class _ResetPasswordScreenCustomerState extends State<ResetPasswordCustomer> {
  bool _isObscuredPassword = true;
  bool _isLoading = false;
  bool _isObscuredConfirmPassword = true;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    final loggedCustomer = settingProvider.loggedCustomer;

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

    try {
      await settingProvider.changePasswordClient(
        loggedCustomer?.id ?? "",
        _oldPasswordController.text,
        _newPasswordController.text,
      );
    } catch (e) {
      // Handle error
    }
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
                  const Text(
                    "Set a new password",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(199, 248, 85, 4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Create a new password. Ensure it differs from previous ones for security",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  // Old Password Field
                  _buildPasswordField(
                    label: "Old Password",
                    hintText: "Enter your old password",
                    controller: _oldPasswordController,
                    obscureText: _isObscuredPassword,
                    toggleVisibility: () {
                      setState(() {
                        _isObscuredPassword = !_isObscuredPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // New Password Field
                  _buildPasswordField(
                    label: "New Password",
                    hintText: "Enter your new password",
                    controller: _newPasswordController,
                    obscureText: _isObscuredPassword,
                    toggleVisibility: () {
                      setState(() {
                        _isObscuredPassword = !_isObscuredPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password Field
                  _buildPasswordField(
                    label: "Confirm Password",
                    hintText: "Re-enter password",
                    controller: _confirmPasswordController,
                    obscureText: _isObscuredConfirmPassword,
                    toggleVisibility: () {
                      setState(() {
                        _isObscuredConfirmPassword =
                            !_isObscuredConfirmPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 30),

                  // Update Password Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: resetPassword,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color.fromARGB(199, 248, 85, 4),
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

  Widget _buildPasswordField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    const fieldColor = Color.fromARGB(199, 248, 85, 4);

    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: fieldColor), // Text color
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: fieldColor), // Label color
        hintText: hintText,
        hintStyle: const TextStyle(color: fieldColor), // Hint text color
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: fieldColor, // Icon color
          ),
          onPressed: toggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: fieldColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: fieldColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: fieldColor,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
