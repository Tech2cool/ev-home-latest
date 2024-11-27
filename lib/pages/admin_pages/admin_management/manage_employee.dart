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

class ManageEmployee extends StatefulWidget {
  const ManageEmployee({super.key});

  @override
  State<ManageEmployee> createState() => _ManageEmployeeState();
}

class _ManageEmployeeState extends State<ManageEmployee> {
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
      final nameLower = employee.firstName.toLowerCase();
      final lastNameLower = employee.lastName.toLowerCase();
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              GoRouter.of(context).push("/add-employee");

              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => AddEmployeePage(),
              // ));
            },
            child: const Icon(Icons.add),
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
                                              .substring(0, 1)
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                                // Display name and employee ID in the title
                                title: Text(
                                  "${employee.firstName} ${employee.lastName} (${employee.employeeId})",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                // Display designation and email in the subtitle
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      employee.designation?.designation ??
                                          "Designation: NA",
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    const SizedBox(
                                        height:
                                            4), // Space between designation and email
                                    Text(
                                      employee.email,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton<String>(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      onTap: () {
                                        GoRouter.of(context).push(
                                          '/edit-employee',
                                          extra: employee,
                                        );
                                      },
                                      value: 'Edit',
                                      child: const Text('Edit'),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        _deleteEmployee(employee);
                                      },
                                      value: 'Delete',
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                  icon: const Icon(Icons.more_vert_rounded),
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

  void _deleteEmployee(Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: const Text('Are you sure you want to delete this employee?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Handle the delete logic here
              final settingProvider = Provider.of<SettingProvider>(
                context,
                listen: false,
              );
              setState(() {});
              await settingProvider.deleteEmployeeeById(employee.id!);
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
