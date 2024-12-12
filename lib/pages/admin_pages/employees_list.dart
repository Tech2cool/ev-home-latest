// import 'package:ev_homes/core/models/internal_models/department_model.dart';
// import 'package:ev_homes/core/models/internal_models/designation_model.dart';
// import 'package:ev_homes/core/models/internal_models/division_model.dart';
// import 'package:ev_homes/core/models/internal_models/employee.dart';
import 'package:ev_homes/components/loading/loading_square.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EmployeesList extends StatefulWidget {
  const EmployeesList({super.key});

  @override
  State<EmployeesList> createState() => _EmployeesListState();
}

class _EmployeesListState extends State<EmployeesList> {
  String searchQuery = '';
  bool isLoading = false;
  Future<void> _onRefresh() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    try {
      setState(() {
        isLoading = true;
      });
      await settingProvider.getEmployess();
    } catch (e) {
//
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final employees = settingProvider.employees;
    // Filter employees based on the search query
    final filteredEmployees = employees.where((employee) {
      final nameLower = employee.firstName?.toLowerCase() ?? '';
      final lastNameLower = employee.lastName?.toLowerCase() ?? '';
      final searchLower = searchQuery.toLowerCase();
      return nameLower.contains(searchLower) ||
          lastNameLower.contains(searchLower);
    }).toList();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Manage Employees'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search field
                TextField(
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search Employee',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                // List of employees
                Expanded(
                    child: filteredEmployees.isEmpty
                        ? const Center(
                            child: Text('No employees found.'),
                          )
                        : ListView.builder(
                            itemCount: filteredEmployees.length,
                            itemBuilder: (context, index) {
                              final employee = filteredEmployees[index];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 5,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: employee.profilePic != null
                                      ? Image.network(employee.profilePic!)
                                      : Text(
                                          employee.firstName
                                                  ?.substring(0, 1)
                                                  .toUpperCase() ??
                                              "",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                                title: Text(
                                  "${employee.firstName} ${employee.lastName} (${employee.employeeId})",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      employee.designation?.designation ??
                                          "Designation: NA",
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      employee.email ?? "",
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )),
              ],
            ),
          ),
        ),
        if (isLoading) const LoadingSquare(),
      ],
    );
  }
}
