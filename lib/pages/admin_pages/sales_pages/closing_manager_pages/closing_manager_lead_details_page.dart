import 'dart:io';
import 'package:ev_homes/components/digital_clock.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
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
  final TextEditingController _notificationController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _templateController = TextEditingController();

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
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: _buildNotificationSection(),
          ),
        );
      },
    );
    // setState(() {
    //   if (showNotification == true) {
    //     showNotification = false;
    //   } else {
    //     showNotification = true;
    //   }
    // });
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

  void _showNotificationPreview() {
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notification Preview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  const Text(
                    'Title:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    _titleController.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  // Message
                  const Text(
                    'Message:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    _notificationController.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  // Attached Files
                  if (_selectedImages.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Attached Files:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _selectedImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Image.file(
                                  File(_selectedImages[index].path),
                                  width: 200,
                                  height: 400,
                                  fit: BoxFit.fill,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Template
                  const Text(
                    'Template:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    _templateController.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // Close Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[600],
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 15, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Center(
                      child: const Text(
                        'Close Preview',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAssignTaskDialog(BuildContext context) {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    final loggedUser = settingProvider.loggedAdmin?.id;
    String? selectedSubject;
    Employee? selectedAssignee; // Variable for dropdown selection
    final subjectController = TextEditingController();
    final taskNameController = TextEditingController();
    final taskDetailsController = TextEditingController();

    if (loggedUser != null) {
      final reportingEmployees = settingProvider.employees
          .where((employee) => employee.reportingTo?.id == loggedUser)
          .toList();

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
                      items: ["First Call", "Follow-Up", "Schedule Meeting"]
                          .map((subject) => DropdownMenuItem(
                                value: subject,
                                child: Text(subject),
                              ))
                          .toList(),
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
                      value: selectedAssignee,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: settingProvider.employees
                          .where((employee) =>
                              employee.reportingTo?.id == loggedUser)
                          .map((employee) => DropdownMenuItem<Employee>(
                                value: employee,
                                child: Text(
                                    '${employee.firstName} ${employee.lastName}'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        selectedAssignee = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 151, 245, 154),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Client Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Back arrow color
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
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                      width: 140, // Half the width for two cards in a row
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
                      width: 140, // Half the width for two cards in a row
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
                      width:
                          double.infinity, // Full width for the rectangle card
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        child: InkWell(
                          onTap: () => _showAssignTaskDialog(context),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(
              height: 12,
            ),
            if (widget.lead.callHistory.isNotEmpty) ...[
              const Text(
                'Follow-up History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(
                widget.lead.callHistory.length,
                (i) {
                  final appl = widget.lead.callHistory[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.calendar_today),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appl.caller != null
                                ? "${appl.caller?.firstName ?? ''} ${appl.caller?.lastName ?? ''}"
                                : "NA",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            Helper.formatDate(appl.callDate?.toString() ?? ''),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        appl.remark ?? "NA",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: const Text(
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: const Text(
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
            SizedBox(
              height: 12,
            ),
            if (widget.lead.callHistory.isNotEmpty) ...[
              const Text(
                'Contact History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(
                widget.lead.callHistory.length,
                (i) {
                  final appl = widget.lead.callHistory[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.calendar_today),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appl.caller != null
                                ? "${appl.caller?.firstName ?? ''} ${appl.caller?.lastName ?? ''}"
                                : "NA",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            Helper.formatDate(appl.callDate?.toString() ?? ''),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        appl.remark ?? "NA",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: const Text(
                  'Contact History',
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: const Text(
                      'No Contact History Yet',
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
            const SizedBox(height: 24),
          ],
        ),
      ),
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
              widget.lead.cycle?.validTill.toString() ?? '',
            ),
            valueColor: Colors.red,
            headingColor: Colors.white,
          ),
          if (widget.lead.visitRef != null)
            MyTextCard(
              heading: widget.lead.cycle != null
                  ? "${Helper.capitalize(widget.lead.cycle?.stage ?? "")} Date: "
                  : "Visit Date: ",
              value: Helper.formatDateOnly(
                widget.lead.visitRef?.date?.toString() ?? "NA",
              ),
              valueColor: Colors.white,
              headingColor: Colors.white,
            ),
          if (widget.lead.visitRef != null)
            MyTextCard(
              heading: widget.lead.cycle != null
                  ? "${Helper.capitalize(widget.lead.cycle?.stage ?? "")} Date: "
                  : "Visit Date: ",
              value: Helper.formatDateOnly(
                widget.lead.visitRef?.date?.toString() ?? "NA",
              ),
              valueColor: Colors.white,
              headingColor: Colors.white,
            ),

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
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Send Notification',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
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
          // if (_selectedImages.isNotEmpty)
          //   SizedBox(
          //     height: 100,
          //     child: ListView.builder(
          //       scrollDirection: Axis.horizontal,
          //       itemCount: _selectedImages.length,
          //       itemBuilder: (context, index) {
          //         return Padding(
          //           padding: const EdgeInsets.only(right: 8),
          //           child: Image.file(
          //             File(_selectedImages[index].path),
          //             width: 100,
          //             height: 100,
          //             fit: BoxFit.cover,
          //           ),
          //         );
          //       },
          //     ),
          //   ),
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
                onPressed: () {}, // Add your notification submit logic here
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[600],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
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
                onPressed: _showNotificationPreview,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentSection() {
    return SingleChildScrollView(
      child:
          // crossAxisAlignment: CrossAxisAlignment.start,
          // children: [
          // const Text(
          //   'Schedule Appointment',
          //   style: TextStyle(
          //     fontSize: 20,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigitalDateTimePicker(
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _selectedDateTime = newDateTime;
              });
              print('Selected date time: $newDateTime');
            },
          ),
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
