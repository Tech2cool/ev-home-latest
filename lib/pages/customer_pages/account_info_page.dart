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
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile picture
            CircleAvatar(
              radius: 60.0,
              backgroundImage: const NetworkImage('https://picsum.photos/200'),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 20.0),
            // Non-editable fields
            _buildTextField('Name',
                '${loggedCustomer?.firstName ?? ""} ${loggedCustomer?.lastName ?? ""}'),

            const SizedBox(height: 10.0),
            _buildTextField('Email', loggedCustomer?.email ?? ""),
            const SizedBox(height: 10.0),
            _buildTextField(
                'Phone', loggedCustomer?.phoneNumber?.toString() ?? ""),
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
  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          enabled: false, // Non-editable
          decoration: InputDecoration(
            hintText: value, // Display the value as the text in the field
          ),
        ),
      ],
    );
  }
}
