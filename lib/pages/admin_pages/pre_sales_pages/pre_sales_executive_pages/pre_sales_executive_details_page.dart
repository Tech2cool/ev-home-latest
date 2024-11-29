import 'dart:io';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class PreSalesExecutiveDetailsPage extends StatefulWidget {
  final Lead lead;
  const PreSalesExecutiveDetailsPage({
    super.key,
    required this.lead,
  });

  @override
  State<PreSalesExecutiveDetailsPage> createState() =>
      _PreSalesExecutiveDetailsPageState();
}

class _PreSalesExecutiveDetailsPageState
    extends State<PreSalesExecutiveDetailsPage> {
  List<Lead> similarLeads = [];
  bool checkingSimilarLead = false;

  @override
  void initState() {
    super.initState();
    getSimilarLead();
  }

  Future<void> getSimilarLead() async {
    setState(() {
      checkingSimilarLead = true;
    });
    try {
      final resp = await ApiService().getSimilarLeads(widget.lead.id);
      setState(() {
        similarLeads = resp;
      });
    } catch (e) {
      setState(() {
        checkingSimilarLead = false;
      });
    }
    setState(() {
      checkingSimilarLead = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyTextCard(
                          heading: "Client Name: ",
                          value: widget.lead.firstName ?? "",
                        ),
                        const SizedBox(height: 8),
                        MyTextCard(
                            heading: "Phone: ",
                            value:
                                " ${widget.lead.countryCode} ${widget.lead.phoneNumber}"),
                        const SizedBox(height: 8),
                        MyTextCard(
                            heading: "Alternate Number: ",
                            value: widget.lead.altPhoneNumber != null
                                ? "${widget.lead.countryCode} ${widget.lead.altPhoneNumber}"
                                : "NA"),
                        const SizedBox(height: 8),
                        MyTextCard(
                          heading: "Email: ",
                          value: widget.lead.email ?? "NA",
                        ),
                        const SizedBox(height: 8),
                        MyTextCard(
                          heading: "Requirement: ",
                          value: widget.lead.requirement.isNotEmpty
                              ? widget.lead.requirement.join()
                              : "NA",
                        ),
                        const SizedBox(height: 8),
                        MyTextCard(
                            heading: "Remark: ",
                            value: widget.lead.remark ?? "NA"),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'CP Details',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyTextCard(
                            heading: "Name: ",
                            value:
                                "${widget.lead.channelPartner?.firstName ?? ''} ${widget.lead.channelPartner?.lastName ?? ''}"),
                        const SizedBox(height: 8),
                        MyTextCard(
                            heading: "Firm Name: ",
                            value:
                                widget.lead.channelPartner?.firmName ?? "NA"),
                        const SizedBox(height: 8),
                        MyTextCard(
                          heading: "Rera Registration: ",
                          value: widget.lead.channelPartner
                                      ?.haveReraRegistration ==
                                  true
                              ? "Yes"
                              : "NO",
                        ),
                        const SizedBox(height: 8),
                        MyTextCard(
                            heading: "Rera Id: ",
                            value:
                                widget.lead.channelPartner?.reraNumber ?? "NA"),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Additional Information',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 250,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (checkingSimilarLead)
                          const Text(
                            "Checking Similar Leads....",
                          )
                        else ...[
                          if (similarLeads.isNotEmpty) ...[
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'CP Firm',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Status',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  ...List.generate(
                                    similarLeads.length,
                                    (i) {
                                      final sLead = similarLeads[i];
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildDummyLeadRow(
                                            Helper.formatDate(
                                              sLead.startDate.toString(),
                                            ),
                                            sLead.channelPartner?.firmName ??
                                                "NA",
                                            sLead.status ?? "",
                                          ),
                                          const Divider(),
                                        ],
                                      );
                                    },
                                  )
                                ],
                              ),
                            )
                          ] else
                            const Text(
                              "No Similar Leads",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    const SizedBox(width: 16), // Space between buttons
                    // Expanded for Button 2
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _showEditBottomSheet(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amberAccent,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDummyLeadRow(String date, String firmNo, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(date),
        Text(firmNo),
        Text(
          status,
          style: TextStyle(color: _getStatusColor(status)),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Contacted':
        return Colors.green;
      case 'Pending':
        return Colors.red;
      case 'Followup':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showEditBottomSheet(BuildContext context) {
    String? selectedLeadStage;
    String? selectedLeadStatus;
    String feedback = '';
    String? sitevisitstatus;

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
    final List<String> sitevisit = ['Done', 'Not Done'];

    List<File> selectedImages = [];
    List<File> selectedRecordings = [];
    final ImagePicker picker = ImagePicker();

    Future<void> pickImages(StateSetter setState) async {
      final List<XFile> images = await picker.pickMultiImage();
      setState(() {
        selectedImages.addAll(images.map((image) => File(image.path)).toList());
      });
    }

    Future<void> pickRecordings(StateSetter setState) async {
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

    // Function to remove an image from the list
    void removeImage(StateSetter updateState, int index) {
      updateState(() {
        selectedImages.removeAt(index);
      });
    }

    void removeRecording(StateSetter updateState, int index) {
      updateState(() {
        selectedRecordings.removeAt(index);
      });
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 22),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Lead Stage',
                        border: OutlineInputBorder(),
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
                        decoration: const InputDecoration(
                          labelText: 'Lead Status',
                          border: OutlineInputBorder(),
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
                        decoration: const InputDecoration(
                          labelText: 'Lead Status',
                          border: OutlineInputBorder(),
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
                      decoration: const InputDecoration(
                          labelText: 'Feedback',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 12.0)),
                      onChanged: (value) {
                        setState(() {
                          feedback = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Site Visit Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Site Visit',
                        border: OutlineInputBorder(),
                      ),
                      value: sitevisitstatus,
                      items: sitevisit.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          sitevisitstatus = newValue!;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Attachment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Photos',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => pickImages(setState),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Displaying selected image names with remove option
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
                              // Display the image as a small thumbnail
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
                              // Display the file name
                              Expanded(
                                child: Text(
                                  fileName,
                                  overflow: TextOverflow
                                      .ellipsis, // Ellipsis if the file name is too long
                                  maxLines: 1,
                                ),
                              ),
                              // Remove button
                              IconButton(
                                icon:
                                    const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => removeImage(setState, index),
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
                          'Recordings',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Select Recording',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => pickRecordings(setState),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Displaying selected recording names with remove option
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
                              // Display an audio icon for the recording
                              const Icon(Icons.audiotrack, size: 30),
                              const SizedBox(width: 12),
                              // Display the file name
                              Expanded(
                                child: Text(
                                  fileName,
                                  overflow: TextOverflow
                                      .ellipsis, // Ellipsis for long names
                                  maxLines: 1,
                                ),
                              ),
                              // Remove button
                              IconButton(
                                icon:
                                    const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () =>
                                    removeRecording(setState, index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () async {
                        final loggedAdmin = Provider.of<SettingProvider>(
                          context,
                          listen: false,
                        ).loggedAdmin;
                        final data = {
                          'leadStage': selectedLeadStage,
                          'leadStatus': selectedLeadStatus,
                          'feedback': feedback,
                          'siteVisit': sitevisitstatus,
                          'document': "",
                          'recording': ""
                        };

                        // Check if loggedAdmin has an id and use it
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
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class MyTextCard extends StatelessWidget {
  final String heading;
  final String value;
  const MyTextCard({super.key, required this.heading, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          heading,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
