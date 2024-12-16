import 'dart:io';
import 'package:ev_homes/components/digital_clock.dart';
import 'package:ev_homes/components/loading/loading_square.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/division.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/models/meetingSummary.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:ev_homes/pages/admin_pages/admin_forms/add_postsale_lead.dart';
import 'package:ev_homes/pages/admin_pages/admin_forms/add_site_visit_form_page.dart';
import 'package:ev_homes/pages/admin_pages/followup_page.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/costsheet_generator_marina_bay.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/costsheet_generator_nine_square.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/demand_letter.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/demand_letter_9_square.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/payment_schedule%20_nine_square.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/payment_schedule_marina_bay.dart';
import 'package:ev_homes/pages/admin_pages/pre_sales_pages/data_analyzer_pages/data_analyzer_lead_details_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ClosingManagerLeadDetailsPage extends StatefulWidget {
  final Lead lead;
  const ClosingManagerLeadDetailsPage({super.key, required this.lead});

  @override
  _ClosingManagerLeadDetailsPageState createState() =>
      _ClosingManagerLeadDetailsPageState();
}

class _ClosingManagerLeadDetailsPageState
    extends State<ClosingManagerLeadDetailsPage> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  DateTime? _selectedDateTime;
  bool showNotification = false;
  bool showScheduleMeeting = false;
  bool isLoading = false;
  bool _isPreviewVisible = false;
  DateTime? _selectedDate;
  String? selectedStatus;
  String? selectedGenerate;

  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _notificationController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _templateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _projectController = TextEditingController();
  OurProject? _selectedProject;
  String? selectedPurpose;
  Division? selectedPlace;
  final purposes = ['Pricing', 'Booking', 'Negotiation', 'Payment'];

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages = images;
      });
    }
  }

  void _handleDateTimeChanged(DateTime dateTime) {
    setState(() {
      _selectedDateTime = dateTime;
    });
  }

  void _onPressedSendNotification() {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return Dialog(
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(12.0),
    //       ),
    //       child: _buildNotificationSection(),
    //     );
    //   },
    // );
    setState(() {
      if (showNotification == true) {
        showNotification = false;
      } else {
        showNotification = true;
      }
    });
  }

  void _onPressedScheduleMeeting() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: _buildAppointmentSection(),
        );
      },
    );
  }

  void _submitAppointment() {
    if (_selectedDateTime != null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //         'Appointment set for: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!)}'),
      //     backgroundColor: Colors.green,
      //   ),
      // );
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Please select a date and time'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    }
  }

  void _showAssignTaskDialog(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    final loggedUser = settingProvider.loggedAdmin?.id;

    String? selectedSubject;
    Employee? selectedAssignee;
    final subjectController = TextEditingController();
    final taskNameController = TextEditingController();
    final taskDetailsController = TextEditingController();

    if (loggedUser != null) {
      final reportingEmployees = settingProvider.reportingEmps;
      print(
          "Employees reporting to loggedUser ($loggedUser):$reportingEmployees");
      // print(settingProvider.employees);
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Assign Task",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 10),
                    // Row(
                    //   children: [
                    //     Text(
                    //       "Refrence: ",
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //     Text("This Lead"),
                    //   ],
                    // ),
                    const SizedBox(height: 10),
                    const Text("Subject"),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: selectedSubject,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: "first-call",
                          child: Text("First Call"),
                        ),
                        const DropdownMenuItem(
                          value: "followup",
                          child: Text("Follow-Up"),
                        ),
                        const DropdownMenuItem(
                          value: "schedule-meeting",
                          child: Text("Schedule Meeting"),
                        ),
                      ],
                      onChanged: (value) {
                        selectedSubject = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    const Text("Task Name"),
                    const SizedBox(height: 5),
                    TextField(
                      controller: taskNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Task Details"),
                    const SizedBox(height: 5),
                    TextField(
                      controller: taskDetailsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Assign To"),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<Employee>(
                      value: reportingEmployees.contains(selectedAssignee)
                          ? selectedAssignee
                          : null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: reportingEmployees
                          .map((employee) => DropdownMenuItem<Employee>(
                                value: employee,
                                child: Text(
                                    '${employee.firstName} ${employee.lastName}'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAssignee = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Deadline',
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
                      ),
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            elevation: 1,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 151, 245, 154),
                          ),
                          onPressed: () async {
                            Map<String, dynamic> data = {
                              "assignBy": settingProvider.loggedAdmin!.id!,
                              "assignTo": selectedAssignee!.id!,
                              "name": taskNameController.text,
                              "details": taskDetailsController.text,
                              "lead": widget.lead.id,
                              "type": selectedSubject,
                              "deadline": _selectedDate?.toIso8601String(),
                            };

                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await ApiService().addTask(
                                selectedAssignee!.id!,
                                data,
                              );
                            } catch (e) {
                              //
                            } finally {
                              setState(() {
                                isLoading = false;
                              });

                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text("Submit"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  String getStatus(Lead lead) {
    if (lead.stage == "visit") {
      return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.visitStatus ?? '')}";
    } else if (lead.stage == "revisit") {
      return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.revisitStatus ?? '')}";
    } else if (lead.stage == "booking") {
      return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.bookingStatus ?? '')}";
    }

    return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.visitStatus ?? '')}";
  }

  Future<void> onRefresh() async {
    try {
      final settingProvider = Provider.of<SettingProvider>(
        context,
        listen: false,
      );
      setState(() {
        isLoading = true;
      });
      await settingProvider.getReportingToEmps(
        widget.lead.teamLeader!.id!,
      );
      await settingProvider.getTask(
        settingProvider.loggedAdmin!.id!,
      );
      await settingProvider.getDivision();
    } catch (e) {
      //
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showProjectDialogForCostSheet() async {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    final projects = settingProvider.ourProject;
    OurProject? selectedProject;
    // print(settingProvider.ourProject);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Project'),
          content: DropdownButtonFormField<OurProject>(
            value: projects.contains(selectedProject) ? selectedProject : null,
            decoration: InputDecoration(
              labelText: 'Select Project',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            items: projects.map((project) {
              return DropdownMenuItem<OurProject>(
                value: project,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.name ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedProject = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a Project';
              }
              return null;
            },
            isExpanded: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedProject!.name!.toLowerCase().contains("square")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CostGenerators(lead: widget.lead),
                    ),
                  );
                }
                if (selectedProject!.name!.toLowerCase().contains("marina")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CostGenerator(lead: widget.lead),
                    ),
                  );
                }
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
    // print(selectedProject);
  }

  Future<void> _showProjectDialogForPaymentSchedule() async {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    final projects = settingProvider.ourProject;
    OurProject? selectedProject;
    // print(settingProvider.ourProject);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Project'),
          content: DropdownButtonFormField<OurProject>(
            value: projects.contains(selectedProject) ? selectedProject : null,
            decoration: InputDecoration(
              labelText: 'Select Project',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            items: projects.map((project) {
              return DropdownMenuItem<OurProject>(
                value: project,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.name ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedProject = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a Project';
              }
              return null;
            },
            isExpanded: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedProject!.name!.toLowerCase().contains("square")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScheduleGenerators(
                        lead: widget.lead,
                      ),
                    ),
                  );
                }
                if (selectedProject!.name!.toLowerCase().contains("marina")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PaymentScheduleGenerator(lead: widget.lead),
                    ),
                  );
                }
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
    // print(selectedProject);
  }

  Future<void> _showProjectDialogForDemand() async {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    final projects = settingProvider.ourProject;
    OurProject? selectedProject;
    // print(settingProvider.ourProject);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Project'),
          content: DropdownButtonFormField<OurProject>(
            value: projects.contains(selectedProject) ? selectedProject : null,
            decoration: InputDecoration(
              labelText: 'Select Project',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            items: projects.map((project) {
              return DropdownMenuItem<OurProject>(
                value: project,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.name ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedProject = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a Project';
              }
              return null;
            },
            isExpanded: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedProject!.name!.toLowerCase().contains("square")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DemandLetter(lead: widget.lead),
                    ),
                  );
                }
                if (selectedProject!.name!.toLowerCase().contains("marina")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DemandLetter10(lead: widget.lead),
                    ),
                  );
                }
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
    // print(selectedProject);
  }

  void _handleSubmit() async {
    print("yes");
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);

    final newMeeting = MeetingSummary(
        date: _selectedDateTime,
        // place: selectedPlace,
        purpose: selectedPurpose!,
        project: _selectedProject,
        lead: widget.lead,
        meetingWith: settingProvider.loggedAdmin,
        customer: null);
    // print("yes1");
    Map<String, dynamic> meetingSummary = newMeeting.toMap();
    // if (newMeeting.customer != null) {
    //   meetingSummary['customer'] = newMeeting.customer!.id;
    // }
    // print(meetingSummary);
    // print("yes3");
    try {
      await settingProvider.addMeetingSummary(meetingSummary);
      // print("yes4");
    } catch (e) {
      // print(e);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime initialDate = _selectedDate ?? today;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(today.year - 100),
      lastDate: today.add(const Duration(days: 30)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    onRefresh();
    _selectedDateTime = DateTime.now();
    _nameController.text =
        '${widget.lead?.firstName ?? ""} ${widget.lead?.lastName ?? ""}';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Client Details',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.indigo,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            actionsIconTheme: const IconThemeData(color: Colors.white),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'send_notification':
                      _buildNotificationSection();
                      break;
                    case 'schedule_meeting':
                      _submitAppointment();
                      break;
                    case 'assign_tasks':
                      _showAssignTaskDialog(context);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'send_notification',
                      child: const Text('Send Notification'),
                      onTap: _onPressedSendNotification,
                    ),
                    PopupMenuItem<String>(
                      value: 'schedule_meeting',
                      child: const Text('Schedule Meeting'),
                      onTap: _onPressedScheduleMeeting,
                    ),
                    const PopupMenuItem<String>(
                      value: 'assign_tasks',
                      child: Text('Assign Tasks'),
                    ),
                    PopupMenuItem<String>(
                      enabled: false,
                      child: Row(
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(
                              color: Colors.black, // Black color for the text
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButton<String>(
                              value: selectedStatus,
                              underline: const SizedBox.shrink(),
                              isExpanded:
                                  true, // Ensure it uses the available space
                              onChanged: (value) async {
                                if (value?.toLowerCase() == "visited") {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddSiteVisitFormPage(
                                        lead: widget.lead,
                                        status: "visit",
                                      ),
                                    ),
                                  );
                                } else if (value?.toLowerCase() ==
                                    "revisited") {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddSiteVisitFormPage(
                                        lead: widget.lead,
                                        status: "revisit",
                                      ),
                                    ),
                                  );
                                } else if (value?.toLowerCase() ==
                                    "virtual-meeting") {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddSiteVisitFormPage(
                                        lead: widget.lead,
                                        status: "virtual-meeting",
                                      ),
                                    ),
                                  );
                                }

                                setState(() {
                                  selectedStatus = value;
                                  if (value?.toLowerCase() == 'booked') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => AddPostsaleLead(
                                          lead: widget.lead,
                                        ),
                                      ),
                                    );
                                  }
                                });
                              },
                              items: <String>[
                                'called',
                                'visited',
                                'revisited',
                                'virtual-meeting',
                                'booked'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'follow_up',
                      child: const Text('Follow-Up'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FollowupPage(lead: widget.lead),
                          ),
                        );
                      },
                    ),
                    PopupMenuItem<String>(
                      enabled: false,
                      child: Row(
                        children: [
                          const Text(
                            'Generate',
                            style: TextStyle(
                              color: Colors.black, // Black color for the text
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButton<String>(
                              // value: selectedGenerate,
                              underline: const SizedBox.shrink(),
                              isExpanded: true,
                              onChanged: (value) async {
                                if (value == "Cost Sheet Generator") {
                                  _showProjectDialogForCostSheet();
                                } else if (value == "Payment Schedule") {
                                  _showProjectDialogForPaymentSchedule();
                                } else if (value == "Demand Letter") {
                                  _showProjectDialogForDemand();
                                }

                                setState(() {
                                  selectedGenerate = value;
                                });
                              },
                              items: <String>[
                                'Cost Sheet Generator',
                                'Payment Schedule',
                                'Demand Letter',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: onRefresh,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildClientOverview(),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: 300, // Adjust width to control the grid layout
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              SizedBox(
                                width:
                                    140, // Half the width for two cards in a row
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: _onPressedSendNotification,
                                    child: const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.notification_add,
                                          size: 40,
                                          color: Colors.orangeAccent,
                                        ),
                                        SizedBox(height: 10),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Send Notification",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width:
                                    140, // Half the width for two cards in a row
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: _onPressedScheduleMeeting,
                                    child: const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.meeting_room,
                                          size: 40,
                                          color: Colors.orangeAccent,
                                        ),
                                        SizedBox(height: 10),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Schedule Meeting",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double
                                    .infinity, // Full width for the rectangle card
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: () => _showAssignTaskDialog(context),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.task,
                                          size: 40,
                                          color: Colors.orangeAccent,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Assign",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Task",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const SizedBox(height: 24),
                      if (widget.lead.cycleHistory.isNotEmpty) ...[
                        const Text(
                          'Follow-up History',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(
                          widget.lead.cycleHistory.length,
                          (i) {
                            final appl = widget.lead.cycleHistory[i];
                            return CustomTimelineTile(
                              title: appl.teamLeader != null
                                  ? "${appl.teamLeader?.firstName ?? ''} ${appl.teamLeader?.lastName ?? ''}"
                                  : "NA",
                              date:
                                  "${Helper.formatDate(appl.startDate?.toString() ?? '')} to ${Helper.formatDate(appl.validTill?.toString() ?? '')}",
                              description: appl.stage ?? "NA",
                              color: Colors.red.withOpacity(0.8),
                              isFirst: i == 0,
                              isLast: i == widget.lead.callHistory.length - 1,
                            );
                          },
                        ),
                      ],
                      if (widget.lead.callHistory.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: Text(
                            'Follow-up History',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(
                          widget.lead.callHistory.length,
                          (i) {
                            final appl = widget.lead.callHistory[i];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: CustomTimelineTile(
                                title: appl.caller != null
                                    ? "${appl.caller?.firstName ?? ''} ${appl.caller?.lastName ?? ''}"
                                    : "NA",
                                date: Helper.formatDate(
                                    appl.callDate?.toString() ?? ''),
                                description: "${appl.remark}\n${appl.feedback}",
                                color: Colors.red.withOpacity(0.8),
                                isFirst: i == 0,
                                isLast: i == widget.lead.callHistory.length - 1,
                              ),
                            );
                          },
                        ),
                      ] else ...[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: Text(
                            'Follow-up History',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                'No Follow-up Yet',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(
                        height: 12,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                if (showNotification)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: _buildNotificationSection(),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (isLoading) const LoadingSquare(),
      ],
    );
  }

  Widget _buildClientOverview() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.indigo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              widget.lead.firstName?.substring(0, 1).toUpperCase() ?? "",
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "${widget.lead.firstName} ${widget.lead.lastName}",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.phone,
            "${widget.lead.countryCode} ${widget.lead.phoneNumber}",
            Colors.white,
          ),
          _buildInfoRow(
            Icons.email,
            "${(widget.lead.email != null && widget.lead.email!.isNotEmpty) ? widget.lead.email : "NA"}",
            Colors.white,
          ),
          // _buildInfoRow(
          //   Icons.info_outline,
          //   getStatus(widget.lead),
          //   Colors.white,
          // ),
          const SizedBox(height: 8),
          MyTextCard(
            heading: "Requirement: ",
            headingColor: Colors.white,
            valueColor: Colors.white,
            value: widget.lead.requirement.join(", "),
          ),
          const SizedBox(height: 8),
          MyTextCard(
            heading: "Project: ",
            value: widget.lead.project.map((pr) => pr.name).join(", "),
            headingColor: Colors.white,
            valueColor: Colors.white,
          ),

          const SizedBox(height: 8),

          MyTextCard(
            heading: "Status: ",
            value: getStatus(widget.lead),
            headingColor: Colors.white,
            valueColor: Colors.white,
          ),
          const SizedBox(height: 8),
          MyTextCard(
            heading: widget.lead.cycle != null
                ? "${Helper.capitalize(widget.lead.cycle?.stage ?? "")} Deadline: "
                : "Visit Deadline: ",
            value: Helper.formatDateOnly(
              widget.lead.cycle?.validTill?.toIso8601String() ?? '',
            ),
            valueColor: const Color.fromARGB(255, 255, 134, 126),
            headingColor: Colors.white,
          ),
          // if (widget.lead.visitRef != null)
          //   MyTextCard(
          //     heading: widget.lead.cycle != null
          //         ? "${Helper.capitalize(widget.lead.cycle?.stage ?? "")} Date: "
          //         : "Visit Date: ",
          //     value: Helper.formatDateOnly(
          //       widget.lead.visitRef?.date?.toString() ?? "NA",
          //     ),
          //     valueColor: Colors.white,
          //     headingColor: Colors.white,
          //   ),

          const SizedBox(height: 8),
          MyTextCard(
            heading: "Address: ",
            headingColor: Colors.white,
            valueColor: Colors.white,
            value: widget.lead.address ?? "",
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _onPressedSendNotification(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Text(
                        'Send Notification',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Send Notification',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Enter Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notificationController,
                maxLines: 3,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Type your message here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Attach Files'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('${_selectedImages.length} file(s) selected'),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _templateController,
                decoration: InputDecoration(
                  hintText: 'Enter Template',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      String imageUrl = '';
                      if (_selectedImages.isNotEmpty) {
                        final imageResp = await ApiService().uploadFile(
                          File(_selectedImages[0].path),
                        );
                        if (imageResp != null) {
                          imageUrl = imageResp.downloadUrl;
                        }
                      }

                      Map<String, dynamic> data = {
                        "title": _titleController.text,
                        "message": _notificationController.text,
                        "image": imageUrl,
                        "leadRef": widget.lead.id,
                        "templateName": _templateController.text,
                      };
                      await ApiService().sendCustomNotification(data);
                      Navigator.of(context).pop();
                    }, // Add your notification submit logic here
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[600],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Submit Notification',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.remove_red_eye),
                    color: Colors.indigo[600],
                    onPressed: () {
                      setState(() {
                        _isPreviewVisible =
                            !_isPreviewVisible; // Toggle preview visibility
                      });
                    },
                  ),
                ],
              ),
              if (_isPreviewVisible) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey.withOpacity(
                            0.2,
                          ),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                          )
                        ]),
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.indigo[600],
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'EV Home ° now',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_drop_down),
                              onPressed: () {
                                // Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: Text(
                            _titleController.text,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: Text(
                            _notificationController.text,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_selectedImages.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _selectedImages.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.6),
                                              offset: const Offset(3, 3),
                                              blurRadius: 8,
                                              spreadRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Image.file(
                                          File(_selectedImages[index].path),
                                          width: 250,
                                          height: 400,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        // Show preview section if _isPreviewVisible is true
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentSection() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigitalDateTimePicker(
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _selectedDateTime = newDateTime;
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed:
                _showConfirmationDialog, // Call the dialog on button press
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo, // Button background color
              foregroundColor: Colors.white, // Text color
              padding: const EdgeInsets.symmetric(
                  horizontal: 32, vertical: 13), // Padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              elevation: 5, // Shadow effect
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold, // Optional: Makes the text bold
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
          // const SizedBox(height: 16),
          // if (_selectedDateTime != null)
          //   Text(
          //     'Selected: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!)}',
          //     style:
          //         const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //   ),
          // const SizedBox(height: 16),
          // Center(
          //   child: ElevatedButton(
          //     onPressed: _submitAppointment,
          //     child: const Text(
          //       'Submit Appointment',
          //       style: TextStyle(
          //         color: Colors.white,
          //       ),
          //     ),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.indigo,
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          //     ),
          //   ),
          // ),
        ],
      ),
      // ],
    );
  }

  void _showConfirmationDialog() {
    // bool _is24HourFormat = true;
    // bool isLoading = true;
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    final projects = settingProvider.ourProject;
    final divisions = settingProvider.divisions;
    // print(divisions);

    // print(projects);
    // if (_selectedDateTime == null) {
    //   Helper.showCustomSnackBar("Please select date");
    //   return;
    // }

    String formattedDateTime =
        DateFormat('dd-MM-yyyy HH:mm').format(_selectedDateTime!);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: TextEditingController(
                      text:
                          formattedDateTime), // Display the formatted date and time
                  readOnly: true, // Make it read-only
                  decoration: const InputDecoration(
                    labelText: 'Selected Date and Time',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  value: selectedPurpose,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPurpose = newValue;
                    });
                  },
                  items: purposes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Purpose',
                    border: OutlineInputBorder(),
                    // prefixIcon: Icon(Icons.note),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a purpose';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // DropdownButtonFormField<Division>(
                //   value:
                //       divisions.contains(selectedPlace) ? selectedPlace : null,
                //   decoration: InputDecoration(
                //     labelText: 'Select Division',
                //     border(
                //       borderRadius: BorderRadius.circular(5),
                //     ),
                //   ),
                //   items: divisions.map((ele) {
                //     return DropdownMenuItem<Division>(
                //       value: ele,
                //       child: Row(
                //         children: [
                //           Expanded(
                //             child: Text(
                //               ele.division ?? "",
                //               overflow: TextOverflow.ellipsis,
                //               maxLines: 1,
                //             ),
                //           ),
                //           const SizedBox(width: 4),
                //         ],
                //       ),
                //     );
                //   }).toList(),
                //   onChanged: (newValue) {
                //     setState(() {
                //       selectedPlace = newValue;
                //     });
                //   },
                //   validator: (value) {
                //     if (value == null) {
                //       return 'Please select a Project';
                //     }
                //     return null;
                //   },
                //   isExpanded: true,
                // ),
                DropdownButtonFormField<OurProject>(
                  value: projects.contains(_selectedProject)
                      ? _selectedProject
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Select Project',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  items: projects.map((project) {
                    return DropdownMenuItem<OurProject>(
                      value: project,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              project.name ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedProject = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a Project';
                    }
                    return null;
                  },
                  isExpanded: true,
                ),
                // TextField(
                //   controller: _projectController,
                //   decoration: const InputDecoration(
                //     labelText: 'Project',
                //     border: OutlineInputBorder(),
                //   ),
                // ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _handleSubmit();

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppointmentHistory() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 0,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.calendar_today),
                    ),
                    title: Text(
                      DateFormat('yyyy-MM-dd').format(
                          DateTime.now().subtract(Duration(days: index))),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'This is the description or summary text for the appointment.',
                    ),
                  ),
                );
              },
            ),
            const Text("No Appointment yet")
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
