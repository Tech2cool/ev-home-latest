import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:ev_homes/core/constant/constant.dart';
// import 'package:ev_homes_customer/flutterflow/flutter_flow_theme.dart';
// import 'package:ev_homes_customer/flutterflow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MaterialApp(
    home: EnquiryForm(),
  ));
}

class EnquiryForm extends StatefulWidget {
  const EnquiryForm({super.key});

  @override
  EnquiryFormState createState() => EnquiryFormState();
}

class EnquiryFormState extends State<EnquiryForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientPhoneNumberController =
      TextEditingController();
  final TextEditingController _otherEnquiryController = TextEditingController();
  final TextEditingController _cpEmailController = TextEditingController();

  bool _showOtherEnquiryField = false;
  String _selectedEnquiry = 'Select';
  final List<String> _enquiryOptions = [
    'Select',
    'pricing',
    'configuration',
    'possetion',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _dateTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
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
      appBar: AppBar(title: const Text('Enquiry Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Date-Time Field (current date-time)
              TextFormField(
                controller: _dateTimeController,
                decoration: const InputDecoration(labelText: 'Date & Time'),
                enabled: false,
              ),
              const SizedBox(height: 16),

              // Client Name Field
              TextFormField(
                controller: _clientNameController,
                decoration: const InputDecoration(labelText: 'Client Name'),
              ),
              const SizedBox(height: 16),

              // Client Phone Number Field
              TextFormField(
                controller: _clientPhoneNumberController,
                decoration:
                    const InputDecoration(labelText: 'Client Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Enquiry About Dropdown
              DropdownButtonFormField<String>(
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
                decoration: const InputDecoration(labelText: 'Enquiry About'),
              ),
              const SizedBox(height: 16),

              // Show other enquiry field if 'Other' is selected
              if (_showOtherEnquiryField)
                TextFormField(
                  controller: _otherEnquiryController,
                  decoration: const InputDecoration(labelText: 'Other Enquiry'),
                ),
              const SizedBox(height: 16),

              // CP Email Field
              TextFormField(
                controller: _cpEmailController,
                decoration: const InputDecoration(labelText: 'CP Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 100),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  const snackBar = SnackBar(
                    /// Need to set following properties for best effect of awesome_snackbar_content
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'Hey There!',
                      message: 'Welcome to EV Homes CRM',

                      /// Change contentType to ContentType.success, ContentType.warning, or ContentType.help for variants
                      contentType: ContentType.help,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomAppBar(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Constant.bgColor, // Text color
                  padding: const EdgeInsets.all(0.0), // Padding equivalent
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                    side:
                        const BorderSide(color: Colors.transparent, width: 1.0),
                  ),
                  fixedSize: const Size(230.0, 52.0), // Width and height
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 20.0, // Equivalent to title3 size
                    fontWeight: FontWeight.bold, // Similar to Manrope bold
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
