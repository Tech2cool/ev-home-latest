import 'package:ev_homes/core/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Client Tagging Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ClientTaggingForm(),
    );
  }
}

class ClientTaggingForm extends StatefulWidget {
  const ClientTaggingForm({super.key});

  @override
  State<ClientTaggingForm> createState() => _ClientTaggingFormState();
}

class _ClientTaggingFormState extends State<ClientTaggingForm> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _validTillDateController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _altPhoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpRemarkController = TextEditingController();
  bool iConfirm = false;
  bool isLoading = false;
  final List myList2 = const ['2BHK', '3BHK'];
  final List myList = const ['Ev 9 Square', 'Ev heart city', 'Marina Bay'];
  List<String> selectedProject = [];
  List<String> selectedRequirement = [];
  bool _showClientInfo = false;
  bool _showCPDetails = false;
  String selectedStatus = "In Progress";

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDateController.text = DateFormat('yyyy-MM-dd HH:mm').format(now);
    _validTillDateController.text = DateFormat('yyyy-MM-dd HH:mm').format(
      now.add(const Duration(days: 60)),
    );
  }

  void _handleOnSubmit() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
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

    // Simulate form submission
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
    Helper.showCustomSnackBar("Lead Created", Colors.green);

    _generatePDF();
  }

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Client Tagging Form',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Tagged Date: ${_startDateController.text}'),
              pw.Text('Valid Till: ${_validTillDateController.text}'),
              pw.Text('Client Name: ${_nameController.text}'),
              pw.Text('Phone Number: ${_phoneController.text}'),
              pw.Text('Alternate Phone: ${_altPhoneController.text}'),
              pw.Text('Email: ${_emailController.text}'),
              pw.Text('Selected Projects: ${selectedProject.join(", ")}'),
              pw.Text('Requirements: ${selectedRequirement.join(", ")}'),
              pw.Text('Remarks: ${_cpRemarkController.text}'),
              pw.Text('Status: $selectedStatus'),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/client_tagging_form.pdf");
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
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
                        CustomTextField(
                          controller: _startDateController,
                          label: "Tagged Date",
                          onTap: () {},
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
                          controller: _nameController,
                          label: "Client Name",
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
                          child: MultiSelectDropdown.simpleList(
                            list: myList,
                            boxDecoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            initiallySelected: selectedProject,
                            checkboxFillColor: Colors.grey.withOpacity(0.3),
                            splashColor: Colors.grey.withOpacity(0.3),
                            includeSearch: true,
                            includeSelectAll: true,
                            whenEmpty: "Projects",
                            onChange: (newList) {
                              setState(() {
                                selectedProject =
                                    newList.map((e) => e as String).toList();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: MultiSelectDropdown.simpleList(
                            list: myList2,
                            boxDecoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            initiallySelected: selectedRequirement,
                            checkboxFillColor: Colors.grey.withOpacity(0.3),
                            splashColor: Colors.grey.withOpacity(0.3),
                            includeSearch: true,
                            includeSelectAll: true,
                            whenEmpty: "Requirement",
                            onChange: (newList) {
                              setState(() {
                                selectedRequirement =
                                    newList.map((e) => e as String).toList();
                              });
                            },
                          ),
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
                                  value: 'In Progress',
                                  child: Text('In Progress')),
                              DropdownMenuItem(
                                  value: 'Approved', child: Text('Approved')),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedStatus = newValue!;
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
                        const CustomTile(title: "Name: ", subTitle: "John Doe"),
                        const CustomTile(
                            title: "Phone Number: ",
                            subTitle: "+91 9876543210"),
                        const CustomTile(
                            title: "Email: ", subTitle: "johndoe@example.com"),
                        const CustomTile(
                            title: "Firm name: ", subTitle: "ABC Realty"),
                        const CustomTile(
                            title: "Rera Number: ", subTitle: "RERA123456"),
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
