import 'dart:async';
import 'dart:io';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/models/site_visit.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddSiteVisitFormPage extends StatefulWidget {
  final Lead? lead;
  final String? status;
  const AddSiteVisitFormPage({super.key, this.lead, this.status});

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
  TextEditingController otpController = TextEditingController();
  MultiSelectController<OurProject> multiselectController =
      MultiSelectController<OurProject>();
  MultiSelectController<String> multiselectController1 =
      MultiSelectController<String>();
  MultiSelectController<Employee> multiselectController2 =
      MultiSelectController<Employee>();
  final ImagePicker imagePicker = ImagePicker();

  Timer? _periodicTimer;
  int _counter = 10;
  bool showTimer = false;
  String? _otpMessage;
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  String? selectedPrefix = 'Mr.';
  final List<String> prefixes = ['Mr.', 'Ms.', 'Miss', 'Dr.'];
  String? selectedAddress;
  bool isLoading = false;
  final List fallbackRequirements = const [
    '1RK',
    '1BHK',
    '2BHK',
    '3BHK',
    '4BHK',
    'Jodi',
  ];
  final List<OurProject> fallbackProjects = [
    OurProject(
      id: "project-ev-9-square-vashi-sector-9",
      name: "EV9 Square",
    ),
    OurProject(
      id: "project-ev-10-marina-bay-vashi-sector-10",
      name: "EV 10 Marina Bay",
    ),
  ];
  bool resendPass = false;
  String? _selectedSource;
  String? selectedVisit;
  Employee? _selectedSeniorClosingManager;
  List<Employee> _selectedSalesManagers1 = [];
  List<String> selectedRequirement = [];
  List<String> listofSource = ['Walk-in', 'CP', 'Ref'];
  List<String> listofType = ['visit', 'revisit', "virtual-meeting"];
  Employee? _selectedDataEntryUser;
  OurProject? selectedProj;
  File? selectedProof;

  List<OurProject> selectedProject = [];
  // final List<String> projects = [
  //   '10 Marina Bay',
  //   '9 Square',
  // ];
  String? selectedassignName;
  List<String> selectedsubordinateassignNames = [];

  void onSelectProof() async {
    final XFile? returnedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (returnedImage == null) {
      return;
    }

    setState(() {
      selectedProof = File(returnedImage.path);
    });
  }

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
            _dateController.text = DateFormat("yyyy-MM-dd HH:mm").format(
              _selectedDate!,
            );
          });
        }
      }
    }
  }

  Future<void> onPressSubmit() async {
    if (selectedProject.isEmpty ||
        selectedRequirement.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        _selectedSeniorClosingManager == null ||
        _selectedSalesManagers1.isEmpty ||
        _selectedDate == null ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        _selectedDataEntryUser == null ||
        selectedPrefix == null) {
      Helper.showCustomSnackBar("All Fields Required");
      return;
    }
    await generateOtp();
  }

  void updatMessageOtp(String? message) {
    setState(() {
      _otpMessage = message;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _otpMessage = null;
      });
    });
  }

  Future<void> generateOtp([bool resent = false]) async {
    try {
      setState(() {
        isLoading = true;
      });
      final recievedOtp = await ApiService().sentOtpSiteVisit({
        "project": selectedProj!.id!,
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "phoneNumber": phoneController.text,
        "email": emailController.text.isEmpty ? null :emailController.text ,
        "closingManager": _selectedSeniorClosingManager!.id,
      });
      if (recievedOtp != null) {
        _showOtpVerificationDialog();
        if (resent) {
          updatMessageOtp("Otp resent Successfullly");
        } else {
          updatMessageOtp("Otp Sent Successfullly");
        }
      } else {
        Helper.showCustomSnackBar("Unable send OTP at moment");
      }
    } catch (e) {
      Helper.showCustomSnackBar("Failed To send OTP");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  _showOtpVerificationDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.4,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Otp sent to whatsapp Number",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Text(
                  Helper.maskPhoneNumber(phoneController.text),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // if (_otpMessage != null)
                //   Text(
                //     _otpMessage!,
                //     textAlign: TextAlign.center,
                //     style: const TextStyle(
                //       fontWeight: FontWeight.w500,
                //       color: Colors.blue,
                //     ),
                //   ),
                const SizedBox(height: 10),
                PinCodeTextField(
                  controller: otpController,
                  appContext: context,
                  length: 6,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 40,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: const Color(0xFFFF745C),
                    inactiveColor: const Color.fromARGB(255, 238, 136, 118),
                    selectedColor: const Color(0xFFFF745C),
                  ),
                  keyboardType: TextInputType.number,
                  enableActiveFill: true,
                ),

                // TextFormField(
                //   keyboardType: TextInputType.number,
                //   controller: otpController,
                //   maxLength: 6,
                //   decoration: InputDecoration(
                //     hintText: "6 Digit OTP",
                //     enabledBorder: OutlineInputBorder(
                //       borderSide: BorderSide(
                //         color: Colors.black.withOpacity(0.2),
                //       ),
                //       borderRadius: BorderRadius.circular(5),
                //     ),
                //     border: OutlineInputBorder(
                //       borderSide: BorderSide(
                //         color: Colors.black.withOpacity(0.2),
                //       ),
                //       borderRadius: BorderRadius.circular(5),
                //     ),
                //     errorBorder: OutlineInputBorder(
                //       borderSide: BorderSide(
                //         color: Colors.red.withOpacity(0.4),
                //       ),
                //       borderRadius: BorderRadius.circular(5),
                //     ),
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[300],
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await onVerfiredOrSkipOtp();
                        },
                        child: const Text(
                          "Skip",
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
                        onPressed: () async {
                          final resp = await ApiService().verifySiteVisitOtp(
                            phoneController.text,
                            otpController.text,
                            emailController.text,
                          );
                          if (resp == false) return;

                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                          // print("otp ok: $resp");
                          await onVerfiredOrSkipOtp(true);
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
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => generateOtp(true),
                    child: const Text(
                      "Resent OTP?",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
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
        settingProvider.getDataEntryEmployess(),
        settingProvider.getClosingManagers(),
        settingProvider.getRequirements(),
        settingProvider.getOurProject(),
        // settingProvider.getTeamLeaders(),
        // settingProvider.getSeniorClosingManagers(),
        settingProvider.getSalesManager(),
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

  Future<void> onVerfiredOrSkipOtp([bool verified = false]) async {
    try {
      // print("in ok: $verified");
      // Simulate successful submission
      setState(() {
        isLoading = true;
      });
      final settingProvider = Provider.of<SettingProvider>(
        context,
        listen: false,
      );
      final newVisit = SiteVisit(
        visitType: selectedVisit,
        projects: selectedProject,
        choiceApt: selectedRequirement,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        closingManager: _selectedSeniorClosingManager,
        closingTeam: _selectedSalesManagers1,
        date: _selectedDate,
        phoneNumber: int.parse(phoneController.text),
        email: emailController.text.trim(),
        residence: addressController.text,
        dataEntryBy: _selectedDataEntryUser,
        namePrefix: selectedPrefix,
        countryCode: "+91",
        verified: verified,
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
      if (widget.lead != null) {
        visitMap['lead'] = widget.lead!.id;
      }
      if (selectedProj != null) {
        visitMap['location'] = selectedProj!.id!;
      }

      try {
        if (selectedProof != null) {
          final uShowcaseImage = await ApiService().uploadFile(selectedProof!);
          if (uShowcaseImage != null) {
            visitMap['virtualMeetingDoc'] = uShowcaseImage.downloadUrl;
          }
        }

        await settingProvider.addSiteVisit(visitMap);
      } catch (e) {
        // Helper.showCustomSnackBar("Error Adding Site Visit");
        // print(e);
      } finally {
        setState(() {
          isLoading = false;
        });
        // if (mounted) {
        //   Navigator.of(context).pop();
        // }
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
                const Text("Site visit added Succesfully"),
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

  @override
  void initState() {
    super.initState();
    final DateTime today = DateTime.now();

    _selectedDate = today;

    _dateController.text = DateFormat("dd MMM yy hh:mm a").format(
      DateTime.now(),
    );
    _onRefresh();
    selectedVisit = widget.status;
    firstNameController.text = widget.lead?.firstName ?? "";
    lastNameController.text = widget.lead?.lastName ?? "";
    phoneController.text = widget.lead?.phoneNumber?.toString() ?? "";
    emailController.text = widget.lead?.email ?? "";
    addressController.text = widget.lead?.address ?? "";
    selectedProject = widget.lead?.project ?? [];
    selectedRequirement = widget.lead?.requirement ?? [];
    _selectedSeniorClosingManager = widget.lead?.teamLeader;
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
    otpController.dispose();
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
    final closingMangers = settingProvider.closingManagers;
    final dataEntryUsers = settingProvider.dataEntryUsers;
    final salesManager = settingProvider.salesManager;
    final requirements = settingProvider.requirements;
    final ourProjects = settingProvider
        .ourProject; /* settingProvider.ourProject.isNotEmpty
        ? settingProvider.ourProject
        : fallbackProjects;*/

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
                    const SizedBox(
                      height: 16,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedVisit,
                            decoration: InputDecoration(
                              labelText: 'Select Visit Type',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            items: listofType.map((visit) {
                              return DropdownMenuItem<String>(
                                value: visit,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        Helper.capitalize(visit),
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
                                selectedVisit = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a Visit Type';
                              }
                              return null;
                            },
                            isExpanded: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (selectedVisit == "virtual-meeting") ...[
                      const SizedBox(
                        height: 16,
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Select Virtual meeting Image',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                MaterialButton(
                                  color: Colors.blue,
                                  onPressed: onSelectProof,
                                  child: const Text(
                                    "Browse",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (selectedProof != null) ...[
                            Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 60,
                                  child: Image.file(
                                    selectedProof!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text("Selected Image"),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedProof = null;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(width: 16),
                          ],
                        ],
                      ),
                    ],
                    // const SizedBox(height: 16),

                    DropdownButtonFormField<OurProject>(
                      decoration: InputDecoration(
                        label: RichText(
                          text: TextSpan(
                            text: 'Select location',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                            children: const [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                ),
                              ),
                            ],
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
                      value: selectedProj,
                      items: ourProjects.map((OurProject project) {
                        return DropdownMenuItem<OurProject>(
                          value: project,
                          child: Text(project.name ?? ""),
                        );
                      }).toList(),
                      onChanged: (OurProject? newValue) {
                        setState(() {
                          selectedProj = newValue;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Date of Birth
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: RichText(
                          text: TextSpan(
                            text: 'Date & Time',
                            style: TextStyle(
                              color: Colors.grey[700], // Label text color
                              fontSize: 16,
                            ),
                            children: const [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red, // Asterisk color
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                          vertical: 15,
                          horizontal: 10,
                        ),
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
                            label: RichText(
                              text: TextSpan(
                                text: 'First Name',
                                style: TextStyle(
                                  color: Colors.grey[700], // Label text color
                                  fontSize: 16,
                                ),
                                children: const [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red, // Asterisk color
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                            label: RichText(
                              text: TextSpan(
                                text: 'Last Name',
                                style: TextStyle(
                                  color: Colors.grey[700], // Label text color
                                  fontSize: 16,
                                ),
                                children: const [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red, // Asterisk color
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                          maxLength: 10,
                          decoration: InputDecoration(
                            label: RichText(
                              text: TextSpan(
                                text: 'Phone',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                ),
                                children: const [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.red.withOpacity(0.4),
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
                            label: RichText(
                              text: TextSpan(
                                text: 'Email',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                ),
                                // children: const [
                                //   TextSpan(
                                //     text: '*',
                                //     style: TextStyle(
                                //       color: Colors.red,
                                //       fontSize: 20,
                                //     ),
                                //   ),
                                // ],
                              ),
                            ),
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
                            label: RichText(
                              text: TextSpan(
                                text: 'Residence',
                                style: TextStyle(
                                  color: Colors.grey[700], // Label text color
                                  fontSize: 16,
                                ),
                                children: const [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red, // Asterisk color
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                        //our projects
                        DropdownSearch<OurProject>.multiSelection(
                          mode: Mode.form,
                          items: (f, cs) => ourProjects,
                          compareFn: (item1, item2) {
                            return item1.id == item2.id;
                          },
                          itemAsString: (item) {
                            return item.name ?? "";
                          },
                          onSaved: (newValue) {
                            setState(() {
                              selectedProject = newValue ?? [];
                            });
                          },
                          selectedItems: selectedProject,
                          onChanged: (value) {
                            setState(() {
                              selectedProject = value;
                            });
                          },
                          popupProps: PopupPropsMultiSelection.menu(
                            fit: FlexFit.loose,
                            showSelectedItems: true,
                            itemBuilder:
                                (context, item, isDisabled, isSelected) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item.name ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                            // showSearchBox: true,
                            // searchFieldProps: TextFieldProps()
                          ),
                          dropdownBuilder: (ctx, selectedItem) {
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              leading: const Icon(
                                CupertinoIcons.building_2_fill,
                                size: 20,
                              ),
                              title: selectedItem.isEmpty
                                  ? const Text("Select Projects")
                                  : Text(
                                      selectedItem
                                          .map((item) => item.name ?? "")
                                          .join(", "),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            );
                          },
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0),
                              // hintText: "Select Projects",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        //requirements
                        DropdownSearch<String>.multiSelection(
                          mode: Mode.form,
                          items: (f, cs) => requirements,
                          compareFn: (item1, item2) {
                            return item1 == item2;
                          },
                          itemAsString: (item) {
                            return item;
                          },
                          onSaved: (newValue) {
                            setState(() {
                              selectedRequirement = newValue ?? [];
                            });
                          },
                          selectedItems: selectedRequirement,
                          onChanged: (value) {
                            setState(() {
                              selectedRequirement = value;
                            });
                          },
                          popupProps: PopupPropsMultiSelection.menu(
                            fit: FlexFit.loose,
                            showSelectedItems: true,
                            itemBuilder:
                                (context, item, isDisabled, isSelected) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                            // showSearchBox: true,
                            // searchFieldProps: TextFieldProps()
                          ),
                          dropdownBuilder: (ctx, selectedItem) {
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              leading: const Icon(
                                CupertinoIcons.building_2_fill,
                                size: 20,
                              ),
                              title: selectedItem.isEmpty
                                  ? const Text("Choice of Apartment")
                                  : Text(
                                      selectedItem
                                          .map((item) => item)
                                          .join(", "),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            );
                          },
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0),
                              // hintText: "Select Projects",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
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
                          ],
                        ),
                        const SizedBox(height: 16),
                        //closing manager
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<Employee>(
                                value: _selectedSeniorClosingManager,
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
                                    _selectedSeniorClosingManager = newValue;
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
                        const SizedBox(height: 16),
                        //Sales Managers
                        DropdownSearch<Employee>.multiSelection(
                          mode: Mode.form,
                          items: (f, cs) => salesManager,
                          compareFn: (item1, item2) {
                            return item1.id == item2.id;
                          },
                          itemAsString: (item) {
                            return "${item.firstName ?? ""} ${item.lastName ?? ""} (${item.designation?.designation ?? "NA"})";
                          },
                          onSaved: (newValue) {
                            setState(() {
                              _selectedSalesManagers1 = newValue ?? [];
                            });
                          },
                          selectedItems: _selectedSalesManagers1,
                          onChanged: (value) {
                            setState(() {
                              _selectedSalesManagers1 = value;
                            });
                          },
                          popupProps: PopupPropsMultiSelection.menu(
                            fit: FlexFit.loose,
                            showSelectedItems: true,
                            itemBuilder:
                                (context, item, isDisabled, isSelected) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${item.firstName ?? ""} ${item.lastName ?? ""} (${item.designation?.designation ?? "NA"})",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                            // showSearchBox: true,
                            // searchFieldProps: TextFieldProps()
                          ),
                          dropdownBuilder: (ctx, selectedItem) {
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              leading: const Icon(
                                CupertinoIcons.building_2_fill,
                                size: 20,
                              ),
                              title: selectedItem.isEmpty
                                  ? const Text("Sales Managers")
                                  : Text(
                                      selectedItem
                                          .map((item) =>
                                              "${item.firstName ?? ""} ${item.lastName ?? ""} (${item.designation?.designation ?? "NA"})")
                                          .join(", "),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            );
                          },
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0),
                              // hintText: "Select Projects",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
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
                    listOfUser: dataEntryUsers,
                    onSelect: (emp) {
                      setState(() {
                        _selectedDataEntryUser = emp;
                      });
                    },
                  ),
                ),
              ),
            ],
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
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
