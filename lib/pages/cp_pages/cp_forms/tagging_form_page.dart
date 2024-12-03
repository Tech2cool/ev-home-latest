import 'package:ev_homes/components/searchable_dropdown.dart';
import 'package:ev_homes/core/models/channel_partner.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:provider/provider.dart';

class ClientTaggingForm extends StatefulWidget {
  const ClientTaggingForm({super.key});

  @override
  State<ClientTaggingForm> createState() => _ClientTaggingFormState();
}

class _ClientTaggingFormState extends State<ClientTaggingForm> {
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
  String selectedStatus = "pending";
  String selectedIntrestedStatus = "cold";
  DateTime startDate = DateTime.now();
  DateTime validTill = DateTime.now().add(const Duration(days: 60));

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
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        // _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        selectedProject.isEmpty ||
        selectedRequirement.isEmpty) {
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

    setState(() {
      isLoading = true;
    });
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );

    Lead newLead = Lead(
      id: "",
      email: _emailController.text.trim(),
      project: selectedProject,
      requirement: selectedRequirement,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      countryCode: "+91",
      phoneNumber: int.parse(_phoneController.text),
      startDate: startDate,
      address: _addressController.text,
      validTill: validTill,
      status: selectedStatus,
      approvalStatus: selectedStatus,
      interestedStatus: selectedIntrestedStatus,
      channelPartner: settingProvider.loggedChannelPartner,
    );
    Map<String, dynamic> leadJson = newLead.toJson();

    if (newLead.channelPartner != null) {
      leadJson["channelPartner"] = newLead.channelPartner!.id;
    }
    try {
      await settingProvider.addLead(leadJson);
    } catch (e) {}
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
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: TextFormField(
                        //     controller: _startDateController,
                        //     readOnly: true,
                        //     decoration: InputDecoration(
                        //       labelText: 'Tagged Date',
                        //       prefixIcon: const Icon(Icons.calendar_today),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(15),
                        //         borderSide: BorderSide(
                        //           color: Colors.grey.withOpacity(0.7),
                        //         ),
                        //       ),
                        //       enabledBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //         borderSide: BorderSide(
                        //           color: Colors.grey.withOpacity(0.4),
                        //         ),
                        //       ),
                        //       contentPadding: const EdgeInsets.symmetric(
                        //           vertical: 15, horizontal: 10),
                        //     ),
                        //     onTap: () => _selectDate(context),
                        //   ),
                        // ),

                        CustomTextField(
                          controller: _startDateController,
                          label: "Tagged Date",
                          onTap: () => _selectDate(context),
                          readOnly: true,
                          textColor: Colors.black.withAlpha(100),
                          borderColor: Colors.grey.withAlpha(100),
                          fillColor: Colors.grey.withAlpha(60),
                        ),
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
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: MultiDropdown<OurProject>(
                            items: [
                              ...settingProvider.ourProject.map(
                                (ele) => DropdownItem(
                                    value: ele, label: ele.name ?? ""),
                              ),
                            ],
                            // controller: multiselectController,
                            enabled: true,
                            searchEnabled: true,
                            chipDecoration: const ChipDecoration(
                              backgroundColor: Colors.greenAccent,
                              wrap: true,
                              runSpacing: 2,
                              spacing: 10,
                            ),
                            fieldDecoration: FieldDecoration(
                              hintText: 'Projects',
                              hintStyle: const TextStyle(color: Colors.black87),
                              prefixIcon:
                                  const Icon(CupertinoIcons.building_2_fill),
                              showClearIcon: false,
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
                            dropdownDecoration: const DropdownDecoration(
                              marginTop: 2,
                              maxHeight: 500,
                              header: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Select Projects',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            dropdownItemDecoration: DropdownItemDecoration(
                              selectedIcon: const Icon(Icons.check_box,
                                  color: Colors.grey),
                              disabledIcon:
                                  Icon(Icons.lock, color: Colors.grey.shade300),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a project';
                              }
                              return null;
                            },
                            onSelectionChange: (selectedItems) {
                              setState(() {
                                selectedProject = selectedItems;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: MultiDropdown<String>(
                            items: [
                              ...settingProvider.requirements.map(
                                (ele) => DropdownItem(value: ele, label: ele),
                              ),
                            ],
                            enabled: true,
                            searchEnabled: false,
                            chipDecoration: const ChipDecoration(
                              backgroundColor: Colors.greenAccent,
                              wrap: true,
                              runSpacing: 2,
                              spacing: 10,
                            ),
                            fieldDecoration: FieldDecoration(
                              labelStyle: TextStyle(fontSize: 30),
                              hintText: 'Requirements',
                              hintStyle: const TextStyle(color: Colors.black87),
                              prefixIcon:
                                  const Icon(CupertinoIcons.building_2_fill),
                              showClearIcon: false,
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
                            dropdownDecoration: const DropdownDecoration(
                              marginTop: 2,
                              maxHeight: 500,
                              header: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Select Apartments',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            dropdownItemDecoration: DropdownItemDecoration(
                              selectedIcon: const Icon(Icons.check_box,
                                  color: Colors.grey),
                              disabledIcon:
                                  Icon(Icons.lock, color: Colors.grey.shade300),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a apartment';
                              }
                              return null;
                            },
                            onSelectionChange: (selectedItems) {
                              setState(() {
                                selectedRequirement = selectedItems;
                              });
                            },
                          ),
                        ),
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
                        CustomTile(
                            title: "Name: ",
                            subTitle:
                                "${settingProvider.loggedChannelPartner?.firstName ?? ""} ${settingProvider.loggedChannelPartner?.lastName ?? ''}"),
                        CustomTile(
                            title: "Phone Number: ",
                            subTitle:
                                "${settingProvider.loggedChannelPartner?.phoneNumber ?? 'NA'}"),
                        CustomTile(
                            title: "Email: ",
                            subTitle:
                                "${settingProvider.loggedChannelPartner?.email ?? 'NA'}"),
                        CustomTile(
                            title: "Firm name: ",
                            subTitle:
                                "${settingProvider.loggedChannelPartner?.firmName ?? 'NA'}"),
                      ]
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
