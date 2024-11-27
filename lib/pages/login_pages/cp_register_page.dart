import 'dart:io';
import 'package:ev_homes/components/background.dart';
import 'package:ev_homes/pages/cp_pages/request.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();

  // Controllers for each input field
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firmNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Method to pick image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Optional: Method to remove the selected image
  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  // Validators for each field
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed to navigate to Get Request page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const Request(), // Navigate to your Get Request page
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Request')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "REQUEST",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "We invite you to create an account with EV Homes for access to exclusive real estate projects, offers, and updates. Simply share your details, and we’ll connect with you to get started.",
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                // Upload Icon field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    children: [
                      _selectedImage != null
                          ? CircleAvatar(
                              radius: 25,
                              backgroundImage: FileImage(_selectedImage!),
                            )
                          : const CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.upload),
                        label: const Text('Upload Icon'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black87,
                        ),
                      ),
                      if (_selectedImage != null)
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: _removeImage,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                // First Name and Last Name fields in a Row with validation
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration:
                              const InputDecoration(labelText: "First Name"),
                          validator: _validateName,
                          style: const TextStyle(
                              fontSize: 16), // Reduced font size
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration:
                              const InputDecoration(labelText: "Last Name"),
                          validator: _validateName,
                          style: const TextStyle(
                              fontSize: 16), // Reduced font size
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                // CP Firm Name field with validation
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _firmNameController,
                    decoration:
                        const InputDecoration(labelText: "CP Firm Name"),
                    validator: _validateName,
                    style: const TextStyle(fontSize: 16), // Reduced font size
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                // Email field with validation
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: _validateEmail,
                    style: const TextStyle(fontSize: 16), // Reduced font size
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                // Password field with validation
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: _validatePassword,
                    style: const TextStyle(fontSize: 16), // Reduced font size
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                // Phone Number field with validation
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration:
                        const InputDecoration(labelText: "Phone Number"),
                    validator: _validatePhoneNumber,
                    style: const TextStyle(fontSize: 16), // Reduced font size
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                // GET REQUEST button with form submission
                Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: GestureDetector(
                      onTap: _submitForm,
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 255, 136, 34),
                              Color.fromARGB(255, 255, 177, 41),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(0),
                        child: const Text(
                          "GET REQUEST",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   alignment: Alignment.centerRight,
                //   margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                //   child: GestureDetector(
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => const Logincp()),
                //       );
                //     },
                //     child: Text("Already have an account? Sign in"),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
