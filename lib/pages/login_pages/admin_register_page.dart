import 'package:ev_homes/core/models/department.dart';
import 'package:ev_homes/core/models/designation.dart';
import 'package:ev_homes/core/models/division.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/sections/register_sections/admin_register_company_section.dart';
import 'package:ev_homes/sections/register_sections/admin_register_confirmation_section.dart';
import 'package:ev_homes/sections/register_sections/admin_register_personal_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

// Common Timeline Tile Widget
class CommonTimelineTile extends StatelessWidget {
  final int stage;

  const CommonTimelineTile({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 80,
                width: double.infinity,
                child: TimelineTile(
                  alignment: TimelineAlign.start,
                  isFirst: true,
                  axis: TimelineAxis.horizontal,
                  indicatorStyle: IndicatorStyle(
                    width: 30,
                    indicator: stage >= 0
                        ? const Icon(Icons.check_circle,
                            color: Colors.green, size: 24)
                        : const Icon(Icons.radio_button_unchecked,
                            size: 24, color: Colors.grey),
                  ),
                  beforeLineStyle: LineStyle(
                    color: stage > 0 ? Colors.green : Colors.grey,
                    thickness: 4,
                  ),
                  endChild: const Text(
                    "Personal Details",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 80,
                width: double.infinity,
                child: TimelineTile(
                  alignment: TimelineAlign.start,
                  axis: TimelineAxis.horizontal,
                  indicatorStyle: IndicatorStyle(
                    width: 30,
                    indicator: stage >= 1
                        ? const Icon(Icons.check_circle,
                            color: Colors.green, size: 24)
                        : const Icon(Icons.radio_button_unchecked,
                            size: 24, color: Colors.grey),
                  ),
                  beforeLineStyle: LineStyle(
                    color: stage > 1 ? Colors.green : Colors.grey,
                    thickness: 4,
                  ),
                  endChild: const Text(
                    "Company Details",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 80,
                width: double.infinity,
                child: TimelineTile(
                  alignment: TimelineAlign.start,
                  isLast: true,
                  axis: TimelineAxis.horizontal,
                  indicatorStyle: IndicatorStyle(
                    width: 30,
                    indicator: stage == 2
                        ? const Icon(Icons.check_circle,
                            color: Colors.green, size: 24)
                        : const Icon(Icons.radio_button_unchecked,
                            size: 24, color: Colors.grey),
                  ),
                  beforeLineStyle: LineStyle(
                    color: stage == 2 ? Colors.green : Colors.grey,
                    thickness: 4,
                  ),
                  endChild: const Text(
                    "Registration",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminRegisterPage extends StatefulWidget {
  const AdminRegisterPage({super.key});

  @override
  State<AdminRegisterPage> createState() => _AdminRegisterPageState();
}

class _AdminRegisterPageState extends State<AdminRegisterPage> {
  int stage = 0;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailAddressTextControlller =
      TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedGender;
  Designation? _selectedDesignation;
  Division? _selectedDivision;
  Department? _selectedDepartment;
  Employee? _selectedReportingTo;
  final bool _passwordVisibility = false;
  final TextEditingController _empIdController = TextEditingController();
  final TextEditingController _joiningDateController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  void updateGender(String? gender) {
    if (gender != null) {
      setState(() {
        _selectedGender = gender;
      });
    }
  }

  void updateDesignation(Designation? designation) {
    if (designation != null) {
      setState(() {
        _selectedDesignation = designation;
      });
    }
  }

  void updateDivision(Division? division) {
    if (division != null) {
      setState(() {
        _selectedDivision = division;
      });
    }
  }

  void updateDepartment(Department? department) {
    if (department != null) {
      setState(() {
        _selectedDepartment = department;
      });
    }
  }

  void updateReportingTo(Employee? reportingTo) {
    if (reportingTo != null) {
      setState(() {
        _selectedReportingTo = reportingTo;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _emailAddressTextControlller.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _empIdController.dispose();
    _joiningDateController.dispose();
    super.dispose();
  }

  void _navigateToStage(int newStage) {
    setState(() {
      stage = newStage;
    });
  }

  void handleSubmit() async {
    final newEmp = Employee(
      id: '',
      employeeId: _empIdController.text.trim(),
      firstName: _nameController.text,
      lastName: _lastNameController.text,
      email: _emailAddressTextControlller.text.trim(),
      status: "active",
      phoneNumber: int.parse(_phoneController.text),
      dateOfBirth: _dobController.text,
      gender: _selectedGender!,
      address: _addressController.text,
      isVerified: false,
      department: _selectedDepartment,
      division: _selectedDivision,
      designation: _selectedDesignation,
      reportingTo: _selectedReportingTo,
    );
    Map<String, dynamic> empMap = newEmp.toMap();

    if (newEmp.reportingTo != null) {
      empMap['reportingTo'] = newEmp.reportingTo!.id;
    }
    if (newEmp.department != null) {
      empMap['department'] = newEmp.department!.id;
    }

    if (newEmp.division != null) {
      empMap['division'] = newEmp.division!.id;
    }
    if (newEmp.designation != null) {
      empMap['designation'] = newEmp.division!.id;
    }

    empMap['password'] = _passwordController.text;
    empMap['confirmPassword'] = _confirmPasswordController.text;
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    await settingProvider.addEmployee(context, empMap);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final designations = settingProvider.designations;
    final divisions = settingProvider.divisions;
    final departments = settingProvider.departments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Registration'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 12,
            ),
            // Common Timeline Tile
            CommonTimelineTile(stage: stage),

            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  if (stage == 0)
                    AdminRegisterPersonalSection(
                      nameController: _nameController,
                      lastNameController: _lastNameController,
                      phoneController: _phoneController,
                      addressController: _addressController,
                      dobController: _dobController,
                      selectedGender: _selectedGender,
                      emailAddressTextController: _emailAddressTextControlller,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      passwordVisibility: _passwordVisibility,
                      updateGender: updateGender,
                    ),
                  if (stage == 1)
                    AdminRegisterCompanySection(
                      stage: stage,
                      empIdController: _empIdController,
                      joiningDateController: _joiningDateController,
                      selectedDesignation: _selectedDesignation,
                      selectedDivision: _selectedDivision,
                      selectedDepartment: _selectedDepartment,
                      selectedReportingTo: _selectedReportingTo,
                      updateDesignation: updateDesignation,
                      updateDivision: updateDivision,
                      updateDepartment: updateDepartment,
                      updateReportingTo: updateReportingTo,
                    ),
                  if (stage == 2)
                    AdminRegisterConfirmationSection(
                      stage: stage,
                      otpController: _otpController,
                    )
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (stage == 1 || stage == 2)
                  GestureDetector(
                    onTap: () {
                      if (stage == 1) {
                        _navigateToStage(0);
                      } else if (stage == 2) {
                        _navigateToStage(1);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        // border: Border.all(
                        //   color: Colors.black, // Border color
                        // ),
                      ),
                      child: const Text(
                        'Previous',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFFF745C),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  width: 12,
                ),
                if (stage == 0)
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (stage == 0) {
                          _navigateToStage(1);
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF745C),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                if (stage == 1)
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        handleSubmit();
                        // if (stage == 1) {
                        //   _navigateToStage(2);
                        // }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF745C),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                if (stage == 2)
                  GestureDetector(
                    onTap: () {
                      if (stage == 2) {
                        // _navigateToStage(2);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF745C),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'Verify',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),

            // ElevatedButton(
            //   onPressed: () => _navigateToStage(0),
            //   child: const Text("Previous"),
            // ),
            // ElevatedButton(
            //   onPressed: () => _navigateToStage(1),
            //   child: const Text("Next"),
            // ),
            // ElevatedButton(
            //   onPressed: () => _navigateToStage(2),
            //   child: const Text("Submit"),
            // ),
          ],
        ),
      ),
    );
  }
}
