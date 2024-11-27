import 'package:ev_homes/components/form_holder.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/channel_partner.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/api_service.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditChannelPartner extends StatefulWidget {
  final ChannelPartner cp;
  const EditChannelPartner({super.key, required this.cp});

  @override
  State<EditChannelPartner> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditChannelPartner> {
  bool _showAddtionalDetails = false;
  bool _showPersonalDetails = false;
  bool isLoading = false;
  String? _selectedGender;
  DateTime? _selectedDate;
  final bool _showFirmDetails = false;
  bool _sameAddress = false;
  bool _haveReraNumber = false;

  late Map<String, dynamic> _formData;

  // Text controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController channelIdController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();
  TextEditingController firmNameController = TextEditingController();
  TextEditingController firmAddressController = TextEditingController();
  TextEditingController reraController = TextEditingController();
  TextEditingController reraCertificateController = TextEditingController();

  final List<DropdownMenuItem<String>> listOfGender = const [
    DropdownMenuItem(
      value: "male",
      child: Text("Male"),
    ),
    DropdownMenuItem(
      value: "female",
      child: Text("Female"),
    ),
    DropdownMenuItem(
      value: "other",
      child: Text("Other"),
    ),
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime initialDate = _selectedDate ?? today;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(today.year - 100),
      lastDate: today,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateOfBirthController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> onPressSubmit() async {
    // final Map<String, dynamic> originalData = widget.emp.toMap();
    // final Map<String, dynamic> updates = {};

    final newEmp = ChannelPartner(
      id: widget.cp.id,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      phoneNumber: int.parse(phoneController.text),
      dateOfBirth: dateOfBirthController.text,
      gender: _selectedGender ?? widget.cp.gender,
      homeAddress: homeAddressController.text,
      firmName: firmNameController.text,
      firmAddress: firmAddressController.text,
      reraNumber: reraController.text,
      reraCertificate: reraCertificateController.text,
    );
    Map<String, dynamic> newCPMap = newEmp.toMap();
    try {
      await ApiService().updateChannelPartner(widget.cp.id!, newCPMap);
    } catch (e) {
      Helper.showCustomSnackBar("Unkown Error Updating cp Details");
    }
  }

  @override
  void initState() {
    super.initState();
    // final settingProvider =
    //     Provider.of<SettingProvider>(context, listen: false);
    // final employees = settingProvider.employees;
    _formData = widget.cp.toMap();

    firstNameController.text = widget.cp.firstName ?? '';
    lastNameController.text = widget.cp.lastName ?? '';
    emailController.text = widget.cp.email;
    phoneController.text = widget.cp.phoneNumber.toString();
    phoneController.text = widget.cp.phoneNumber?.toString() ?? '';
    dateOfBirthController.text = widget.cp.dateOfBirth ?? '';
    _selectedGender = widget.cp.gender.toLowerCase();
    homeAddressController.text = widget.cp.homeAddress ?? '';
    firmNameController.text = widget.cp.firmName ?? '';
    firmAddressController.text = widget.cp.firmAddress ?? '';
    reraController.text = widget.cp.reraNumber ?? '';
    reraCertificateController.text = widget.cp.reraCertificate ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update employee details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  FormHolder(
                    selected: _showPersonalDetails,
                    title: "Personal Details",
                    onTap: () {
                      setState(() {
                        if (_showAddtionalDetails) {
                          _showAddtionalDetails = false;
                        }
                        _showPersonalDetails = !_showPersonalDetails;
                      });
                    },
                    childrens: [
                      if (_showPersonalDetails) ...[
                        const SizedBox(height: 16),

                        const SizedBox(height: 16),
                        // Name Field
                        TextFormField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            prefixIcon: const Icon(Icons.person),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.7),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a first name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Name Field
                        TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            prefixIcon: const Icon(Icons.person),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.7),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Last name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Phone Field
                        TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            prefixIcon: const Icon(Icons.phone),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.7),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Email Field
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.7),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            }
                            // Regular expression for email validation
                            final emailRegex = RegExp(
                              r'^[^@]+@[^@]+\.[^@]+$', // Basic email regex
                              caseSensitive: false,
                              multiLine: false,
                            );
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // date of birth
                        TextFormField(
                          controller: dateOfBirthController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            prefixIcon: const Icon(Icons.calendar_today),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.7),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                          ),
                          onTap: () => _selectDate(context),
                        ),
                        const SizedBox(height: 16),
                        // Gender Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedGender?.toLowerCase(),
                          items: listOfGender,
                          hint: const Text("Select Gender"),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.6),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            ),
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedGender = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        // Home address Field
                        TextFormField(
                          controller: homeAddressController,
                          minLines: 2,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: 'Home Address',
                            prefixIcon: const Icon(Icons.home_filled),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.7),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 15,
                            ), // Adjust padding
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),
                        TextFormField(
                          controller: firmNameController,
                          decoration: InputDecoration(
                            labelText: 'Firm Name',
                            prefixIcon: const Icon(Icons.apartment),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.7)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.4)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Same as Above"),
                              Checkbox(
                                value: _sameAddress,
                                onChanged: (value) {
                                  setState(() {
                                    _sameAddress = value!;
                                    if (value == true) {
                                      firmAddressController.text =
                                          homeAddressController.text;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          controller: firmAddressController,
                          minLines: 2,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: 'Firm Address',
                            prefixIcon: const Icon(Icons.home_filled),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.7)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.4)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                  // SizedBox(height: 10),

                  const SizedBox(height: 10),
                  if (!_haveReraNumber)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Rera registration?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withAlpha(240),
                              ),
                            ),
                          ),
                          Checkbox(
                            value: _haveReraNumber,
                            activeColor: Colors.green,
                            onChanged: (value) {
                              setState(() {
                                _haveReraNumber = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                  // Rera registration fields
                  if (_haveReraNumber) ...[
                    const SizedBox(height: 16),
                    // Rera Number Field
                    TextFormField(
                      controller: reraController,
                      decoration: InputDecoration(
                        labelText: 'Rera Number',
                        prefixIcon: const Icon(Icons.apartment),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.7)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.4)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Rera Certificate Field
                    TextFormField(
                      controller: reraCertificateController,
                      decoration: InputDecoration(
                        labelText: 'Rera Certificate',
                        prefixIcon: const Icon(Icons.document_scanner),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.7)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.4)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 95, 95),
                          ),
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 38, 83, 40),
                          ),
                          onPressed: onPressSubmit,
                          child: const Text(
                            "Update details",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
