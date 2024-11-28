import 'dart:async';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/models/site_visit.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
import 'package:provider/provider.dart';

class AddSiteVisitFormPage extends StatefulWidget {
  const AddSiteVisitFormPage({super.key});

  @override
  State<AddSiteVisitFormPage> createState() => _AddSiteVisitFormPageState();
}

String formatSeconds(int totalSeconds) {
  int minutes = totalSeconds ~/ 60; // Use integer division to get the minutes
  int seconds = totalSeconds % 60; // Get the remaining seconds

  // Format minutes and seconds to be two digits
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

class _AddSiteVisitFormPageState extends State<AddSiteVisitFormPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController feebackController = TextEditingController();
  TextEditingController attendedByController = TextEditingController();
  TextEditingController calledByController = TextEditingController();
  TextEditingController teamLeaderNameController = TextEditingController();
  TextEditingController teamLeaderEmailController = TextEditingController();
  TextEditingController teamLeaderPhoneController = TextEditingController();
  Timer? _periodicTimer;
  int _counter = 10;
  bool showTimer = false;
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  String? selectedPrefix = 'Mr.';
  final List<String> prefixes = ['Mr.', 'Ms.', 'Miss', 'Dr.'];
  String? selectedAddress;
  bool isLoading = false;
  final List myList2 = const [
    '1RK',
    '1BHK',
    '2BHK',
    '3BHK',
    'Jodi',
  ];
  bool resendPass = false;
  String? _selectedSource;
  Employee? _selectedClosingManger;
  Employee? _selectedTeamLeader;
  final List myList = const ['Ev 9 Square', 'Ev heart city', 'Marina Bay'];
  List<OurProject> selectedProject = [];
  // List<String> selectedProject = [];
  List<String> selectedRequirement = [];
  List<String> listofSource = ['Walk-in', 'CP', 'Ref'];
  Employee? _selectedDataEntryUser;

  void startPeriodicTimer() {
    if (_periodicTimer?.isActive == true) {
      _periodicTimer?.cancel();
    }
    _periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
          if (resendPass == false) {
            resendPass = true;
          }
        } else {
          showTimer = false;
          _counter = 10;
          _periodicTimer?.cancel();
        }
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime initialDate = _selectedDate ?? today;

    // Date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(today.year - 100),
      lastDate: today,
    );

    if (pickedDate != null) {
      // Time picker
      if (context.mounted) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          setState(() {
            // Combine the selected date and time
            _selectedDate = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            // Format the combined date and time as you wish
            _dateController.text = DateFormat("dd MMM yy hh:mm a").format(
              _selectedDate!,
            );
          });
        }
      }
    }
  }

  Future<void> onPressSubmit() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Simulate successful submission
      setState(() {
        isLoading = false;
      });
      final settingProvider = Provider.of<SettingProvider>(
        context,
        listen: false,
      );
      final newVisit = SiteVisit(
        projects: selectedProject,
        choiceApt: selectedRequirement,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        closingManager: _selectedClosingManger,
        date: _selectedDate,
        phoneNumber: int.parse(phoneController.text),
        email: emailController.text.trim(),
        residence: addressController.text,
        dataEntryBy: _selectedDataEntryUser,
        namePrefix: selectedPrefix,
        gender: selectedPrefix?.toLowerCase() == 'mr' ? 'male' : 'female',
      );

      Map<String, dynamic> visitMap = newVisit.toMap();
      if (newVisit.closingManager != null) {
        visitMap['closingManager'] = newVisit.closingManager!.id!;
      }

      if (newVisit.attendedBy != null) {
        visitMap['attendedBy'] = newVisit.attendedBy!.id!;
      }

      if (newVisit.dataEntryBy != null) {
        visitMap['dataEntryBy'] = newVisit.dataEntryBy!.id!;
      }

      try {
        await settingProvider.addSiteVisit(visitMap);
      } catch (e) {
        // print(e);
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: const EdgeInsets.only(
              top: 12,
              bottom: 5,
              right: 10,
              left: 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Data Saved Succesfully"),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.all(0),
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          // GoRouter.of(context)
                          //     .pushReplacement("/manage-site-visit");
                        },
                        child: const Text(
                          "OK",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );

    try {
      setState(() {
        isLoading = true;
      });

      // Execute all three futures concurrently
      await Future.wait([
        settingProvider.getRequirements(),
        settingProvider.getClosingManagers(),
        settingProvider.getDataEntryEmployess(),
        settingProvider.getTeamLeaders(),
      ]);
    } catch (e) {
      // Handle any errors if needed
      // print('Error during refresh: $e');
    } finally {
      // Ensure isLoading is set to false in both success and error cases
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final DateTime today = DateTime.now();

    _selectedDate = today;

    _dateController.text = DateFormat("dd MMM yy hh:mm a").format(
      DateTime.now(),
    );
    _onRefresh();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    feebackController.dispose();
    attendedByController.dispose();
    calledByController.dispose();
    teamLeaderNameController.dispose();
    teamLeaderEmailController.dispose();
    teamLeaderPhoneController.dispose();
    _periodicTimer?.cancel();
    super.dispose();
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Are you sure?"),
            content: const Text("Do you really want to go back?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                },
                child: const Text("Yes"),
              ),
            ],
          ),
        ) ??
        false; // Return `false` by default if the dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final closingMangers = settingProvider.dataEntryUsers;
    final teamLeaders = settingProvider.teamLeaders;
    final requirements = settingProvider.requirements;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        appBar: _selectedDataEntryUser != null
            ? AppBar(
                title: const Text("Site Visit Form"),
                actions: [
                  if (_selectedDataEntryUser != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        _selectedDataEntryUser?.firstName ?? '...',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 50,
                      width: 300,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButtonFormField<Employee>(
                        value: _selectedDataEntryUser,
                        items: closingMangers
                            .map((ele) => DropdownMenuItem(
                                  value: ele,
                                  child: Text(ele.firstName ?? ""),
                                ))
                            .toList(),
                        hint: const Text("User"),
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          labelText: 'User',
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
                            _selectedDataEntryUser = newValue;
                          });
                        },
                      ),
                    ),
                ],
              )
            : null,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Column(
                  children: [
                    // Date of Birth
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date & Time',
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
                    // Name Field with Prefix Dropdown
                    // if (width > 500)
                    Column(
                      children: [
                        TextFormField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            prefixIcon: const Icon(Icons.person),
                            prefix: DropdownButtonHideUnderline(
                              child: SizedBox(
                                height: 25,
                                child: DropdownButton<String>(
                                  value: selectedPrefix,
                                  items: prefixes.map((String prefix) {
                                    return DropdownMenuItem<String>(
                                      value: prefix,
                                      child: Text(
                                        prefix,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedPrefix = newValue;
                                    });
                                  },
                                ),
                              ),
                            ),
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
                        ),
                        const SizedBox(height: 16),
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
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            labelText: 'Phone',
                            prefixIcon: const Icon(Icons.phone),
                            prefix: const Text("+91 "),
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
                          onChanged: (val) {
                            if (val.length >= 10 && val.isNotEmpty) {
                              setState(() {});
                            }
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
                        ),
                        const SizedBox(height: 16),
                        // Residence Field
                        TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                            labelText: 'Residence',
                            prefixIcon: const Icon(Icons.location_on),
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
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: MultiSelectDropdown.simpleList(
                                list: myList,
                                boxDecoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.4)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                initiallySelected: selectedProject,
                                checkboxFillColor: Colors.grey.withOpacity(0.3),
                                splashColor: Colors.grey.withOpacity(0.3),
                                includeSearch: true,
                                whenEmpty: "Projects",
                                onChange: (newList) {
                                  //TODO:our project multi select
                                  // selectedProject =
                                  //     newList.map((e) => e as String).toList();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MultiSelectDropdown.simpleList(
                                list: requirements,

                                boxDecoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                initiallySelected: selectedRequirement,
                                checkboxFillColor: Colors.grey.withOpacity(0.3),
                                splashColor: Colors.grey.withOpacity(0.3),
                                // includeSearch: true,
                                whenEmpty: "Choice of Apartment",
                                onChange: (newList) {
                                  selectedRequirement =
                                      requirements.map((e) => e).toList();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedSource,
                                decoration: InputDecoration(
                                  labelText: 'Source',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: listofSource.map((source) {
                                  return DropdownMenuItem<String>(
                                    value: source,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            source,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedSource = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a Source';
                                  }
                                  return null;
                                },
                                isExpanded: true,
                              ),
                            ),
                            // Expanded(
                            //   child: MultiSelectDropdown.simpleList(
                            //     list: listofSource,
                            //     boxDecoration: BoxDecoration(
                            //       border: Border.all(
                            //           color: Colors.grey.withOpacity(0.4)),
                            //       borderRadius: BorderRadius.circular(12),
                            //     ),
                            //     initiallySelected: selectedRequirement,
                            //     checkboxFillColor: Colors.grey.withOpacity(0.3),
                            //     splashColor: Colors.grey.withOpacity(0.3),
                            //     includeSearch: true,
                            //     whenEmpty: "Source",
                            //     onChange: (newList) {
                            //       selectedRequirement =
                            //           newList.map((e) => e as String).toList();
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<Employee>(
                                value: _selectedClosingManger,
                                decoration: InputDecoration(
                                  labelText: 'Closing Manager',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: closingMangers.map((teamleader) {
                                  return DropdownMenuItem<Employee>(
                                    value: teamleader,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${teamleader.firstName} ${teamleader.lastName}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            "(${teamleader.designation?.designation ?? "NA"})",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedClosingManger = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a Closing Manager';
                                  }
                                  return null;
                                },
                                isExpanded: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        // Row(
                        // children: [
                        //     Expanded(
                        //       child: DropdownButtonFormField<Employee>(
                        //         value: _selectedTeamLeader,
                        //         decoration: InputDecoration(
                        //           labelText: 'Team Leader',
                        //           border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(20),
                        //           ),
                        //         ),
                        //         items: teamLeaders.map((teamleader) {
                        //           return DropdownMenuItem<Employee>(
                        //             value: teamleader,
                        //             child: Row(
                        //               children: [
                        //                 Expanded(
                        //                   child: Text(
                        //                     "${teamleader.firstName} ${teamleader.lastName}",
                        //                     overflow: TextOverflow.ellipsis,
                        //                     maxLines: 1,
                        //                   ),
                        //                 ),
                        //                 const SizedBox(width: 4),
                        //                 Flexible(
                        //                   child: Text(
                        //                     "(${teamleader.designation?.designation ?? "NA"})",
                        //                     overflow: TextOverflow.ellipsis,
                        //                     maxLines: 1,
                        //                     style:
                        //                         const TextStyle(fontSize: 12),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           );
                        //         }).toList(),
                        //         onChanged: (newValue) {
                        //           setState(() {
                        //             _selectedTeamLeader = newValue;
                        //           });
                        //         },
                        //         validator: (value) {
                        //           if (value == null) {
                        //             return 'Please select a Team Leader';
                        //           }
                        //           return null;
                        //         },
                        //         isExpanded: true,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 16),
                        // MultiSelectDropdown.simpleList(
                        //   list:
                        //       filteredTeamSrTeam, // Assuming this is a static or mock data list
                        //   boxDecoration: BoxDecoration(
                        //     border:
                        //         Border.all(color: Colors.grey.withOpacity(0.4)),
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        //   initiallySelected:
                        //       _selectedClosingMangerTeamNames, // Assuming this is mock data for UI purposes
                        //   checkboxFillColor: Colors.grey.withOpacity(0.3),
                        //   splashColor: Colors.grey.withOpacity(0.3),
                        //   includeSearch: true,
                        //   includeSelectAll: true,
                        //   whenEmpty: "Team",
                        //   onChange: (newList) {
                        //     // Keeping UI-only functionality, no actual logic change needed
                        //     setState(() {
                        //       _selectedClosingMangerTeamNames =
                        //           newList.map((e) => e as String).toList();
                        //     });
                        //   },
                        // ),
                        const SizedBox(height: 26),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[300],
                                ),
                                onPressed: () async {
                                  await _showExitConfirmationDialog(context);
                                  // GoRouter.of(context).pop();
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
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 30),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_selectedDataEntryUser == null) ...[
              Container(
                color: Colors.black.withOpacity(0.4),
                height: MediaQuery.sizeOf(context).height,
                child: Center(
                  child: DataEntryScreen(
                    selectedEmployee: _selectedDataEntryUser,
                    listOfUser: closingMangers,
                    onSelect: (emp) {
                      setState(() {
                        _selectedDataEntryUser = emp;
                      });
                    },
                  ),
                ),
              ),
            ]
          ],
        ),
      );
    });
  }
}

class DataEntryScreen extends StatelessWidget {
  final Employee? selectedEmployee;
  final List<Employee> listOfUser;
  final Function(Employee emp) onSelect;

  const DataEntryScreen({
    super.key,
    required this.selectedEmployee,
    required this.listOfUser,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: DropdownButtonFormField<Employee>(
              value: selectedEmployee,
              dropdownColor: Colors.white,
              items: listOfUser
                  .map(
                    (ele) => DropdownMenuItem<Employee>(
                      value: ele,
                      child: Text("${ele.firstName} ${ele.lastName}"),
                    ),
                  )
                  .toList(),
              hint: const Text("User"),
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: 16,
              ),
              decoration: InputDecoration(
                // fillColor: Colors.white,
                // filled: true,
                labelText: 'Select',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.6),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
              onChanged: (newValue) {
                onSelect(newValue!);
              },
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
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
                  onPressed: () {
                    // if (selectedEmployee != null) {
                    //   Navigator.of(context).pop();
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text("Select Source First"),
                    //     ),
                    //   );
                    // }
                  },
                  child: const Text(
                    "Submit",
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
    );
  }
}
