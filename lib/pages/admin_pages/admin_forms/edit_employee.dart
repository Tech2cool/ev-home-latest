import 'package:ev_homes/components/form_holder.dart';
import 'package:ev_homes/components/searchable_dropdown.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/department.dart';
import 'package:ev_homes/core/models/designation.dart';
import 'package:ev_homes/core/models/division.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/api_service.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditEmployee extends StatefulWidget {
  final Employee emp;
  const EditEmployee({super.key, required this.emp});

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  bool _showAddtionalDetails = false;
  bool _showPersonalDetails = false;
  bool isLoading = false;
  String? _selectedGender;
  String? _selectedStatus;
  DateTime? _selectedDate;
  Department? _selectedDepartment;
  Division? _selectedDivision;
  Designation? _selectedDesignation;
  Employee? _selectedReportingTo;
  String generatedPassword = "123456";
  // Text controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController employeIdController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController joingingDateController = TextEditingController();

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

  final List<DropdownMenuItem<String>> listOfStatus = const [
    DropdownMenuItem(
      value: "active",
      child: Text("Active"),
    ),
    DropdownMenuItem(
      value: "inactive",
      child: Text("In-active"),
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
    final newEmp = Employee(
      id: widget.emp.id,
      employeeId: employeIdController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      phoneNumber: int.parse(phoneController.text),
      dateOfBirth: dateOfBirthController.text,
      gender: _selectedGender ?? widget.emp.gender,
      address: addressController.text,
      isVerified: widget.emp.isVerified,
      department: _selectedDepartment,
      designation: _selectedDesignation,
      division: _selectedDivision,
      reportingTo: _selectedReportingTo,
      profilePic: widget.emp.profilePic,
      isVerifiedEmail: widget.emp.isVerifiedEmail,
      isVerifiedPhone: widget.emp.isVerifiedPhone,
      status: _selectedStatus ?? 'active',
    );
    Map<String, dynamic> newEmpMap = newEmp.toMap();
    if (_selectedReportingTo != null) {
      newEmpMap["reportingTo"] = _selectedReportingTo!.id;
    }
    if (_selectedDivision != null) {
      newEmpMap["division"] = _selectedDivision!.id;
    }
    if (_selectedDepartment != null) {
      newEmpMap["department"] = _selectedDepartment!.id;
    }
    if (_selectedDesignation != null) {
      newEmpMap["designation"] = _selectedDesignation!.id;
    }
    try {
      await ApiService().updateEmployee(widget.emp.id!, newEmpMap);
    } catch (e) {
      Helper.showCustomSnackBar(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    firstNameController.text = widget.emp.firstName ?? "";
    lastNameController.text = widget.emp.lastName ?? "";
    emailController.text = widget.emp.email ?? "";
    phoneController.text = widget.emp.phoneNumber.toString();
    addressController.text = widget.emp.address ?? "";
    employeIdController.text = widget.emp.employeeId ?? "";
    _selectedGender = widget.emp.gender?.toLowerCase() ?? "";
    dateOfBirthController.text = widget.emp.dateOfBirth ?? "";
    _selectedDepartment = widget.emp.department;
    _selectedDesignation = widget.emp.designation;
    _selectedDivision = widget.emp.division;
    _selectedReportingTo = widget.emp.reportingTo;
    _selectedStatus = widget.emp.status;
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final employees = settingProvider.employees;
    final designations = settingProvider.designations;
    final departments = settingProvider.departments;
    final divisions = settingProvider.divisions;

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
                        TextFormField(
                          controller: employeIdController,
                          decoration: InputDecoration(
                            labelText: 'Employee Id',
                            prefixIcon: const Icon(Icons.onetwothree),
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
                            return null;
                          },
                        ),

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
                          controller: addressController,
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
                        // Gender Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedStatus?.toLowerCase(),
                          items: listOfStatus,
                          hint: const Text("Select Status"),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Status',
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
                              _selectedStatus = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                  // SizedBox(height: 10),

                  const SizedBox(height: 10),

                  FormHolder(
                    selected: _showAddtionalDetails,
                    title: "Addtional Details",
                    onTap: () {
                      setState(() {
                        _showAddtionalDetails = !_showAddtionalDetails;
                      });
                    },
                    childrens: [
                      if (_showAddtionalDetails) ...[
                        const SizedBox(height: 16),
                        // Designation Dropdown _selectedDesignation
                        // Designation Dropdown _selectedDesignation
                        // Designation Dropdown _selectedDesignation
                        DropdownButtonFormField<Designation>(
                          value: designations.isNotEmpty &&
                                  _selectedDesignation != null &&
                                  designations.contains(_selectedDesignation)
                              ? _selectedDesignation
                              : null,
                          items: designations.map((ele) {
                            return DropdownMenuItem<Designation>(
                              value: ele,
                              child: Text(ele.designation),
                            );
                          }).toList(),
                          hint: const Text("Select Designation"),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Designation',
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
                              _selectedDesignation = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        // Department Dropdown
                        DropdownButtonFormField<Department>(
                          value: departments.contains(_selectedDepartment)
                              ? _selectedDepartment
                              : null,
                          items: departments
                              .map(
                                (ele) => DropdownMenuItem(
                                  value: ele,
                                  child: Text(ele.department),
                                ),
                              )
                              .toList(),
                          hint: const Text("Select Department"),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Department',
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
                              _selectedDepartment = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        // Division Dropdown
                        DropdownButtonFormField<Division>(
                          value: _selectedDivision,
                          items: divisions
                              .map(
                                (ele) => DropdownMenuItem(
                                  value: ele,
                                  child: Text(ele.division),
                                ),
                              )
                              .toList(),
                          hint: const Text("Select Devision"),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Division',
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
                              _selectedDivision = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        // Designation Dropdown
                        SearchableDropdown<Employee>(
                          initialSelection: _selectedReportingTo,
                          items: employees,
                          labelBuilder: (Employee? emp) {
                            if (emp == null) {
                              return "";
                            }
                            final name =
                                "${emp.firstName} ${emp.lastName} - (${emp.designation?.designation ?? "NA"})";
                            return name;
                          },
                          label: "Reporting To",
                          onChanged: (value) {
                            setState(() {
                              _selectedReportingTo = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[300],
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
                            backgroundColor: Colors.green[300],
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
