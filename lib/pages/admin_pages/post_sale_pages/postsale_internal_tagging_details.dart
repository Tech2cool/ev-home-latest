import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/models/post_sale_lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PostsaleInternalTaggingDetails extends StatefulWidget {
  final PostSaleLead lead;

  const PostsaleInternalTaggingDetails({
    super.key,
    required this.lead,
  });

  @override
  State<PostsaleInternalTaggingDetails> createState() =>
      _PostsaleInternalTaggingDetailsState();
}

class _PostsaleInternalTaggingDetailsState
    extends State<PostsaleInternalTaggingDetails> {
  bool isUpdating = false;
  bool isLoading = false;

  final unitNoController = TextEditingController();
  final floorController = TextEditingController();
  List<TextEditingController> firstNameController = [TextEditingController()];
  List<TextEditingController> lastNameController = [TextEditingController()];
  List<TextEditingController> contactNumberController = [
    TextEditingController()
  ];
  List<TextEditingController> addressController = [TextEditingController()];
  List<TextEditingController> emailController = [TextEditingController()];
  final TextEditingController dateTimeController = TextEditingController();
  final flatCostController = TextEditingController();
  final carpetAreaController = TextEditingController();
  final saleableAreaController = TextEditingController();
  final List<String> applicantCounts = ["1", "2", "3", "4", "5"];
  int selectedApplicantCount = 1;
  List<TextEditingController> applicantControllers = [];

  List<List<File>> aadharFiles = [];
  List<List<File>> panFiles = [];
  List<List<File>> otherFiles = [];
  String? selectedProject;
  String? selectedFloor;
  final Map<String, List<String>> projectFloors = {
    "Marina Bay": ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
    "Nine Square": ["1", "2", "3", "4", "5", "6"]
  };
  String? selectedSaleType;

  final List<String> saleTypes = ['Sold', 'Unsold', 'Hold'];

  String? selectedRequirements;
  // List<String> projects = ["Marina Bay", "Nine Square", "Heart City"];
  List<String> requirements = ["1BHK", "2BHK", "3BHK", "4BHK", "1RK", "Jodi"];
  Employee? emp;
  // Dummy values for the form fields
  String floor = "1";
  String unitNo = "01101";
  String project = "EV 10 Marina Bay";
  String numberOfApplicants = "5";
  String firstName = "";
  String lastName = "";
  String contactNumber = "9892983456";
  String address = "123 Main Street, Navi Mumbai, India";
  String email = "mayur@evgroup.co.in";
  int? carpetArea;
  int? saleableArea;
  String flatCost = "1.1 CR";

  String carParking = "Parking 1";
  int parkingCount = 1;

  String? selectedManager;
  bool isMeetingAttendanceVisible = false;
  bool isBookingDetailsVisible = false;
  bool isConfirmBookingVisible = false;

  String? selectedBookingType;
  final TextEditingController amountController = TextEditingController();
  String? selectedBookingAccount;

  // Dummy team member names
  List<String> teamMembers = ["Rohan", "Priya", "Nadeem", "Ram", "Payal"];
  List<String> selectedTeamMembers = [];

  // File variables for KYC uploads
  File? aadharFile;
  File? panFile;
  File? otherFile;

  // Booking status checkboxes
  bool eoiChecked = false;
  bool bookingConfirmedChecked = false;
  bool registrationDoneChecked = false;
  bool disbursementChecked = false;
  bool possessionChecked = false;

  String agreementHandover = '';
  bool agreementHandoverNo = false;
  List<PlatformFile> uploadedFiles = [];

  String nocReceive = '';
  bool nocReceiveNo = false;
  String kycReceive = '';
  bool kycReceiveNo = false;
  String agreementPrepared = '';
  bool agreementPreparedNo = false;
  String legalchargereceive = '';
  bool legalchargereceiveNo = false;

  // Dummy values for the form fields
  String tenPercentComment = "";
  String stampDutyComment = "";
  String gstComment = "";
  String tdsReceiveComment = "";

  // Dummy checkbox variables
  String tenPercentReceived = 'no';
  bool tenPercentReceivedNo = false;
  bool tenPercentReceivedPartial = false;

  String stampDuty = 'no';
  bool stampDutyNo = false;
  bool stampDutyPartial = false;

  String gst = '';
  bool gstNo = false;
  bool gstPartial = false;

  String tdsReceive = '';
  bool tdsReceiveNo = false;
  bool tdsReceivePartial = false;

  final String allInclusive = '270,000';
  double builderAmount = 0.0;
  double taxAmount = 0.0;
  Employee? _selectedClosingManger;
  Employee? selectedPostSalesExecutives;
  // Employee? _selectedAssignee;
  // Employee? _selectedTeamLeader;

  OurProject? _selectedProject;

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
        settingProvider.getTeamLeaders(),
        settingProvider.getOurProject(),
        settingProvider.getPostSalesEx(),
      ]);
    } catch (e) {
      // Handle any errors if needed
    } finally {
      // Ensure isLoading is set to false in both success and error cases
      setState(() {
        isLoading = false;
      });
    }
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

  final ImagePicker _picker = ImagePicker();

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

  void generateApplicants(List<Applicant> applicants) {
    // Clear existing controllers and files

    firstNameController.clear();
    lastNameController.clear();
    contactNumberController.clear();
    addressController.clear();
    emailController.clear();
    aadharFiles.clear();
    panFiles.clear();
    otherFiles.clear();

    // Set the selected applicant count
    selectedApplicantCount = applicants.length;

    // Initialize controllers and file lists for each applicant
    for (var applicant in applicants) {
      firstNameController.add(TextEditingController(text: applicant.firstName));
      lastNameController.add(TextEditingController(text: applicant.lastName));
      contactNumberController.add(
          TextEditingController(text: applicant.phoneNumber?.toString() ?? ''));
      addressController.add(TextEditingController(text: applicant.address));
      emailController.add(TextEditingController(text: applicant.email));
      aadharFiles.add([]);
      panFiles.add([]);
      otherFiles.add([]);
    }

    // Update the applicant fields to reflect the new count
    updateApplicantFields(selectedApplicantCount);
  }

  void updateApplicantFields(int count) {
    setState(() {
      selectedApplicantCount = count;

      updateApplicantFieldsKyc(count);

      if (count > firstNameController.length) {
        for (int i = firstNameController.length; i < count; i++) {
          firstNameController.add(TextEditingController());
          lastNameController.add(TextEditingController());
          contactNumberController.add(TextEditingController());
          addressController.add(TextEditingController());
          emailController.add(TextEditingController());
        }
      } else if (count < firstNameController.length) {
        firstNameController.removeRange(count, firstNameController.length);
        lastNameController.removeRange(count, lastNameController.length);
        contactNumberController.removeRange(
            count, contactNumberController.length);
        addressController.removeRange(count, addressController.length);
        emailController.removeRange(count, emailController.length);
      }
    });
  }

//   void generateCountApplicants(List<Applicant> applicants) {
//   // Clear existing controllers and files
//   firstNameController.clear();
//   lastNameController.clear();
//   contactNumberController.clear();
//   addressController.clear();
//   emailController.clear();
//   aadharFiles.clear();
//   panFiles.clear();
//   otherFiles.clear();

//   // Set the selected applicant count
//   selectedApplicantCount = applicants.length;

//   // Initialize controllers and file lists for each applicant
//   for (var applicant in applicants) {
//     firstNameController.add(TextEditingController(text: applicant.firstName));
//     lastNameController.add(TextEditingController(text: applicant.lastName));
//     contactNumberController.add(TextEditingController(text: applicant.phoneNumber?.toString() ?? ''));
//     addressController.add(TextEditingController(text: applicant.address));
//     emailController.add(TextEditingController(text: applicant.email));
//     aadharFiles.add([]);
//     panFiles.add([]);
//     otherFiles.add([]);
//   }

//   // Update the applicant fields to reflect the new count
//   updateApplicantFields(selectedApplicantCount);
// }

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

  @override
  void initState() {
    super.initState();
    _onRefresh();
    unitNo = widget.lead.unitNo;
    firstName = widget.lead.firstName ?? "";
    lastName = widget.lead.lastName ?? "";
    contactNumber = widget.lead.phoneNumber.toString();
    address = widget.lead.address ?? "";
    email = widget.lead.email ?? "";
    carpetArea = widget.lead.carpetArea;
    carpetAreaController.text = widget.lead.carpetArea?.toString() ?? '';
    unitNoController.text = widget.lead.unitNo;
    selectedFloor = widget.lead.floor?.toString();
    saleableArea = widget.lead.sellableCarpetArea;
    floorController.text = widget.lead.floor?.toString() ?? "";
    flatCost = widget.lead.flatCost?.toString() ?? 'NA';
    flatCostController.text = widget.lead.flatCost?.toString() ?? '';
    tenPercentReceived =
        widget.lead.preRegistrationCheckList.tenPercentRecieved.recieved;
    tdsReceive = widget.lead.preRegistrationCheckList.tds.recieved;
    gst = widget.lead.preRegistrationCheckList.gst.recieved;
    nocReceive = widget.lead.preRegistrationCheckList.noc.recieved;
    _selectedProject = widget.lead.project;
    selectedRequirements = widget.lead.requirement;
    dateTimeController.text = widget.lead.date;
    _selectedClosingManger = widget.lead.closingManager;
    selectedPostSalesExecutives = widget.lead.postSaleExecutive;
    generateApplicants(widget.lead.applicants);
  }

  void onSubmit() async {
    try {
      final settingProvider = context.read<SettingProvider>();
      var i = 0;
      final List<Applicant> apps = [];
      setState(() {
        isLoading = true;
      });
      // print("On Submit 1");

      for (var index in firstNameController) {
        var uploadedAdhar;
        var uploadedPan;
        var uploadedOther;
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
          Helper.showCustomSnackBar("Error uploading Documents");
        }

        final aadharFile = uploadedAdhar;
        final panFile = uploadedPan;
        final otherFile = uploadedOther;

        apps.add(
          Applicant(
            firstName: firstNameController[i].text,
            lastName: lastNameController[i].text,
            email: emailController[i].text,
            address: addressController[i].text,
            phoneNumber:
                int.tryParse(contactNumberController[i].text.trim()) ?? 0,
            kyc: Kyc(
              addhar: KycDocument(document: aadharFile, type: 'aadhar'),
              pan: KycDocument(document: panFile, type: 'pan'),
              other: KycDocument(document: otherFile, type: 'other'),
            ),
          ),
        );
        i++;
      }
      // print("On Submit pass uplaod loop");

      // Ensure selectedProject is not null
      if (_selectedProject == null) {
        Helper.showCustomSnackBar("Please select a project");
        return;
      }
      // print("On Submit pass null project");

      final newPostLead = PostSaleLead(
        id: widget.lead.id,
        unitNo: unitNoController.text,
        floor: int.parse(selectedFloor?.trim() ?? "0"),
        number: int.parse(unitNoController.text.trim()),
        flatCost: int.parse(flatCostController.text.trim()),
        carpetArea:
            int.tryParse(carpetAreaController.text.trim()) ?? carpetArea,
        project: _selectedProject,
        date: dateTimeController.text,
        firstName: firstNameController[0].text.trim(),
        lastName: lastNameController[0].text.trim(),
        phoneNumber: int.tryParse(contactNumberController[0].text.trim()) ?? 0,
        address: addressController[0].text.trim(),
        email: emailController[0].text.trim(),
        applicants: apps,
        closingManager: _selectedClosingManger,
        postSaleExecutive: selectedPostSalesExecutives,
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
            recieved: gst,
          ),
          noc: ChecklistItem(recieved: nocReceive),
          tds: ChecklistItem(
            remark: tdsReceiveComment,
            recieved: tdsReceive,
          ),
          legalCharges: ChecklistItem(recieved: legalchargereceive),
          kyc: ChecklistItem(recieved: kycReceive),
          agreement: Agreement(
            handOver: HandOver(status: agreementHandover),
            document: Document(),
            prepared: agreementPrepared.toLowerCase() == 'yes' ? true : false,
          ),
        ),
      );

      // Helper.showCustomSnackBar("Submitting lead...");
      // print("json serilization start");
      Map<String, dynamic> jsonLead = newPostLead.toJson();
      // print("json serilization success");

      if (newPostLead.closingManager != null) {
        jsonLead['closingManager'] = newPostLead.closingManager!.id;
      }

      if (newPostLead.project != null) {
        jsonLead['project'] = newPostLead.project!.id;
      }

      if (newPostLead.postSaleExecutive != null) {
        jsonLead['postSaleExecutive'] = newPostLead.postSaleExecutive!.id;
      }
      // print("json update start");

      await settingProvider.updatePostSaleLead(widget.lead.id, jsonLead);
      // print("json update end");

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      // print(e);
      // Helper.showCustomSnackBar("Unknown Error adding Booking $e");
    } finally {
      setState(() {
        isLoading = false;
        isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final closingMangers = settingProvider.closingManagers;
    final postSales = settingProvider.postSalesExecutives;
    // final postSalesExecutives = postSales
    //     .where((employee) =>
    //         employee.designation?.designation == 'Post Sales Executive')
    //     .toList();
    final teamLeaders = settingProvider.teamLeaders;
    final requirements = settingProvider.requirements;
    final projects = settingProvider.ourProject;

    return Scaffold(
      appBar: AppBar(
        title: Text("Booking details"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String choice) {
              setState(() {
                isUpdating = choice == 'Edit';
              });
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'Edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem<String>(
                value: 'Cancel',
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDateTimeField(
              label: "Booking Date",
              controller: TextEditingController(
                text: DateFormat('dd-MM-yyyy').format(
                  DateTime.parse(dateTimeController.text),
                ),
              ),
              enabled: isUpdating,
            ),
            const SizedBox(height: 16),
            CustomDateTimeField(
              label: "Final Sale Deed Date",
              controller: TextEditingController(
                text: DateFormat('dd-MM-yyyy').format(
                  DateTime.parse(dateTimeController.text),
                ),
              ),
              enabled: isUpdating,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<OurProject>(
              value:
                  projects.contains(_selectedProject) ? _selectedProject : null,
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
                          project.name,
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

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Sale Type',
                border: OutlineInputBorder(),
              ),
              value: selectedSaleType,
              items: saleTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSaleType = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: "Floor",
              controller: floorController,
              initialValue: floor,
              onChanged: isUpdating ? (value) => floor = value : null,
              // outlineEnabled: isUpdating,
              readOnly: !isUpdating,
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: "Unit No.",
                    controller: unitNoController,
                    initialValue: unitNo,
                    onChanged: isUpdating ? (value) => unitNo = value : null,
                    // outlineEnabled: isUpdating,
                    readOnly: !isUpdating,
                  ),
                ),
                if (selectedProject != null) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomDropdownField(
                      label: "Select Floor",
                      items: projectFloors[selectedProject!] ?? [],
                      initialValue: selectedFloor,
                      onChanged: isUpdating
                          ? (value) {
                              setState(() {
                                selectedFloor = value;
                              });
                            }
                          : null,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: carpetAreaController,
                    label: "Carpet Area (sq. ft.)",
                    initialValue: carpetArea.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: isUpdating
                        ? (value) => carpetArea = int.tryParse(value)
                        : null,
                    outlineEnabled: isUpdating,
                    readOnly: !isUpdating,
                  ),
                ),
                // Expanded(
                //   child: CustomTextField(
                //     controller: saleableAreaController,
                //     label: "Saleable Area (sq. ft.)",
                //     initialValue: saleableArea.toString(),
                //     keyboardType: TextInputType.number,
                //     onChanged: isUpdating
                //         ? (value) => saleableArea = int.tryParse(value)
                //         : null,
                //     outlineEnabled: isUpdating,
                //     readOnly: !isUpdating,
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 16),

            CustomTextField(
              controller: flatCostController,
              label: "Flat Cost",
              initialValue: "₹" + flatCost,
              keyboardType: TextInputType.number,
              onChanged: isUpdating ? (value) => flatCost = value : null,
              outlineEnabled: isUpdating,
              readOnly: !isUpdating,
            ),

            // Assuming maxApplicants is the dynamic count of total applicants you have
            const SizedBox(height: 16),

            CustomDropdownField(
              label: "Number of Applicants",
              items: applicantCounts,
              initialValue: selectedApplicantCount
                  .toString(), // Set the initial value based on selectedApplicantCount
              onChanged: isUpdating
                  ? (value) {
                      setState(() {
                        selectedApplicantCount = int.parse(value!);
                        updateApplicantFields(selectedApplicantCount);
                      });
                    }
                  : null,
              enabled: isUpdating,
            ),

// Displaying the applicant fields
            for (int i = 0; i < selectedApplicantCount; i++)
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
                      Text("Applicant ${i + 1}"),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: firstNameController[i],
                              label: "First Name",
                              initialValue: firstNameController[i].text,
                              outlineEnabled: isUpdating,
                              readOnly: !isUpdating,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              controller: lastNameController[i],
                              label: "Last Name",
                              initialValue: lastNameController[i].text,
                              outlineEnabled: isUpdating,
                              readOnly: !isUpdating,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: contactNumberController[i],
                        label: "Contact Number",
                        initialValue: contactNumberController[i].text,
                        //   keyboardType: TextInputType.phone,
                        outlineEnabled: isUpdating,
                        readOnly: !isUpdating,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: addressController[i],
                        label: "Address",
                        initialValue: addressController[i].text,
                        outlineEnabled: isUpdating,
                        readOnly: !isUpdating,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: emailController[i],
                        label: "Email ID",
                        initialValue: emailController[i].text,
                        keyboardType: TextInputType.emailAddress,
                        outlineEnabled: isUpdating,
                        readOnly: !isUpdating,
                      ),
                      const SizedBox(height: 16),
                      // CustomTextField(
                      //   controller: TextEditingController(),
                      //   label: "Aadhar",
                      //    initialValue: aadharFiles. "No Aadhar Uploaded",
                      //   outlineEnabled: isUpdating,
                      //   readOnly: !isUpdating,
                      // ),

                      _buildKYCUploadField("Aadhar", aadharFiles[i], false, i),
                      _buildKYCUploadFieldForPAN(i),
                      _buildKYCUploadField("Other", otherFiles[i], false, i),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            const SizedBox(height: 16),
            CustomDropdownField(
              label: "Car Parking",
              items: ["Parking 1", "Parking 2", "Parking 3"],
              initialValue: carParking,
              onChanged: isUpdating
                  ? (value) {
                      setState(() {
                        carParking = value!;
                        // Set the number of parking boxes based on selection
                        parkingCount = value == "Parking 1"
                            ? 1
                            : value == "Parking 2"
                                ? 2
                                : 3;
                      });
                    }
                  : null,
              enabled: isUpdating,
            ),
            const SizedBox(height: 16),

            // Parking Boxes based on selection
            for (int i = 1; i <= parkingCount; i++) ...[
              SizedBox(
                height: 12,
              ),
              CustomTextField(
                controller: TextEditingController(),
                label: "Parking ${i} Number",
                keyboardType: TextInputType.number,
                onChanged: isUpdating ? (value) {} : null,
                outlineEnabled: isUpdating,
                readOnly: !isUpdating,
              ),
            ],

            const SizedBox(height: 16),
            // Manager dropdown field
            DropdownButtonFormField<Employee>(
              value: closingMangers.contains(_selectedClosingManger)
                  ? _selectedClosingManger
                  : null,
              decoration: InputDecoration(
                labelText: 'Closing Manager',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              items: closingMangers.map((closingManager) {
                return DropdownMenuItem<Employee>(
                  value: closingManager,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${closingManager.firstName} ${closingManager.lastName}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          "(${closingManager.designation?.designation ?? "NA"})",
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
            if (isMeetingAttendanceVisible) ...[
              const SizedBox(height: 16),
              const Text("Meeting Attendance"),
              const SizedBox(height: 8),
              MultiSelectDropdown.simpleList(
                list: teamMembers,
                boxDecoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.8)),
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
            ],

            const SizedBox(height: 16),

            // Pre-registration Checklist Section
            const Text("Pre-registration Checklist",
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),

            // 10% Received
            // Checklist Item for 10% Received
            _buildChecklistItem(
              title: "10% Received",
              yesValue:
                  tenPercentReceived.toLowerCase() == 'yes' ? true : false,
              noValue: tenPercentReceived.toLowerCase() == 'no' ? true : false,
              partialValue:
                  tenPercentReceived.toLowerCase() == 'partial' ? true : false,
              onYesChanged: isUpdating
                  ? (value) => setState(() {
                        if (value == true) {
                          tenPercentReceived = "yes";
                        } else {
                          tenPercentReceived = "";
                        }
                      })
                  : null,
              onNoChanged: isUpdating
                  ? (value) => setState(() {
                        if (value == true) {
                          tenPercentReceived = "no";
                        } else {
                          tenPercentReceived = "";
                        }
                      })
                  : null,
              onPartialChanged: isUpdating
                  ? (value) => setState(() {
                        if (value == true) {
                          tenPercentReceived = "partial";
                        } else {
                          tenPercentReceived = "";
                        }
                      })
                  : null,
              comment: tenPercentComment,
              onCommentChanged: (value) {
                tenPercentComment = value;
              },
              isCommentEditable: isUpdating,
            ),

            const SizedBox(height: 16),

            // Checklist Item for Stamp Duty
            _buildChecklistItem(
              title: "Stamp Duty",
              yesValue: stampDuty.toLowerCase() == 'yes' ? true : false,
              noValue: stampDuty.toLowerCase() == 'no' ? true : false,
              partialValue: stampDuty.toLowerCase() == 'partial' ? true : false,
              onYesChanged: isUpdating
                  ? (value) => setState(() {
                        if (value == true) {
                          stampDuty = "yes";
                        } else {
                          stampDuty = "";
                        }
                      })
                  : null,
              onNoChanged: isUpdating
                  ? (value) => setState(() {
                        if (value == true) {
                          stampDuty = "no";
                        } else {
                          stampDuty = "";
                        }
                      })
                  : null,
              onPartialChanged: isUpdating
                  ? (value) => setState(() {
                        if (value == true) {
                          stampDuty = "partial";
                        } else {
                          stampDuty = "";
                        }
                      })
                  : null,
              comment: stampDutyComment,
              onCommentChanged: (value) {
                stampDutyComment = value;
              },
              isCommentEditable: isUpdating,
            ),

            const SizedBox(height: 16),

            // Checklist Item for GST
            _buildChecklistItem(
              title: "GST",
              yesValue: gst.toLowerCase() == 'yes' ? true : false,
              noValue: gst.toLowerCase() == 'no' ? true : false,
              partialValue: gst.toLowerCase() == 'partial' ? true : false,
              onYesChanged: isUpdating
                  ? (value) => setState(() {
                        if (value == true) {
                          gst = "yes";
                        } else {
                          gst = "";
                        }
                      })
                  : null,
              onNoChanged: isUpdating
                  ? (value) => setState(() {
                        if (value == true) {
                          gst = "no";
                        } else {
                          gst = "";
                        }
                      })
                  : null,
              onPartialChanged: isUpdating
                  ? (value) => setState(() {
                        if (value == true) {
                          gst = "partial";
                        } else {
                          gst = "";
                        }
                      })
                  : null,
              comment: gstComment,
              onCommentChanged: (value) {
                gstComment = value;
              },
              isCommentEditable: isUpdating,
            ),

            const SizedBox(height: 16),

            // Checklist Item for TDS Received
            _buildChecklistItem(
              title: "TDS Received",
              yesValue: tdsReceive.toLowerCase() == 'yes' ? true : false,
              noValue: tdsReceive.toLowerCase() == 'no' ? true : false,
              partialValue:
                  tdsReceive.toLowerCase() == 'partial' ? true : false,
              onYesChanged: isUpdating
                  ? (value) => setState(() {
                        if (value == true) {
                          tdsReceive = "yes";
                        } else {
                          tdsReceive = "";
                        }
                      })
                  : null,
              onNoChanged: isUpdating
                  ? (value) => setState(() {
                        if (value == true) {
                          tdsReceive = "no";
                        } else {
                          tdsReceive = "";
                        }
                      })
                  : null,
              onPartialChanged: isUpdating
                  ? (value) => setState(() {
                        if (value == true) {
                          tdsReceive = "partial";
                        } else {
                          tdsReceive = "";
                        }
                      })
                  : null,
              comment: tdsReceiveComment,
              onCommentChanged: (value) {
                tdsReceiveComment = value;
              },
              isCommentEditable: isUpdating,
            ),
            // NOC Receive
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Aligns title and checkboxes
              children: [
                const Text("NOC Receive"),
                Row(
                  children: [
                    Checkbox(
                      value: nocReceive.toLowerCase() == 'yes' ? true : false,
                      onChanged: isUpdating
                          ? (value) {
                              setState(() {
                                if (value == true) {
                                  nocReceive = "yes";
                                } else {
                                  nocReceive = "no";
                                }
                              });
                            }
                          : null,
                    ),
                    const Text("Yes"),
                    Checkbox(
                      value: nocReceive.toLowerCase() == 'no' ? true : false,
                      onChanged: isUpdating
                          ? (value) {
                              setState(() {
                                if (value == true) {
                                  nocReceive = "no";
                                } else {
                                  nocReceive = "yes";
                                }
                              });
                            }
                          : null,
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
                      value: kycReceive.toLowerCase() == 'yes' ? true : false,
                      onChanged: isUpdating
                          ? (value) {
                              setState(() {
                                if (value == true) {
                                  kycReceive = "yes";
                                } else {
                                  kycReceive = "no";
                                }
                              });
                            }
                          : null,
                    ),
                    const Text("Yes"),
                    Checkbox(
                      value: kycReceive.toLowerCase() == 'no' ? true : false,
                      onChanged: isUpdating
                          ? (value) {
                              setState(() {
                                if (value == true) {
                                  kycReceive = "no";
                                } else {
                                  kycReceive = "yes";
                                }
                              });
                            }
                          : null,
                    ),
                    const Text("No"),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

// Agreement Prepared
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Aligns title and checkboxes
              children: [
                const Text("Agreement Prepared"),
                Row(
                  children: [
                    Checkbox(
                      value: agreementPrepared.toLowerCase() == 'yes'
                          ? true
                          : false,
                      onChanged: isUpdating
                          ? (value) {
                              setState(() {
                                if (value == true) {
                                  agreementPrepared = "yes";
                                } else {
                                  agreementPrepared = "no";
                                }
                              });
                            }
                          : null,
                    ),
                    const Text("Yes"),
                    Checkbox(
                      value: agreementPrepared.toLowerCase() == 'no'
                          ? true
                          : false,
                      onChanged: isUpdating
                          ? (value) {
                              setState(() {
                                if (value == true) {
                                  agreementPrepared = "no";
                                } else {
                                  agreementPrepared = "yes";
                                }
                              });
                            }
                          : null,
                    ),
                    const Text("No"),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

// Legal Charges Receive
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Aligns title and checkboxes
              children: [
                const Text("Legal Charges Receive"),
                Row(
                  children: [
                    Checkbox(
                      value: legalchargereceive.toLowerCase() == 'yes'
                          ? true
                          : false,
                      onChanged: isUpdating
                          ? (value) {
                              setState(() {
                                if (value == true) {
                                  legalchargereceive = "yes";
                                } else {
                                  legalchargereceive = "no";
                                }
                              });
                            }
                          : null,
                    ),
                    const Text("Yes"),
                    Checkbox(
                      value: legalchargereceive.toLowerCase() == 'no'
                          ? true
                          : false,
                      onChanged: isUpdating
                          ? (value) {
                              setState(() {
                                if (value == true) {
                                  legalchargereceive = "no";
                                } else {
                                  legalchargereceive = "yes";
                                }
                              });
                            }
                          : null,
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
                      value: agreementHandover.toLowerCase() == 'yes'
                          ? true
                          : false,
                      onChanged: isUpdating
                          ? (value) {
                              setState(() {
                                if (value == true) {
                                  agreementHandover = "yes";
                                } else {
                                  agreementHandover = "no";
                                }
                              });
                            }
                          : null,
                    ),
                    const Text("Yes"),
                    Checkbox(
                      value: agreementHandover.toLowerCase() == 'no'
                          ? true
                          : false,
                      onChanged: isUpdating
                          ? (value) {
                              setState(() {
                                if (value == true) {
                                  agreementHandover = "no";
                                } else {
                                  agreementHandover = "yes";
                                }
                              });
                            }
                          : null,
                    ),
                    const Text("No"),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Show file upload option if "Yes" is selected
            if (agreementHandover.toLowerCase() == "yes") ...[
              const Text(
                "Upload Agreement Files:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(Icons.description, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(file.name)),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
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
            const SizedBox(height: 16),

            // Booking Status Section
            Row(
              children: [
                const Text("Booking Status"),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            // const Spacer(),

            const SizedBox(height: 16),

            DropdownButton<String>(
              hint: const Text('Select Booking Type'),
              value: selectedBookingType,
              items: [
                DropdownMenuItem(
                  value: 'EOI',
                  child: const Text('EOI'),
                ),
                DropdownMenuItem(
                  value: 'Confirm Booking',
                  child: const Text('Confirm Booking'),
                ),
              ],
              onChanged: isUpdating
                  ? (value) {
                      setState(() {
                        selectedBookingType = value;
                        amountController.clear();
                        if (value == 'EOI') {
                          _calculateAmounts(isEOI: true);
                          isConfirmBookingVisible =
                              false; // Show only EOI section initially
                        } else if (value == 'Confirm Booking') {
                          _calculateAmounts(isEOI: false);
                          isConfirmBookingVisible =
                              true; // Show only Confirm Booking section
                        }
                      });
                    }
                  : null,
            ),

            const SizedBox(height: 16),

            if (isBookingDetailsVisible) ...[
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
                              decoration: InputDecoration(
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
                              items: [
                                DropdownMenuItem(
                                  value: 'Government Account',
                                  child: const Text('Government Account'),
                                ),
                                DropdownMenuItem(
                                  value: 'Business Account',
                                  child: const Text('Business Account'),
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
                          icon: Icon(Icons.add, color: Colors.blue),
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
                              decoration: InputDecoration(
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
                                    const EdgeInsets.symmetric(vertical: 10.0),
                              ),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            itemHeight: 70,
                            hint: const Text('Booking Account'),
                            value: selectedBookingAccount,
                            items: [
                              DropdownMenuItem(
                                value: 'Government Account',
                                child: const Text('Government Account'),
                              ),
                              DropdownMenuItem(
                                value: 'Business Account',
                                child: const Text('Business Account'),
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
            ],

            DropdownButtonFormField<Employee>(
              value: postSales.contains(selectedPostSalesExecutives)
                  ? selectedPostSalesExecutives
                  : null,
              decoration: InputDecoration(
                labelText: 'Assign to',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              items: postSales.map((postSaleExecutive) {
                return DropdownMenuItem<Employee>(
                    value: postSaleExecutive,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${postSaleExecutive.firstName} ${postSaleExecutive.lastName}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Flexible(
                            child: Text(
                          "(${postSaleExecutive.designation?.designation ?? "NA"})",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 12),
                        )),
                      ],
                    ));
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedPostSalesExecutives = newValue;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a Post Sales Executive';
                }
                return null;
              },
              isExpanded: true,
            ),
            if (isUpdating) _buildUpdateCancelButtonRow(),
          ],
        ),
      ),
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
              onPressed: isUpdating
                  ? () => _pickFilesForField(label, isSingle, applicantIndex)
                  : null,
            ),
          ],
        ),
        if (files.isNotEmpty)
          ...files.map((file) => ListTile(
                leading: const Icon(Icons.description),
                title: Text(path.basename(file.path)),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: isUpdating
                      ? () => _removeFile(label, file, applicantIndex)
                      : null,
                ),
              )),
      ],
    );
  }

  Future<void> _pickFilesForField(
      String fieldType, bool isSingle, int applicantIndex) async {
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
              onPressed: isUpdating ? () => _pickPANFile(applicantIndex) : null,
            ),
          ],
        ),
        if (panFiles[applicantIndex].isNotEmpty)
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(path.basename(panFiles[applicantIndex][0].path)),
            trailing: IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed:
                  isUpdating ? () => _removePANFile(applicantIndex) : null,
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
    }
  }

  void _removePANFile(int applicantIndex) {
    setState(() {
      panFiles[applicantIndex].clear();
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
    required String comment,
    required ValueChanged<String>? onCommentChanged,
    required bool isCommentEditable,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Aligns title and checkboxes
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
        Text(
          comment.isNotEmpty
              ? comment
              : "No comments", // Default message if no comment
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        // Only show editable TextField if isCommentEditable is true
        if (isCommentEditable)
          TextField(
            onChanged: onCommentChanged, // Call the provided onCommentChanged
            decoration: const InputDecoration(
              labelText: "Comments",
              border: OutlineInputBorder(),
            ),
          ),
      ],
    );
  }

  Widget _buildUpdateCancelButtonRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isUpdating = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Update',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool outlineEnabled;
  final bool readOnly;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
    this.outlineEnabled = true,
    this.readOnly = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      // initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: outlineEnabled ? const OutlineInputBorder() : InputBorder.none,
      ),
    );
  }
}

class CustomDateTimeField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;

  const CustomDateTimeField({
    required this.label,
    required this.controller,
    required this.enabled,
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
        controller.text = "${dateTime.toLocal()}".split(' ')[0] +
            ' ' +
            pickedTime.format(context);
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
          onTap: enabled ? () => _selectDateTime(context) : null,
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
  final ValueChanged<String?>? onChanged;
  final bool enabled;

  const CustomDropdownField({
    Key? key,
    required this.label,
    required this.items,
    this.initialValue,
    this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: initialValue,
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
