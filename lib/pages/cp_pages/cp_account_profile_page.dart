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
    // Initial data for the profile
    // final loggedUser =
    // Provider.of<SettingProvider>(context, listen: false).loggedUser;

    // _nameController.text = loggedUser?.name ?? "Unkown";
    // _emailController.text = loggedUser?.email ?? "Unkown";
    // _phoneController.text = loggedUser?.phoneNumber ?? "Unkown";
    // _addressController.text = loggedUser?.homeAddress ?? "Unkown";
    // _reraNoController.text = loggedUser?.reraNumber ?? "Rera not Registered";
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
    final loggedChannelPartner = settingProvider.loggedChannelPartner;
    // final loggedUser = Provider.of<SettingProvider>(context).loggedUser;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 240, 246),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            automaticallyImplyLeading: true,
            backgroundColor: Color(0xFF042630),
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
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
                  color: Color(0xFF042630),
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

            const SizedBox(height: 20.0),

            // Username
            // Text(
            //   loggedUser?.name ?? "Unkown",
            //   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 5.0),
            // Text(
            //   loggedUser?.email ?? "mahek@example.com",
            //   style: const TextStyle(color: Colors.deepPurple),
            // ),
            const SizedBox(height: 20.0),

            // Non-editable fields
            _buildTextField('Name',
                '${loggedChannelPartner?.firstName ?? ""} ${loggedChannelPartner?.lastName ?? ""}'),
            const SizedBox(height: 10.0),
            _buildTextField('Email', loggedChannelPartner?.email ?? ""),
            const SizedBox(height: 10.0),
            _buildTextField(
                'Phone', loggedChannelPartner?.phoneNumber?.toString() ?? ""),
            const SizedBox(height: 10.0),
            _buildTextField('Address', loggedChannelPartner?.firmAddress ?? ""),
            const SizedBox(height: 10.0),
            _buildTextField(
                'Rera Number', loggedChannelPartner?.reraNumber ?? ""),
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: value,
          ),
        ),
      ],
    );
  }
}
