// import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class AccountProfilePage extends StatefulWidget {
  const AccountProfilePage({super.key});

  @override
  State<AccountProfilePage> createState() => _AccountProfilePageState();
}

class _AccountProfilePageState extends State<AccountProfilePage> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _reraNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _reraNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final loggedCustomer = settingProvider.loggedCustomer;
    // final loggedUser = Provider.of<SettingProvider>(context).loggedUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        // centerTitle: true,
        backgroundColor: Color.fromARGB(146, 134, 185, 176),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color.fromARGB(146, 134, 185, 176),
                  width: 4.0,
                ),
              ),
              child: CircleAvatar(
                radius: 56.0,
                backgroundImage:
                    const NetworkImage('https://picsum.photos/200'),
                backgroundColor: Colors.grey[300],
              ),
            ),

            const SizedBox(height: 10.0),
            _buildTextField(
              'Email',
              loggedCustomer?.email ?? "",
              Color(0xFF042630),
            ),
            const SizedBox(height: 10.0),
            _buildTextField(
              'Phone',
              loggedCustomer?.phoneNumber?.toString() ?? "",
              Color(0xFF042630),
            ),
            const SizedBox(height: 10.0),

            // _buildTextField('Address', loggedCustomer?.firmAddress ?? ""),
            // const SizedBox(height: 10.0),
            // _buildTextField(
            //     'Rera Number', loggedCustomer?.reraNumber ?? ""),
          ],
        ),
      ),
    );
  }

  // Function to build non-editable text field
  Widget _buildTextField(String label, String value, Color labelColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
        ),
        const SizedBox(height: 5),
        TextField(
          enabled: false, // Non-editable
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: value, // Display the value as the text in the field
          ),
        ),
      ],
    );
  }
}
