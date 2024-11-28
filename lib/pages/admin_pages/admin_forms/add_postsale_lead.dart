import 'dart:io';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/models/post_sale_lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class AddPostsaleLead extends StatefulWidget {
  const AddPostsaleLead({super.key});

  @override
  State<AddPostsaleLead> createState() => _AddPostsaleLeadState();
}

class _AddPostsaleLeadState extends State<AddPostsaleLead> {
  // Form field controllers
  final TextEditingController unitNoController = TextEditingController();
  final List<String> applicantCounts = ["1", "2", "3", "4", "5"];
  int selectedApplicantCount = 1;
  List<TextEditingController> applicantControllers = [];
  List<TextEditingController> firstNameController = [TextEditingController()];
  List<TextEditingController> lastNameController = [TextEditingController()];
  List<TextEditingController> contactNumberController = [
    TextEditingController()
  ];
  List<TextEditingController> addressController = [TextEditingController()];
  List<TextEditingController> emailController = [TextEditingController()];
  final TextEditingController carpetAreaController = TextEditingController();
  final TextEditingController flatCostController = TextEditingController();
  final TextEditingController parking1Controller = TextEditingController();
  final TextEditingController parking2Controller = TextEditingController();
  final TextEditingController parking3Controller = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController myController = TextEditingController();
  TextEditingController combinedController = TextEditingController();
  bool isUpdating = false;
  bool isLoading = false;

  List<List<File>> aadharFiles = [];
  List<List<File>> panFiles = [];
  List<List<File>> otherFiles = [];
  List<PlatformFile> uploadedFiles = [];
  int? whichFloor;
  int? whichParkingFloor;
  Flat? selectedFlat;

  Parking? selectedParking;
  String? selectedRequirements;

  String carParking = "Parking 1";
  int parkingCount = 1;
  String? selectedManager;
  bool isMeetingAttendanceVisible = false;

  final String allInclusive = '270,000';
  double builderAmount = 0.0;
  double taxAmount = 0.0;
  bool isBookingDetailsVisible = false;
  bool isConfirmBookingVisible = false;

  String? selectedBookingType;
  final TextEditingController amountController = TextEditingController();
  String? selectedBookingAccount; // Track selected booking account

  List<String> teamMembers = ["Rohan", "Priya", "Nadeem", "Ram", "Payal"];
  List<String> bookingStatus = ["EOI", "Confirm Booking"];
  List<String> selectedTeamMembers = [];

  // Checklist item values
  String tenPercentReceived = "";
  String tenPercentComment = "";

  String nocReceive = "";
  String kycReceive = "";
  String agreementPrepared = "";
  String legalchargesReceive = "";

  String stampDuty = "";
  String stampDutyComment = "";

  String gstReceive = "";
  String gstComment = "";

  String tdsReceive = "";
  String tdsReceiveComment = "";

  String agreementHandover = "";
  Employee? _selectedClosingManger;
  Employee? _selectedPostSalesExecutive;
  OurProject? _selectedProject;
  double preregistrationPercents = 0.0;
  DateTime selectedDate = DateTime.now();

  List<double> applicantsPercents = [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ];
  double calculateProgressFix(int index) {
    int filledFields = 0;
    // int totalFields = selectedApplicantCount * 5;
    if (firstNameController[index].text.isNotEmpty) filledFields++;
    if (lastNameController[index].text.isNotEmpty) filledFields++;
    if (contactNumberController[index].text.isNotEmpty) filledFields++;
    if (addressController[index].text.isNotEmpty) filledFields++;
    if (emailController[index].text.isNotEmpty) filledFields++;
    if (aadharFiles[index].isNotEmpty) filledFields++;
    if (panFiles[index].isNotEmpty) filledFields++;
    if (otherFiles[index].isNotEmpty) filledFields++;

    final double total = (filledFields * 12.5) * 0.01;
    // setState(() {
    applicantsPercents[index] = total;
    // });
    return total;
  }

  double calculateProgressPreregistration() {
    int filledFields = 0;
    // int totalFields = selectedApplicantCount * 5;
    if (tenPercentReceived.isNotEmpty) filledFields++;
    if (stampDuty.isNotEmpty) filledFields++;
    if (tdsReceive.isNotEmpty) filledFields++;
    if (gstReceive.isNotEmpty) filledFields++;
    if (nocReceive.isNotEmpty) filledFields++;
    if (kycReceive.isNotEmpty) filledFields++;
    if (agreementPrepared.isNotEmpty) filledFields++;
    if (legalchargesReceive.isNotEmpty) filledFields++;
    if (agreementHandover.isNotEmpty) filledFields++;

    final double total = (filledFields * 11.11111111111111) * 0.01;
    // setState(() {
    preregistrationPercents = total;
    // });
    return total;
  }

  double calculateProgress() {
    int filledFields = 0;
    int totalFields = selectedApplicantCount * 5;

    for (int i = 0; i < selectedApplicantCount; i++) {
      if (firstNameController[i].text.isNotEmpty) filledFields++;
      if (lastNameController[i].text.isNotEmpty) filledFields++;
      if (contactNumberController[i].text.isNotEmpty) filledFields++;
      if (addressController[i].text.isNotEmpty) filledFields++;
      if (emailController[i].text.isNotEmpty) filledFields++;
    }

    return filledFields / totalFields;
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
        // settingProvider.getTeamLeaders(),
        settingProvider.getOurProject(),
        settingProvider.getPostSalesEx(),
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

  // void updateCombinedText() {
  //   String floorText =
  //       whichFloor != null ? whichFloor.toString().padLeft(2, '0') : '';
  //   String flatText = selectedFlat?.number.toString().padLeft(2, '0') ??
  //       ''; // Use null-aware opera
  //   combinedController.text =
  //       '$flatText - $floorText'; // Combine flat and floor
  // }

  @override
  void initState() {
    super.initState();
    _onRefresh();
    updateApplicantFieldsKyc(1);
    // combinedController.text = '';
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    parking1Controller.dispose();
    parking2Controller.dispose();
    parking3Controller.dispose();
    dateTimeController.dispose();
    super.dispose();
  }

  void updateApplicantFieldsKyc(int count) {
    setState(() {
      while (aadharFiles.length < count) {
        aadharFiles.add([]);
        panFiles.add([]);
        otherFiles.add([]);
      }
      while (aadharFiles.length > count) {
        aadharFiles.removeLast();
        panFiles.removeLast();
        otherFiles.removeLast();
      }
    });
  }

  String getNumberWithSuffix(int number) {
    if (number % 10 == 1 && number % 100 != 11) {
      return '${number}st';
    } else if (number % 10 == 2 && number % 100 != 12) {
      return '${number}nd';
    } else if (number % 10 == 3 && number % 100 != 13) {
      return '${number}rd';
    } else {
      return '${number}th';
    }
  }

  void updateApplicantFields(int count) {
    setState(() {
      selectedApplicantCount = count;
      updateApplicantFieldsKyc(count);
      if (count > applicantsPercents.length) {
        // Add zeros to the list until it reaches the new count
        for (int i = applicantsPercents.length; i < count; i++) {
          applicantsPercents.add(0.0);
        }
      } else if (count < applicantsPercents.length) {
        // Remove excess entries if the new count is less
        applicantsPercents.removeRange(count, applicantsPercents.length);
      }

      if (count > firstNameController.length) {
        for (int i = firstNameController.length; i < count; i++) {
          firstNameController.add(TextEditingController());
          lastNameController.add(TextEditingController());
          contactNumberController.add(TextEditingController());
          addressController.add(TextEditingController());
          emailController.add(TextEditingController());
        }
      } else if (count < firstNameController.length) {
        // Only remove ranges if the list is not empty
        if (firstNameController.isNotEmpty) {
          firstNameController.removeRange(count, firstNameController.length);
        }
        if (lastNameController.isNotEmpty) {
          lastNameController.removeRange(count, lastNameController.length);
        }
        if (contactNumberController.isNotEmpty) {
          contactNumberController.removeRange(
              count, contactNumberController.length);
        }
        if (addressController.isNotEmpty) {
          addressController.removeRange(count, addressController.length);
        }
        if (emailController.isNotEmpty) {
          emailController.removeRange(count, emailController.length);
        }
        // Ensure you are not accessing an invalid index when removing from applicantsPercents
        if (applicantsPercents.length > count) {
          applicantsPercents.removeRange(count, applicantsPercents.length);
        }
      }
    });
  }

  void onSubmit() async {
    try {
      final settingProvider = context.read<SettingProvider>();
      var i = 0;
      final List<Applicant> apps = [];
      setState(() {
        isLoading = true;
      });

      for (var _ in firstNameController) {
        String uploadedAdhar = '';
        String uploadedPan = '';
        String uploadedOther = '';
        try {
          if (aadharFiles[i].isNotEmpty) {
            final uploadeAdharResp = await ApiService().uploadFile(
              aadharFiles[i][0],
            );

            uploadedAdhar = uploadeAdharResp?.downloadUrl ?? '';
          }
          if (panFiles[i].isNotEmpty) {
            final uploadedPanResp = await ApiService().uploadFile(
              panFiles[i][0],
            );
            uploadedPan = uploadedPanResp?.downloadUrl ?? '';
          }
          if (otherFiles[i].isNotEmpty) {
            final uploadedOtherResp = await ApiService().uploadFile(
              otherFiles[i][0],
            );
            uploadedOther = uploadedOtherResp?.downloadUrl ?? '';
          }
        } catch (e) {
          // print(e);
          Helper.showCustomSnackBar("Error uploading Documents");
        }
        // final aadharFile = uploadedAdhar;
        // final panFile = uploadedPan;
        // final otherFile = uploadedOther;

        apps.add(
          Applicant(
            firstName: firstNameController[i].text,
            lastName: lastNameController[i].text,
            email: emailController[i].text,
            address: addressController[i].text,
            phoneNumber:
                int.tryParse(contactNumberController[i].text.trim()) ?? 0,
            kyc: Kyc(
              addhar: KycDocument(document: uploadedAdhar, type: 'aadhar'),
              pan: KycDocument(document: uploadedPan, type: 'pan'),
              other: KycDocument(document: uploadedOther, type: 'other'),
            ),
          ),
        );
        i++;
      }

      // Ensure selectedProject is not null
      if (_selectedProject == null) {
        Helper.showCustomSnackBar("Please select a project");
        return;
      }

      final newPostLead = PostSaleLead(
        id: "",
        unitNo: selectedFlat!.flatNo!,
        floor: whichFloor,
        number: selectedFlat!.number,
        flatCost: int.parse(flatCostController.text),
        carpetArea: int.tryParse(carpetAreaController.text),
        project: _selectedProject,
        date: dateTimeController.text,
        firstName: firstNameController[0].text.trim(),
        lastName: lastNameController[0].text.trim(),
        phoneNumber: int.tryParse(contactNumberController[0].text.trim()) ?? 0,
        address: addressController[0].text.trim(),
        email: emailController[0].text.trim(),
        applicants: apps,
        closingManager: _selectedClosingManger,
        postSaleExecutive: _selectedPostSalesExecutive,
        bookingStatus: BookingStatus(
          type: selectedBookingType,
        ),
        preRegistrationCheckList: PreRegistrationChecklist(
          tenPercentRecieved: ChecklistItem(
            remark: tenPercentComment,
            recieved: tenPercentReceived,
          ),
          stampDuty: ChecklistItem(
            remark: stampDutyComment,
            recieved: stampDuty,
          ),
          gst: ChecklistItem(
            remark: gstComment,
            recieved: gstReceive,
          ),
          noc: ChecklistItem(recieved: nocReceive),
          tds: ChecklistItem(
            remark: tdsReceiveComment,
            recieved: tdsReceive,
          ),
          legalCharges: ChecklistItem(recieved: legalchargesReceive),
          kyc: ChecklistItem(recieved: kycReceive),
          agreement: Agreement(
            handOver: HandOver(status: agreementHandover),
            document: Document(),
            prepared: agreementPrepared.toLowerCase() == 'yes' ? true : false,
          ),
        ),
      );

      Map<String, dynamic> jsonLead = newPostLead.toJson();
      if (newPostLead.closingManager != null) {
        jsonLead['closingManager'] = newPostLead.closingManager!.id;
      }

      if (newPostLead.project != null) {
        jsonLead['project'] = newPostLead.project!.id;
      }

      if (newPostLead.postSaleExecutive != null) {
        jsonLead['postSaleExecutive'] = newPostLead.postSaleExecutive!.id;
      }

      await settingProvider.addPostSaleLead(jsonLead);

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      // Helper.showCustomSnackBar("Unknown Error adding Booking $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final closingMangers = settingProvider.closingManagers;
    // final teamLeaders = settingProvider.teamLeaders;
    final postSalesEx = settingProvider.postSalesExecutives;
    // final requirements = settingProvider.requirements;
    final projects = settingProvider.ourProject;
    final floors = _selectedProject?.flatList
            .map((flat) => flat.floor) // Get all floors
            .whereType<int>() // Ensure non-null and int type
            .toSet() // Remove duplicates
            // Pad single-digit floors
            .toList() ??
        []
      ..sort();

    final flats = (_selectedProject?.flatList ?? [])
        .where((flat) => flat.floor == whichFloor)
        .toList()
      ..sort((a, b) => a.floor!.compareTo(b.floor!));

// Add leading zero to parking floors
    final parkingFloors = _selectedProject?.parkingList
            .map((flat) => flat.floor) // Get all parking floors
            .whereType<int>() // Ensure non-null and int type
            .toSet() // Remove duplicates
            // Pad single-digit floors
            .toList() ??
        []
      ..sort();

    final parkingNumbers = (_selectedProject?.parkingList ?? [])
        .where((park) => park.floor == whichParkingFloor)
        .toList();
    // ..sort((a, b) => a.parkingNo?.compareTo(b.parkingNo!));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Total Bookings Add Form"),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDateTimeField(
                    label: "Select Date and Time",
                    controller: dateTimeController,
                    selectedDate: selectedDate,
                    onUpdate: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
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

                  // CustomDropdownField(
                  //   label: "Select Project",
                  //   items: projectFloors.keys.toList(),
                  //   initialValue: selectedProject,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedProject = value;
                  //       selectedFloor =
                  //           null; // Reset the floor selection when the project changes
                  //     });
                  //   },
                  // ),

                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_selectedProject != null) ...[
                        // Floor Dropdown
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value:
                                floors.contains(whichFloor) ? whichFloor : null,
                            decoration: InputDecoration(
                              labelText: 'Select Floor',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            items: floors.map((project) {
                              return DropdownMenuItem<int>(
                                value: project,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        getNumberWithSuffix(project),
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
                                whichFloor = newValue;
                                // updateCombinedText();
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a Floor';
                              }
                              return null;
                            },
                            isExpanded: true,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Unit No Dropdown
                        Expanded(
                          child: DropdownButtonFormField<Flat>(
                            value: flats.contains(selectedFlat)
                                ? selectedFlat
                                : null,
                            decoration: InputDecoration(
                              labelText: 'Select Unit No',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            items: flats.map((project) {
                              return DropdownMenuItem<Flat>(
                                value: project,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        project.number.toString().padLeft(
                                            2, '0'), // Add leading zero
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
                                selectedFlat = newValue;
                                carpetAreaController.text =
                                    newValue!.carpetArea.toString();
                                flatCostController.text =
                                    newValue.allInclusiveValue.toString();
                                // updateCombinedText();
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a Unit No';
                              }
                              return null;
                            },
                            isExpanded: true,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Flat No Field (Combined Floor and Unit No)
                        if (whichFloor != null && selectedFlat != null) ...[
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: TextEditingController(
                                text:
                                    '${whichFloor.toString()}${selectedFlat?.number.toString().padLeft(2, '0')}',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Flat No',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              readOnly:
                                  true, // Make the flat number non-editable
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),

                        // Conditionally display "Unit No" TextField
                        // if (whichFloor != null && selectedFlat != null) ...[
                        //   TextField(
                        //     controller:
                        //         unitNoController, // Ensure you have a TextEditingController for this
                        //     decoration: InputDecoration(
                        //       labelText: 'Unit No',
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(5),
                        //       ),
                        //     ),
                        //     readOnly: true, // If you want it to be read-only
                        //   ),
                        // ],
                      ],
                    ],

                    // Expanded(
                    //   child: CustomTextField(
                    //     label: "Unit No.",
                    //     keyboardType: TextInputType.number,
                    //     controller: unitNoController,
                    //     onChanged: (_) => setState(() {}),
                    //   ),
                    // ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: "Carpet Area (sq. ft.)",
                    controller: carpetAreaController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),

                  // Requirements Dropdown
                  // CustomDropdownField(
                  //   label: "Select Requirements",
                  //   items: requirements,
                  //   initialValue: selectedRequirements,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedRequirements = value;
                  //     });
                  //   },
                  // ),
                  // const SizedBox(height: 16),
                  CustomDropdownField(
                    label: "Number of Applicants",
                    items: applicantCounts,
                    initialValue: applicantCounts.first,
                    onChanged: (value) {
                      int count = int.parse(value!);
                      updateApplicantFields(count);
                      updateApplicantFieldsKyc(count);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Customer Details',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // CircularPercentIndicator(
                      //   radius: 24.0,
                      //   lineWidth: 5.0,
                      //   percent: calculateProgress(),
                      //   center: Text(
                      //     "${(calculateProgress() * 100).toInt()}%",
                      //     style: const TextStyle(fontSize: 12),
                      //   ),
                      //   progressColor: Colors.blue,
                      // ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  for (int i = 0; i < selectedApplicantCount; i++) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Applicant ${i + 1}"),
                                CircularPercentIndicator(
                                  radius: 24.0,
                                  lineWidth: 5.0,
                                  percent: applicantsPercents[i],
                                  center: Text(
                                    "${(applicantsPercents[i] * 100).floor()}%",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  progressColor: Colors.blue,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    label: "First Name",
                                    controller: firstNameController[i],
                                    onChanged: (_) => setState(() {
                                      calculateProgressFix(i);
                                    }),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomTextField(
                                    label: "Last Name",
                                    controller: lastNameController[i],
                                    onChanged: (_) => setState(() {
                                      calculateProgressFix(i);
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: "Contact Number",
                              controller: contactNumberController[i],
                              keyboardType: TextInputType.phone,
                              onChanged: (_) => setState(() {
                                calculateProgressFix(i);
                              }),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: "Address",
                              controller: addressController[i],
                              keyboardType: TextInputType.multiline,
                              onChanged: (_) => setState(() {
                                calculateProgressFix(i);
                              }),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: "Email ID",
                              controller: emailController[i],
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 16),
                            const Row(children: [Text('KYC Details')]),
                            const SizedBox(height: 8),
                            _buildKYCUploadField(
                                "Aadhar", aadharFiles[i], false, i),
                            _buildKYCUploadFieldForPAN(i),
                            _buildKYCUploadField(
                                "Other", otherFiles[i], false, i),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "Flat Cost",
                    controller: flatCostController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_selectedProject != null) ...[
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: parkingFloors.contains(whichParkingFloor)
                                ? whichParkingFloor
                                : null,
                            decoration: InputDecoration(
                              labelText: 'Parking Floor',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            items: parkingFloors.map((project) {
                              return DropdownMenuItem<int>(
                                value: project,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        project.toString(),
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
                                whichParkingFloor = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a Parking Floor';
                              }
                              return null;
                            },
                            isExpanded: true,
                          ),
                        ),
                        // Expanded(
                        //   child: CustomDropdownField(
                        //     label: "Select Floor",
                        //     items: const [
                        //       "1",
                        //       "2",
                        //       "3",
                        //       "4",
                        //       "5",
                        //       "6",
                        //       "7",
                        //       "8",
                        //       "9",
                        //       "10"
                        //     ],
                        //     initialValue: selectedFloor,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         selectedFloor = value;
                        //       });
                        //     },
                        //   ),
                        // ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<Parking>(
                            value: parkingNumbers.contains(selectedParking)
                                ? selectedParking
                                : null,
                            decoration: InputDecoration(
                              labelText: 'Parking No',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            items: parkingNumbers.map((project) {
                              return DropdownMenuItem<Parking>(
                                value: project,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        project.parkingNo ?? "NA",
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
                                selectedParking = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a Unit No';
                              }
                              return null;
                            },
                            isExpanded: true,
                          ),
                        ),
                      ],
                    ],
                  ),
                  // CustomDropdownField(
                  //   label: "Car Parking",
                  //   items: const ["Parking 1", "Parking 2", "Parking 3"],
                  //   initialValue: carParking,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       carParking = value!;
                  //       parkingCount = value == "Parking 1"
                  //           ? 1
                  //           : value == "Parking 2"
                  //               ? 2
                  //               : 3;
                  //     });
                  //   },
                  // ),
                  const SizedBox(height: 16),
                  for (int i = 1; i <= parkingCount; i++) ...[
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: "Parking $i Number",
                      controller: i == 1
                          ? parking1Controller
                          : i == 2
                              ? parking2Controller
                              : parking3Controller,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Employee>(
                    value: _selectedClosingManger,
                    decoration: InputDecoration(
                      labelText: 'Closing Manager',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
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
                                style: const TextStyle(fontSize: 12),
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
                  // CustomDropdownField(
                  //   label: "Select Manager",
                  //   items: [
                  //     "Deepak Karki",
                  //     "Vicky Mane",
                  //     "Harshal Kokate",
                  //     "Jaspreet Arora"
                  //   ],
                  //   initialValue: selectedManager,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedManager = value;
                  //       isMeetingAttendanceVisible = value != null;
                  //     });
                  //   },
                  // ),
                  if (isMeetingAttendanceVisible) ...[
                    const SizedBox(height: 16),
                    const Text("Meeting Attendance"),
                    const SizedBox(height: 8),
                    MultiSelectDropdown.simpleList(
                      list: teamMembers,
                      boxDecoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.black.withOpacity(0.8)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      initiallySelected: selectedTeamMembers,
                      checkboxFillColor: Colors.grey.withOpacity(0.3),
                      splashColor: Colors.grey.withOpacity(0.3),
                      includeSearch: true,
                      whenEmpty: "Members",
                      onChange: (newList) {
                        selectedTeamMembers =
                            newList.map((e) => e as String).toList();
                      },
                    ),
                    // DropdownButtonFormField<String>(
                    //   isExpanded: true,
                    //   hint: const Text("Select Team Members"),
                    //   value: null,
                    //   items: teamMembers.map((member) {
                    //     return DropdownMenuItem(
                    //       value: member,
                    //       child: Text(member),
                    //     );
                    //   }).toList(),
                    //   onChanged: (value) {
                    //     if (value != null) {
                    //       setState(() {
                    //         selectedTeamMembers.add(value);
                    //       });
                    //     }
                    //   },
                    //   decoration: InputDecoration(
                    //     contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    //     border: OutlineInputBorder(),
                    //   ),
                    // ),
                    // const SizedBox(height: 8),
                    // // Wrap for displaying selected team members
                    // Wrap(
                    //   spacing: 8, // Space between chips
                    //   runSpacing: 4, // Space between rows of chips
                    //   children: selectedTeamMembers
                    //       .map(
                    //         (member) => Chip(
                    //           label: Text(member),
                    //           // Add a delete icon
                    //           deleteIcon: const Icon(Icons.cancel),
                    //           onDeleted: () {
                    //             setState(() {
                    //               selectedTeamMembers.remove(member);
                    //             });
                    //           },
                    //           backgroundColor: Colors.blue.shade100,
                    //         ),
                    //       )
                    //       .toList(),
                    // ),
                  ],

                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Pre-registration Checklist",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      CircularPercentIndicator(
                        radius: 24.0,
                        lineWidth: 5.0,
                        percent: preregistrationPercents,
                        center: Text(
                          "${(preregistrationPercents * 100).floor()}%",
                          style: const TextStyle(fontSize: 12),
                        ),
                        progressColor: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Add checklist items using the _buildChecklistItem method
                  _buildChecklistItem(
                    title: "10% Received",
                    yesValue: tenPercentReceived.toLowerCase() == 'yes'
                        ? true
                        : false,
                    noValue:
                        tenPercentReceived.toLowerCase() == 'no' ? true : false,
                    partialValue: tenPercentReceived.toLowerCase() == 'partial'
                        ? true
                        : false,
                    onYesChanged: (value) => setState(() {
                      if (value == true) {
                        tenPercentReceived = "yes";
                      } else {
                        tenPercentReceived = "";
                      }
                      calculateProgressPreregistration();
                    }),

                    onNoChanged: (value) => setState(() {
                      if (value == true) {
                        tenPercentReceived = "no";
                      } else {
                        tenPercentReceived = "";
                      }
                      calculateProgressPreregistration();
                    }),
                    onPartialChanged: (value) => setState(() {
                      if (value == true) {
                        tenPercentReceived = "partial";
                      } else {
                        tenPercentReceived = "";
                      }
                      calculateProgressPreregistration();
                    }),
                    // comment: tenPercentComment,
                    onCommentChanged: (value) =>
                        setState(() => tenPercentComment = value),
                  ),
                  _buildChecklistItem(
                    title: "Stamp Duty",
                    yesValue: stampDuty.toLowerCase() == 'yes' ? true : false,
                    noValue: stampDuty.toLowerCase() == 'no' ? true : false,
                    partialValue:
                        stampDuty.toLowerCase() == 'partial' ? true : false,
                    onYesChanged: (value) => setState(() {
                      if (value == true) {
                        stampDuty = "yes";
                      } else {
                        stampDuty = "";
                      }
                      calculateProgressPreregistration();
                    }),

                    onNoChanged: (value) => setState(() {
                      if (value == true) {
                        stampDuty = "no";
                      } else {
                        stampDuty = "";
                      }
                      calculateProgressPreregistration();
                    }),
                    onPartialChanged: (value) => setState(() {
                      if (value == true) {
                        stampDuty = "partial";
                      } else {
                        stampDuty = "";
                      }
                      calculateProgressPreregistration();
                    }),
                    // comment: tenPercentComment,
                    onCommentChanged: (value) =>
                        setState(() => tenPercentComment = value),
                  ),
                  _buildChecklistItem(
                    title: "TDS Received",
                    yesValue: tdsReceive.toLowerCase() == 'yes' ? true : false,
                    noValue: tdsReceive.toLowerCase() == 'no' ? true : false,
                    partialValue:
                        tdsReceive.toLowerCase() == 'partial' ? true : false,
                    onYesChanged: (value) => setState(() {
                      if (value == true) {
                        tdsReceive = "yes";
                      } else {
                        tdsReceive = "";
                      }
                      calculateProgressPreregistration();
                    }),

                    onNoChanged: (value) => setState(() {
                      if (value == true) {
                        tdsReceive = "no";
                      } else {
                        tdsReceive = "";
                      }
                      calculateProgressPreregistration();
                    }),
                    onPartialChanged: (value) => setState(() {
                      if (value == true) {
                        tdsReceive = "partial";
                      } else {
                        tdsReceive = "";
                      }
                      calculateProgressPreregistration();
                    }),
                    // comment: tenPercentComment,
                    onCommentChanged: (value) =>
                        setState(() => tenPercentComment = value),
                  ),

                  _buildChecklistItem(
                    title: "GST",
                    yesValue: gstReceive.toLowerCase() == 'yes' ? true : false,
                    noValue: gstReceive.toLowerCase() == 'no' ? true : false,
                    partialValue:
                        gstReceive.toLowerCase() == 'partial' ? true : false,
                    onYesChanged: (value) => setState(() {
                      if (value == true) {
                        gstReceive = "yes";
                      } else {
                        gstReceive = "";
                      }
                      calculateProgressPreregistration();
                    }),

                    onNoChanged: (value) => setState(() {
                      if (value == true) {
                        gstReceive = "no";
                      } else {
                        gstReceive = "";
                      }
                      calculateProgressPreregistration();
                    }),
                    onPartialChanged: (value) => setState(() {
                      if (value == true) {
                        gstReceive = "partial";
                      } else {
                        gstReceive = "";
                      }
                      calculateProgressPreregistration();
                    }),
                    // comment: tenPercentComment,
                    onCommentChanged: (value) =>
                        setState(() => gstComment = value),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Aligns title and checkboxes
                    children: [
                      const Text("NOC Receive"),
                      Row(
                        children: [
                          Checkbox(
                            value: nocReceive.toLowerCase() == 'yes'
                                ? true
                                : false,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  nocReceive = "yes";
                                } else {
                                  nocReceive = "no";
                                }
                                calculateProgressPreregistration();
                              });
                            },
                          ),
                          const Text("Yes"),
                          Checkbox(
                            value:
                                nocReceive.toLowerCase() == 'no' ? true : false,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  nocReceive = "no";
                                } else {
                                  nocReceive = "yes";
                                }
                                calculateProgressPreregistration();
                              });
                            },
                          ),
                          const Text("No"),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // KYC Received
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("KYC Receive"),
                      Row(
                        children: [
                          Checkbox(
                            value: kycReceive.toLowerCase() == 'yes'
                                ? true
                                : false,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  kycReceive = "yes";
                                } else {
                                  kycReceive = "no";
                                }
                                calculateProgressPreregistration();
                              });
                            },
                          ),
                          const Text("Yes"),
                          Checkbox(
                            value:
                                kycReceive.toLowerCase() == 'no' ? true : false,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  kycReceive = "no";
                                } else {
                                  kycReceive = "yes";
                                }
                                calculateProgressPreregistration();
                              });
                            },
                          ),
                          const Text("No"),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Agreement Prepared
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Agreement Prepared"),
                      Row(
                        children: [
                          Checkbox(
                            value: agreementPrepared.toLowerCase() == 'yes'
                                ? true
                                : false,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  agreementPrepared = "yes";
                                } else {
                                  agreementPrepared = "no";
                                }
                                calculateProgressPreregistration();
                              });
                            },
                          ),
                          const Text("Yes"),
                          Checkbox(
                            value: agreementPrepared.toLowerCase() == 'no'
                                ? true
                                : false,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  agreementPrepared = "no";
                                } else {
                                  agreementPrepared = "yes";
                                }
                                calculateProgressPreregistration();
                              });
                            },
                          ),
                          const Text("No"),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Legal Charges Receive
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Legal Charges Receive"),
                      Row(
                        children: [
                          Checkbox(
                            value: legalchargesReceive.toLowerCase() == 'yes',
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  legalchargesReceive = "yes";
                                } else {
                                  legalchargesReceive = "no";
                                }
                                calculateProgressPreregistration();
                              });
                            },
                          ),
                          const Text("Yes"),
                          Checkbox(
                            value: legalchargesReceive.toLowerCase() == 'no',
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  legalchargesReceive = "no";
                                } else {
                                  legalchargesReceive = "yes";
                                }
                                calculateProgressPreregistration();
                              });
                            },
                          ),
                          const Text("No"),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Agreement Handover"),
                      Row(
                        children: [
                          Checkbox(
                            value: agreementHandover.toLowerCase() == 'yes',
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  agreementHandover = "yes";
                                } else {
                                  agreementHandover = "no";
                                }
                                calculateProgressPreregistration();
                              });
                            },
                          ),
                          const Text("Yes"),
                          Checkbox(
                            value: agreementHandover.toLowerCase() == 'no',
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  agreementHandover = "no";
                                } else {
                                  agreementHandover = "yes";
                                }
                                calculateProgressPreregistration();
                              });
                            },
                          ),
                          const Text("No"),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  if (agreementHandover == "yes") ...[
                    const Text(
                      "Upload Agreement Files:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    ElevatedButton.icon(
                      onPressed: () async {
                        // Pick multiple files
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                        );

                        if (result != null) {
                          setState(() {
                            uploadedFiles.addAll(result.files);
                          });
                        }
                      },
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Upload Files"),
                    ),

                    const SizedBox(height: 8),

                    // Display list of uploaded files
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: uploadedFiles
                          .map(
                            (file) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.description, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(file.name)),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        uploadedFiles.remove(file);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  // const SizedBox(height: 16),

                  // const Row(
                  //   children: [
                  //     Text("Booking Status"),
                  //     SizedBox(
                  //       width: 8,
                  //     ),
                  //   ],
                  // ),
                  // const Spacer(),

                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedBookingType,
                    decoration: InputDecoration(
                      labelText: 'Booking Status',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    isExpanded: true,
                    items: bookingStatus.map((bks) {
                      return DropdownMenuItem<String>(
                        value: bks,
                        child: Text(
                          bks,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedBookingType = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a Booking Type';
                      }
                      return null;
                    },
                  ),

                  // DropdownButton<String>(
                  //   hint: const Text('Select Booking Type'),
                  //   value: selectedBookingType,
                  //   items: const [
                  //     DropdownMenuItem(
                  //       value: 'EOI',
                  //       child: Text('EOI'),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: 'Confirm Booking',
                  //       child: Text('Confirm Booking'),
                  //     ),
                  //   ],
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedBookingType = value;
                  //       amountController.clear();
                  //       if (value == 'EOI') {
                  //         _calculateAmounts(isEOI: true);
                  //         isConfirmBookingVisible = false;
                  //       } else if (value == 'Confirm Booking') {
                  //         _calculateAmounts(isEOI: false);
                  //         isConfirmBookingVisible = true;
                  //       }
                  //     });
                  //   },
                  // ),

                  const SizedBox(height: 16),

                  // if (isBookingDetailsVisible) ...[
                  // EOI Section Container (Shown only when selectedBookingType is 'EOI')
                  if (selectedBookingType == 'EOI')
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "EOI",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Amount',
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.5),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                    // contentPadding:
                                    //     const EdgeInsets.symmetric(vertical: 0.0),
                                  ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: DropdownButton<String>(
                                  itemHeight: 70,
                                  isExpanded: true,
                                  hint: const Text('Booking Account'),
                                  value: selectedBookingAccount,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Government Account',
                                      child: Text('Government Account'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Business Account',
                                      child: Text('Business Account'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBookingAccount = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.add, color: Colors.blue),
                              onPressed: () {
                                setState(() {
                                  isConfirmBookingVisible = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Confirm Booking Section (Shown only when isConfirmBookingVisible is true)
                  if (isConfirmBookingVisible ||
                      selectedBookingType == 'Confirm Booking')
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Confirm Booking",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Amount',
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.5),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                  ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(width: 8),
                              DropdownButton<String>(
                                itemHeight: 70,
                                hint: const Text('Booking Account'),
                                value: selectedBookingAccount,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Government Account',
                                    child: Text('Government Account'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Business Account',
                                    child: Text('Business Account'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedBookingAccount = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  // ],
                  const SizedBox(height: 10),

                  DropdownButtonFormField<Employee>(
                    value: _selectedPostSalesExecutive,
                    decoration: InputDecoration(
                      labelText: 'Assign to',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    items: postSalesEx.map((ex) {
                      return DropdownMenuItem<Employee>(
                        value: ex,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${ex.firstName} ${ex.lastName}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                "(${ex.designation?.designation ?? "NA"})",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedPostSalesExecutive = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a Post Sale Executive';
                      }
                      return null;
                    },
                    isExpanded: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Center(
                    child: ElevatedButton(
                      onPressed: onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openBookingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Booking Option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("EOI"),
                onTap: () {
                  _calculateAmounts(isEOI: true);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text("Confirm Booking"),
                onTap: () {
                  _calculateAmounts(isEOI: false);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _calculateAmounts({required bool isEOI}) {
    double allInclusiveValue = double.parse(allInclusive.replaceAll(',', ''));
    setState(() {
      isBookingDetailsVisible = true;
      if (isEOI) {
        builderAmount = allInclusiveValue * 0.10; // 10% of allInclusive
        taxAmount = allInclusiveValue * 0.02; // 2% of allInclusive
      } else {
        builderAmount = allInclusiveValue * 0.15; // Example for Confirm Booking
        taxAmount = allInclusiveValue * 0.03; // Example for Confirm Booking
      }
    });
  }

  Widget _buildChecklistItem({
    required String title,
    required bool yesValue,
    required bool partialValue,
    required bool noValue,
    required ValueChanged<bool?>? onYesChanged,
    required ValueChanged<bool?>? onNoChanged,
    required ValueChanged<bool?>? onPartialChanged,
    // required String comment,
    required ValueChanged<String>? onCommentChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Row(
              children: [
                Checkbox(value: yesValue, onChanged: onYesChanged),
                const Text("Yes"),
                Checkbox(value: noValue, onChanged: onNoChanged),
                const Text("No"),
                Checkbox(value: partialValue, onChanged: onPartialChanged),
                const Text("Partial"),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Text(
        //   comment.isNotEmpty ? comment : "No comments",
        //   style: const TextStyle(fontSize: 16),
        // ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onCommentChanged,
          decoration: const InputDecoration(
            labelText: "Comment",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildKYCUploadField(
      String label, List<File> files, bool isSingle, int applicantIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text("$label (Applicant ${applicantIndex + 1})")),
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () =>
                  _pickFilesForField(label, isSingle, applicantIndex),
            ),
          ],
        ),
        if (files.isNotEmpty)
          ...files.map((file) => ListTile(
                leading: const Icon(Icons.description),
                title: Text(path.basename(file.path)),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => _removeFile(label, file, applicantIndex),
                ),
              )),
      ],
    );
  }

  Future<void> _pickFilesForField(
    String fieldType,
    bool isSingle,
    int applicantIndex,
  ) async {
    final result =
        await FilePicker.platform.pickFiles(allowMultiple: !isSingle);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        List<File> pickedFiles =
            result.files.map((file) => File(file.path!)).toList();
        if (isSingle) {
          panFiles[applicantIndex] = pickedFiles;
        } else {
          if (fieldType == "Aadhar") {
            aadharFiles[applicantIndex].addAll(pickedFiles);
          } else if (fieldType == "Other") {
            otherFiles[applicantIndex].addAll(pickedFiles);
          }
        }
      });
      calculateProgressFix(applicantIndex);
    }
  }

  void _removeFile(String fieldType, File file, int applicantIndex) {
    setState(() {
      if (fieldType == "Aadhar") {
        aadharFiles[applicantIndex].remove(file);
      } else if (fieldType == "Other") {
        otherFiles[applicantIndex].remove(file);
      }
    });
    calculateProgressFix(applicantIndex);
  }

  Widget _buildKYCUploadFieldForPAN(int applicantIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text("PAN (Applicant ${applicantIndex + 1})")),
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () => _pickPANFile(applicantIndex),
            ),
          ],
        ),
        if (panFiles[applicantIndex].isNotEmpty)
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(path.basename(panFiles[applicantIndex][0].path)),
            trailing: IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () => _removePANFile(applicantIndex),
            ),
          ),
      ],
    );
  }

  Future<void> _pickPANFile(int applicantIndex) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        panFiles[applicantIndex] = [File(result.files.single.path!)];
      });
      calculateProgressFix(applicantIndex);
    }
  }

  void _removePANFile(int applicantIndex) {
    setState(() {
      panFiles[applicantIndex].clear();
    });
    calculateProgressFix(applicantIndex);
  }
}

class CustomDateTimeField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final DateTime selectedDate;
  final Function(DateTime) onUpdate;
  const CustomDateTimeField({
    super.key,
    required this.label,
    required this.controller,
    required this.selectedDate,
    required this.onUpdate,
  });

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onUpdate(dateTime);
        // selectedDate = dateTime;
        controller.text = Helper.formatDateLong(dateTime.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () => _selectDateTime(context),
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Select Date and Time',
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? initialValue;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        // const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: initialValue,
          onChanged: onChanged,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// CustomTextField widget
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final ValueChanged<String?> onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}
