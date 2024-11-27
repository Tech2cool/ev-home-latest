import 'package:ev_homes/core/models/department.dart';
import 'package:ev_homes/core/models/designation.dart';
import 'package:ev_homes/core/models/division.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdminRegisterCompanySection extends StatefulWidget {
  final int stage;
  final TextEditingController empIdController;
  final TextEditingController joiningDateController;

  final Designation? selectedDesignation;
  final Division? selectedDivision;
  final Department? selectedDepartment;
  final Employee? selectedReportingTo;
  final Function(Designation? designation) updateDesignation;
  final Function(Division? designation) updateDivision;
  final Function(Department? designation) updateDepartment;
  final Function(Employee? designation) updateReportingTo;

  const AdminRegisterCompanySection({
    super.key,
    required this.stage,
    required this.empIdController,
    required this.joiningDateController,
    required this.selectedDesignation,
    required this.selectedDivision,
    required this.selectedDepartment,
    required this.selectedReportingTo,
    required this.updateDesignation,
    required this.updateDivision,
    required this.updateDepartment,
    required this.updateReportingTo,
  });

  @override
  State<AdminRegisterCompanySection> createState() =>
      _AdminRegisterCompanySectionState();
}

class _AdminRegisterCompanySectionState
    extends State<AdminRegisterCompanySection>
    with SingleTickerProviderStateMixin {
  List<String> reportingToList = [
    'Jighnyasa Bhagat - (Team Leader)',
    'Deepak Kumar - (Site Head)',
    'Narayan Jha - (Data Analyzer)'
  ];
  List<String> designationList = [
    'Pre Sales Head',
    'Data Analyzer',
    'Sales Manager',
    'Site Head',
    'App Developer',
    'Team Leader'
  ];
  List<String> divisionList = ['Vashi Sector 10', 'Vashi sector 9'];
  List<String> departmentList = [
    'HR',
    'Marketing',
    'IT',
  ];

  late AnimationController _animationController;
  late Animation<double> _shinyAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _shinyAnimation =
        Tween<double>(begin: -1, end: 2).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final designations = settingProvider.designations;
    final divisions = settingProvider.divisions;
    final departments = settingProvider.departments;
    final employees = settingProvider.employees;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Existing Fields
                // const SizedBox(height: 15),
                // // Center(
                // //   child: Image.asset(
                // //     'assets/images/3.png',
                // //     height: 100,
                // //     width: 100,
                // //   ),
                // // ),
                // const SizedBox(height: 10),
                // Timeline tile
                // _buildTimelineTile(),
                const SizedBox(height: 15),
                const Text(
                  'Company Details',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Employee ID',
                        icon: Icons.badge,
                        controller: widget.empIdController,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter employee ID'
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                      width: 5,
                    ),
                    Expanded(child: _buildDateOfJoiningField(context)),
                  ],
                ),
                const SizedBox(height: 16),
                CustomDropDown<Designation>(
                  label: "Designation",
                  value: widget.selectedDesignation,
                  items: designations
                      .map((ele) => DropdownMenuItem<Designation>(
                            value: ele,
                            child: Text(ele.designation),
                          ))
                      .toList(),
                  onChanged: widget.updateDesignation,
                ),
                // _buildDropdownField(
                //   label: 'Designation',
                //   value: widget.selectedDesignation,
                //   items: designationList,
                //   onChanged: (value) {
                //     widget.updateDesignation(value);
                //     // setState(() {
                //     //   widget.selectedDesignation = value;
                //     // });
                //   },
                // ),
                const SizedBox(height: 16),
                CustomDropDown<Division>(
                  label: "Division",
                  value: widget.selectedDivision,
                  items: divisions
                      .map((ele) => DropdownMenuItem<Division>(
                            value: ele,
                            child: Text(ele.division),
                          ))
                      .toList(),
                  onChanged: widget.updateDivision,
                ),

                // _buildDropdownField(
                //   label: 'Division',
                //   value: widget.selectedDivision,
                //   items: divisionList,
                //   onChanged: (value) {
                //     widget.updateDivision(value);
                //     // setState(() {
                //     //   widget.selectedDivision = value;
                //     // });
                //   },
                // ),
                const SizedBox(height: 16),
                CustomDropDown<Department>(
                  label: "Department",
                  value: widget.selectedDepartment,
                  items: departments
                      .map((ele) => DropdownMenuItem<Department>(
                            value: ele,
                            child: Text(ele.department),
                          ))
                      .toList(),
                  onChanged: widget.updateDepartment,
                ),

                // _buildDropdownField(
                //   label: 'Department',
                //   value: widget.selectedDepartment,
                //   items: departmentList,
                //   onChanged: (value) {
                //     widget.updateDepartment(value);
                //     // setState(() {
                //     //   widget.selectedDepartment = value;
                //     // });
                //   },
                // ),
                const SizedBox(height: 16),
                CustomDropDown<Employee>(
                  label: "Reporting To",
                  value: widget.selectedReportingTo,
                  items: employees
                      .map((ele) => DropdownMenuItem<Employee>(
                            value: ele,
                            child: Text(
                              "${ele.firstName} ${ele.lastName} (${ele.designation?.designation ?? ""})",
                            ),
                          ))
                      .toList(),
                  onChanged: widget.updateReportingTo,
                ),

                // _buildDropdownField(
                //   label: 'Reporting To',
                //   value: widget.selectedReportingTo,
                //   items: reportingToList,
                //   onChanged: (value) {
                //     widget.updateReportingTo(value);
                //     // setState(() {
                //     //   widget.selectedReportingTo = value;
                //     // });
                //   },
                // ),
                const SizedBox(height: 32),
                // _buildNextButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateOfJoiningField(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        setState(() {
          widget.joiningDateController.text =
              DateFormat('dd/MM/yyyy').format(pickedDate!);
        });
      },
      child: AbsorbPointer(
        child: _buildTextField(
          label: 'Joining Date',
          icon: Icons.calendar_today,
          controller: widget.joiningDateController,
          validator: (value) {
            return value == null || value.isEmpty
                ? 'Please select joining date'
                : null;
          },
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black, fontSize: 12),
        // prefixIcon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      value: value,
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      focusNode: focusNode,
      style: const TextStyle(color: Colors.black, fontSize: 12),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black, fontSize: 12),
        prefixIcon: Icon(icon, color: Colors.black, size: 18),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      ),
      validator: validator,
    );
  }
}

class CustomDropDown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T? value) onChanged;

  const CustomDropDown(
      {super.key,
      required this.label,
      required this.value,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black, fontSize: 12),
        // prefixIcon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      value: value,
      items: items,
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }
}
