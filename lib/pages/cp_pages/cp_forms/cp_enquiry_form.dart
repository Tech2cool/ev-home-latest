import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:ev_homes/components/cp_videoplayer.dart';

class CpEnquiryFormScreen extends StatefulWidget {
  const CpEnquiryFormScreen({Key? key}) : super(key: key);

  @override
  EnquiryFormScreenState createState() => EnquiryFormScreenState();
}

class EnquiryFormScreenState extends State<CpEnquiryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientPhoneNumberController = TextEditingController();
  final TextEditingController _otherEnquiryController = TextEditingController();
  final TextEditingController _cpEmailController = TextEditingController();

  bool _showOtherEnquiryField = false;
  String _selectedEnquiry = 'Select';
  final List<String> _enquiryOptions = [
    'Select',
    'Tagging Status',
    'Project Information',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _dateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  }

  @override
  void dispose() {
    _dateTimeController.dispose();
    _clientNameController.dispose();
    _clientPhoneNumberController.dispose();
    _otherEnquiryController.dispose();
    _cpEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video background
          const CpVideoplayer(),
          // Content
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  title: const Text('Enquiry Form'),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildDateTimePicker(),
                            const SizedBox(height: 16),
                            _buildTextFormField(
                              controller: _clientNameController,
                              label: 'Client Name',
                              validator: (value) => value!.isEmpty ? 'Please enter client name' : null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextFormField(
                              controller: _clientPhoneNumberController,
                              label: 'Client Phone Number',
                              keyboardType: TextInputType.phone,
                              validator: (value) => value!.isEmpty ? 'Please enter phone number' : null,
                            ),
                            const SizedBox(height: 16),
                            _buildEnquiryDropdown(),
                            const SizedBox(height: 16),
                            if (_showOtherEnquiryField)
                              _buildTextFormField(
                                controller: _otherEnquiryController,
                                label: 'Other Enquiry',
                                validator: (value) => value!.isEmpty ? 'Please specify your enquiry' : null,
                              ),
                            const SizedBox(height: 16),
                            _buildTextFormField(
                              controller: _cpEmailController,
                              label: 'CP Email',
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => !value!.contains('@') ? 'Please enter a valid email' : null,
                            ),
                            const SizedBox(height: 32),
                            _buildSubmitButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          final TimeOfDay? timePicked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (timePicked != null) {
            setState(() {
              _dateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(
                DateTime(picked.year, picked.month, picked.day, timePicked.hour, timePicked.minute),
              );
            });
          }
        }
      },
      child: IgnorePointer(
        child: TextFormField(
          controller: _dateTimeController,
          decoration: InputDecoration(
            labelText: 'Date & Time',
            suffixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildEnquiryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedEnquiry,
      items: _enquiryOptions.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedEnquiry = newValue!;
          _showOtherEnquiryField = _selectedEnquiry == 'Other';
        });
      },
      decoration: InputDecoration(
        labelText: 'Enquiry About',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
      ),
      validator: (value) => value == 'Select' ? 'Please select an enquiry type' : null,
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF042630),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Submit',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with submission
      _showSuccessSnackBar();
      // Navigate to the next screen or perform other actions
      // For now, we'll just print the form data
      print('Form submitted');
      print('Date & Time: ${_dateTimeController.text}');
      print('Client Name: ${_clientNameController.text}');
      print('Phone Number: ${_clientPhoneNumberController.text}');
      print('Enquiry: $_selectedEnquiry');
      if (_showOtherEnquiryField) {
        print('Other Enquiry: ${_otherEnquiryController.text}');
      }
      print('CP Email: ${_cpEmailController.text}');
    }
  }

  void _showSuccessSnackBar() {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success!',
        message: 'Your enquiry has been submitted successfully.',
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

