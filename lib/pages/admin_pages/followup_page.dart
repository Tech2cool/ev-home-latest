import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class FollowupPage extends StatefulWidget {
  final Lead lead;

  const FollowupPage({Key? key, required this.lead}) : super(key: key);

  @override
  _FollowupPageState createState() => _FollowupPageState();
}

class _FollowupPageState extends State<FollowupPage> {
  String? selectedLeadStage;
  String? selectedLeadStatus;
  String feedback = '';

  final List<String> leadStages = ['Contacted', 'Followup'];
  final List<String> leadstatuscontact = [
    'Call Done',
    'Call Not Received',
    'Call Cancelled',
    'Call Busy',
    'Unavailable',
  ];
  final List<String> leadstatusfollowup = [
    'Call Done',
    'Call Not Received',
    'Call Cancelled',
    'Call Busy',
    'Unavailable',
  ];

  List<File> selectedImages = [];
  List<File> selectedRecordings = [];
  final ImagePicker picker = ImagePicker();

  Future<void> pickImages() async {
    final List<XFile> images = await picker.pickMultiImage();
    setState(() {
      selectedImages.addAll(images.map((image) => File(image.path)).toList());
    });
  }

  Future<void> pickRecordings() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'awp'], // Specify the allowed formats
    );

    if (result != null) {
      setState(() {
        selectedRecordings.add(File(result.files.single.path!));
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  void removeRecording(int index) {
    setState(() {
      selectedRecordings.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Follow-Up Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), // Rounded corners
            border: Border.all(color: Colors.indigo, width: 1),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Lead Stage',
                  labelStyle:
                      const TextStyle(color: Colors.indigo), // Label text color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                        color: Colors.indigo,
                        width: 2), // Focused border color and width
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1), // Enabled border color and width
                  ),
                ),
                value: selectedLeadStage,
                items: leadStages.map((String stage) {
                  return DropdownMenuItem<String>(
                    value: stage,
                    child: Text(stage),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLeadStage = newValue!;
                    selectedLeadStatus = null;
                  });
                },
              ),
              const SizedBox(height: 22),
              if (selectedLeadStage == 'Contacted')
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Lead Status',
                    labelStyle: const TextStyle(
                        color: Colors.indigo), // Label text color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                          color: Colors.indigo,
                          width: 2), // Focused border color and width
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1), // Enabled border color and width
                    ),
                  ),
                  value: selectedLeadStatus,
                  items: leadstatuscontact.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLeadStatus = newValue!;
                    });
                  },
                ),
              if (selectedLeadStage == 'Followup')
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Lead Status',
                    labelStyle: const TextStyle(
                        color: Colors.indigo), // Label text color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                          color: Colors.indigo,
                          width: 2), // Focused border color and width
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1), // Enabled border color and width
                    ),
                  ),
                  value: selectedLeadStatus,
                  items: leadstatusfollowup.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLeadStatus = newValue!;
                    });
                  },
                ),
              const SizedBox(height: 16),
              TextField(
                maxLength: 150,
                decoration: InputDecoration(
                  labelText: 'Feedback',
                  labelStyle:
                      const TextStyle(color: Colors.indigo), // Label text color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                        color: Colors.indigo,
                        width: 2), // Focused border color and width
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1), // Enabled border color and width
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 30.0,
                    horizontal: 12.0,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    feedback = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Images Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attachment - Photos',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Photos',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: pickImages,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: selectedImages.length,
                itemBuilder: (context, index) {
                  File image = selectedImages[index];
                  String fileName = path.basename(image.path);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            fileName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors
                                  .indigo, // Indigo color for the file name
                              fontWeight:
                                  FontWeight.w600, // Optional: Bold text
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => removeImage(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Recordings Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attachment - Recordings',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Recording',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: pickRecordings,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: selectedRecordings.length,
                itemBuilder: (context, index) {
                  File recording = selectedRecordings[index];
                  String fileName = path.basename(recording.path);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.audiotrack, size: 30),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            fileName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors
                                  .indigo, // Indigo color for the file name
                              fontWeight:
                                  FontWeight.w600, // Optional: Bold text
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => removeRecording(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final loggedAdmin = Provider.of<SettingProvider>(
                      context,
                      listen: false,
                    ).loggedAdmin;
                    final data = {
                      'leadStage': selectedLeadStage,
                      'leadStatus': selectedLeadStatus,
                      'remark': selectedLeadStatus,
                      'feedback': feedback,
                      'document': "",
                      'recording': ""
                    };

                    if (loggedAdmin != null && loggedAdmin.id != null) {
                      await Provider.of<SettingProvider>(
                        context,
                        listen: false,
                      ).updateCallHistoryPreSales(
                        widget.lead.id,
                        data,
                      );

                      Navigator.of(context).pop();
                    } else {
                      Helper.showCustomSnackBar(
                        "Error: Logged admin or admin ID is null",
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo, // Button background color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(24), // Rounded edges (optional)
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0), // Padding inside button
                  ),
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
