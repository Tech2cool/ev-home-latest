import 'package:dropdown_search/dropdown_search.dart';
import 'package:ev_homes/components/searchable_dropdown.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/channel_partner.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:provider/provider.dart';

class EditClientTaggingForm extends StatefulWidget {
  final Lead lead;
  const EditClientTaggingForm({super.key, required this.lead});

  @override
  State<EditClientTaggingForm> createState() => _EditClientTaggingFormState();
}

class _EditClientTaggingFormState extends State<EditClientTaggingForm> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _validTillDateController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _altPhoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpRemarkController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  DateTime? _selectedDate;

  bool iConfirm = false;
  bool isLoading = false;
  List<OurProject> selectedProject = [];
  List<String> selectedRequirement = [];
  bool _showClientInfo = false;
  bool _showCPDetails = false;
  bool _showTLDetails = false;
  String selectedStatus = "pending";
  String selectedIntrestedStatus = "cold";
  DateTime startDate = DateTime.now();
  DateTime validTill = DateTime.now().add(const Duration(days: 60));
  Employee? _selectedTeamLeader;

  ChannelPartner? selectedChannelPartner;
  // Employee? selectedAnalyser;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    startDate = now;
    validTill = now.add(const Duration(days: 60));
    _startDateController.text = DateFormat('yyyy-MM-dd HH:mm').format(now);
    _validTillDateController.text = DateFormat('yyyy-MM-dd HH:mm').format(
      now.add(const Duration(days: 60)),
    );
    _onRefresh();
    startDate = widget.lead.startDate ?? now;
    validTill = widget.lead.validTill ?? validTill;
    _startDateController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(widget.lead.startDate ?? now);
    _validTillDateController.text = DateFormat('yyyy-MM-dd HH:mm').format(
      widget.lead.validTill ?? validTill,
    );
    _firstNameController.text = widget.lead.firstName ?? "";
    _lastNameController.text = widget.lead.lastName ?? "";
    _emailController.text = widget.lead.email ?? '';
    _phoneController.text = widget.lead.phoneNumber.toString();
    _altPhoneController.text = widget.lead.altPhoneNumber?.toString() ?? '';
    selectedProject = widget.lead.project;
    selectedRequirement = widget.lead.requirement;
    selectedChannelPartner = widget.lead.channelPartner;
    _selectedTeamLeader = widget.lead.teamLeader;
    selectedStatus = widget.lead.approvalStatus ?? "pending";
    selectedIntrestedStatus = widget.lead.interestedStatus ?? "cold";
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
        settingProvider.getOurProject(),
        settingProvider.getClosingManagers(),
        settingProvider.getChannelPartners(),
      ]);
    } catch (e) {
      // Handle any errors if needed
      print('Error during refresh: $e');
    } finally {
      // Ensure isLoading is set to false in both success and error cases
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime initialDate = _selectedDate ?? today;
    // print(today);
    // Date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(today.year - 100),
      lastDate: today,
    );

    if (pickedDate != null) {
      // print(" picked $pickedDate");
      // Time picker
      if (context.mounted) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          // print("pickedtime not null");
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
            _startDateController.text = DateFormat("yyyy-MM-dd HH:mm").format(
              _selectedDate!,
            );
            startDate = _selectedDate!;
            validTill = _selectedDate!.add(const Duration(days: 60));
            _validTillDateController.text =
                DateFormat('yyyy-MM-dd HH:mm').format(
              _selectedDate!.add(const Duration(days: 60)),
            );
          });
        }
      }
      // print(" final $_selectedDate");
      // print(" final ${_startDateController.text}");
    }
  }

  void _handleOnSubmit() async {
    if (selectedProject.isEmpty || selectedRequirement.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all Fields."),
        ),
      );
      return;
    }
    if (!iConfirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Confirm details first."),
        ),
      );
      return;
    }
    // if (_selectedTeamLeader != null && selectedStatus != "approved") {
    //   Helper.showCustomSnackBar("Only applicable if Approved");
    // }
    setState(() {
      isLoading = true;
    });
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    try {
      Lead newLead = Lead(
        id: widget.lead.id,
        email: _emailController.text.trim(),
        project: selectedProject,
        requirement: selectedRequirement,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        altPhoneNumber: int.tryParse(_altPhoneController.text),
        countryCode: "+91",
        phoneNumber: int.tryParse(_phoneController.text),
        startDate: startDate,
        address: _addressController.text,
        validTill: validTill,
        status: selectedStatus,
        approvalStatus: selectedStatus,

        // approvalDate: selectedStatus == "approved" ? DateTime.now() : null,
        dataAnalyzer: widget.lead.dataAnalyzer,
        channelPartner: selectedChannelPartner,
        remark: _cpRemarkController.text,
        updateHistory: widget.lead.updateHistory,
        callHistory: widget.lead.callHistory,
        approvalDate: widget.lead.approvalDate,
        stage: widget.lead.stage,
        teamLeader: _selectedTeamLeader,
      );

      Map<String, dynamic> leadJson = newLead.toJson();

      // if (newLead.channelPartner != null) {
      //   leadJson["channelPartner"] = newLead.channelPartner!.id;
      // }
      await settingProvider.updateLeadById(widget.lead.id, leadJson);
    } catch (e) {
      //
    }
    // Simulate form submission
    // await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text("Lead Created"),
    //   ),
    // );
    Navigator.of(context).pop();
    // await _generatePDF();
  }

  // Future<void> _generatePDF() async {
  //   final pdf = pw.Document();

  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Text(
  //               'Client Tagging Form',
  //               style: pw.TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: pw.FontWeight.bold,
  //               ),
  //             ),
  //             pw.SizedBox(height: 20),
  //             pw.Text('Tagged Date: ${_startDateController.text}'),
  //             pw.Text('Valid Till: ${_validTillDateController.text}'),
  //             pw.Text(
  //               'Client Name: ${_firstNameController.text} ${_lastNameController.text}',
  //             ),
  //             pw.Text('Phone Number: ${_phoneController.text}'),
  //             pw.Text('Alternate Phone: ${_altPhoneController.text}'),
  //             pw.Text('Email: ${_emailController.text}'),
  //             pw.Text('Selected Projects: ${selectedProject.join(", ")}'),
  //             pw.Text('Requirements: ${selectedRequirement.join(", ")}'),
  //             pw.Text('Remarks: ${_cpRemarkController.text}'),
  //             pw.Text('Status: $selectedStatus'),
  //           ],
  //         );
  //       },
  //     ),
  //   );

  //   final output = await getTemporaryDirectory();
  //   final file = File("${output.path}/client_tagging_form.pdf");
  //   await file.writeAsBytes(await pdf.save());

  //   await OpenFile.open(file.path);
  // }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final channelPartners = settingProvider.channelPartners;
    final requirements = settingProvider.requirements;
    final ourProjects = settingProvider.ourProject;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Client Tagging Form'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FormHolder(
                    title: "Client Details",
                    selected: _showClientInfo,
                    onTap: () {
                      setState(() {
                        _showClientInfo = !_showClientInfo;
                      });
                    },
                    childrens: [
                      if (_showClientInfo) ...[
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _startDateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Tagged Date',
                              prefixIcon: const Icon(Icons.calendar_today),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
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
                        ),

                        // CustomTextField(
                        //   controller: _startDateController,
                        //   label: "Tagged Date",
                        //   onTap: () => _selectDate(context),
                        //   readOnly: false,
                        //   textColor: Colors.black.withAlpha(100),
                        //   borderColor: Colors.grey.withAlpha(100),
                        //   fillColor: Colors.grey.withAlpha(60),
                        // ),
                        CustomTextField(
                          controller: _validTillDateController,
                          label: "Valid Till",
                          onTap: () {},
                          readOnly: true,
                          textColor: Colors.black.withAlpha(100),
                          borderColor: Colors.grey.withAlpha(100),
                          fillColor: Colors.grey.withAlpha(60),
                        ),
                        CustomTextField(
                          controller: _firstNameController,
                          label: "Client First Name",
                          onTap: () {},
                        ),
                        CustomTextField(
                          controller: _lastNameController,
                          label: "Client Last Name",
                          onTap: () {},
                        ),
                        CustomTextField(
                          controller: _phoneController,
                          label: "Client Phone Number",
                          prefixWidget: const Text("+91 "),
                          keyboardType: TextInputType.phone,
                          onTap: () {},
                        ),
                        CustomTextField(
                          controller: _altPhoneController,
                          label: "Alternate Phone Number",
                          keyboardType: TextInputType.phone,
                          onChange: (value) {},
                          onTap: () {},
                        ),
                        CustomTextField(
                          controller: _emailController,
                          label: "Email",
                          keyboardType: TextInputType.emailAddress,
                          onChange: (value) {},
                          onTap: () {},
                        ),
                        //our projects
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownSearch<OurProject>.multiSelection(
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
                                    ? RichText(
                                        text: TextSpan(
                                          text: 'Select Project',
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
                                      )
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
                        ),
                        const SizedBox(height: 8),
                        //requirements
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownSearch<String>.multiSelection(
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
                                    ? RichText(
                                        text: TextSpan(
                                          text: 'Choice of Apartment',
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
                                      )
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
                        ),
                        const SizedBox(height: 8),

                        CustomTextField(
                          controller: _addressController,
                          label: "Client Address",
                          maxLines: 3,
                          keyboardType: TextInputType.text,
                          onChange: (value) {},
                          onTap: () {},
                        ),
                        CustomTextField(
                          controller: _cpRemarkController,
                          label: "Remarks",
                          maxLines: 3,
                          keyboardType: TextInputType.text,
                          onChange: (value) {},
                          onTap: () {},
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            value: selectedStatus,
                            items: const [
                              DropdownMenuItem(
                                value: 'approved',
                                child: Text('Approved'),
                              ),
                              DropdownMenuItem(
                                value: 'pending',
                                child: Text('Pending'),
                              ),
                              DropdownMenuItem(
                                value: 'rejected',
                                child: Text('Rejected'),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedStatus = newValue!;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Intrested Status',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            value: selectedIntrestedStatus,
                            items: const [
                              DropdownMenuItem(
                                value: 'cold',
                                child: Text('Cold'),
                              ),
                              DropdownMenuItem(
                                value: 'hot',
                                child: Text('Hot'),
                              ),
                              DropdownMenuItem(
                                value: 'warm',
                                child: Text('Warm'),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedIntrestedStatus = newValue!;
                              });
                            },
                          ),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 20),
                  FormHolder(
                    title: "Channel Partner Details",
                    selected: _showCPDetails,
                    onTap: () {
                      setState(() {
                        _showCPDetails = !_showCPDetails;
                      });
                    },
                    childrens: [
                      if (_showCPDetails) ...[
                        const SizedBox(height: 20),
                        SearchableDropdown<ChannelPartner>(
                          initialSelection: selectedChannelPartner,
                          items: channelPartners,
                          labelBuilder: (ChannelPartner? emp) {
                            if (emp == null) {
                              return "";
                            }
                            final name =
                                "${emp.firstName} ${emp.lastName} (${emp.firmName ?? ''})";
                            return name;
                          },
                          label: "Channel Partner",
                          onChanged: (value) {
                            setState(() {
                              selectedChannelPartner = value!;
                            });
                          },
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 16),
                  FormHolder(
                    title: "Team Leader Details",
                    selected: _showTLDetails,
                    onTap: () {
                      setState(() {
                        _showTLDetails = !_showTLDetails;
                      });
                    },
                    childrens: [
                      if (_showTLDetails != null) ...[
                        const SizedBox(height: 16),
                        DropdownButtonFormField<Employee>(
                          value: _selectedTeamLeader,
                          decoration: InputDecoration(
                            labelText: 'Team Leader',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          items:
                              settingProvider.closingManagers.map((teamleader) {
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
                              _selectedTeamLeader = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a Team Leader';
                            }
                            return null;
                          },
                          isExpanded: true,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Confirm Details"),
                      OldStyleSwitch(
                        onChanged: (val) {
                          setState(() {
                            iConfirm = val;
                          });
                        },
                        initialValue: iConfirm,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                          onPressed: _handleOnSubmit,
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        if (isLoading) ...[
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator.adaptive(),
          ),
        ]
      ],
    );
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final Function() onTap;
  final bool? readOnly;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Color? textColor;
  final Color? borderColor;
  final Color? fillColor;
  final Function(String?)? validator;
  final Function(String)? onChange;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.suffixIcon,
    required this.onTap,
    this.readOnly,
    this.keyboardType,
    this.textColor,
    this.borderColor,
    this.maxLines,
    this.fillColor,
    this.suffixWidget,
    this.hint,
    this.prefixWidget,
    this.validator,
    this.onChange,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? errorMessage;
  bool _isChecking = false;

  void _validateInput(String value) async {
    if (_isChecking) return;

    setState(() {
      _isChecking = true;
    });

    if (widget.onChange != null) {
      widget.onChange!(value);
    }

    await Future.delayed(const Duration(milliseconds: 500));

    if (widget.validator != null) {
      setState(() {
        errorMessage = widget.validator!(value);
      });
    }

    setState(() {
      _isChecking = false;
    });
  }

  void _onFocusChange(bool hasFocus) {
    if (!hasFocus) {
      _validateInput(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Focus(
        onFocusChange: _onFocusChange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.fillColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                controller: widget.controller,
                onChanged: (value) {
                  _validateInput(value);
                },
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: widget.hint,
                  fillColor: widget.fillColor,
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 63, 63, 63),
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                  prefix: widget.prefixWidget,
                  suffixIcon: widget.suffixWidget ??
                      (widget.suffixIcon != null
                          ? IconButton(
                              icon: Icon(widget.suffixIcon),
                              onPressed: widget.onTap,
                            )
                          : null),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: errorMessage != null
                          ? Colors.red
                          : (widget.borderColor ??
                              const Color.fromARGB(255, 63, 63, 63)),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: errorMessage != null
                          ? Colors.red
                          : (widget.borderColor ??
                              const Color.fromARGB(255, 63, 63, 63)),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: errorMessage != null
                          ? Colors.red
                          : (widget.borderColor ??
                              const Color.fromARGB(255, 63, 63, 63)),
                    ),
                  ),
                  contentPadding:
                      const EdgeInsetsDirectional.fromSTEB(22, 17, 22, 17),
                ),
                style: TextStyle(
                  color:
                      widget.textColor ?? const Color.fromARGB(255, 63, 63, 63),
                  fontSize: 14.0,
                ),
                keyboardType: widget.keyboardType,
                readOnly: widget.readOnly ?? false,
                maxLines: widget.maxLines,
              ),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FormHolder extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;
  final List<Widget> childrens;

  const FormHolder({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    required this.childrens,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  selected
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
        ),
        if (selected) ...childrens,
      ],
    );
  }
}

class OldStyleSwitch extends StatelessWidget {
  final bool initialValue;
  final Function(bool) onChanged;

  const OldStyleSwitch({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: initialValue,
      onChanged: onChanged,
      activeColor: Colors.green,
    );
  }
}

class CustomTile extends StatelessWidget {
  final String title;
  final String subTitle;
  const CustomTile({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            subTitle,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
